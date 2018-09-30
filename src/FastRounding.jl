module FastRounding

export add_round, sub_round, mul_round, square_round,
       inv_round, div_round, sqrt_round,
       ⊕₊, ⊕₋, ⊕₌, ⊕₀, ⊕₁,
       ⊖₊, ⊖₋, ⊖₌, ⊖₀, ⊖₁,
       ⊗₊, ⊗₋, ⊗₌, ⊗₀, ⊗₁,
       ⊘₊, ⊘₋, ⊘₌, ⊘₀, ⊘₁,
       ⊚₊, ⊚₋, ⊚₌, ⊚₀, ⊚₁,
       ⊙₊, ⊙₋, ⊙₌, ⊙₀, ⊙₁,
       ⚆₊, ⚆₋, ⚆₌, ⚆₀, ⚆₁


using ErrorfreeArithmetic
using Base: IEEEFloat

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware


@inline Base.trailing_zeros(x::Float64) = trailing_zeros(reinterpret(UInt64,x))
@inline Base.trailing_zeros(x::Float32) = trailing_zeros(reinterpret(UInt32,x))
@inline Base.trailing_zeros(x::Float16) = trailing_zeros(reinterpret(UInt16,x))

@inline isexactprod(a::Float64, b::Float64) = !signbit(trailing_zeros(a) + trailing_zeros(b) - 53)
@inline isexactprod(a::Float32, b::Float32) = !signbit(trailing_zeros(a) + trailing_zeros(b) - 24)
@inline isexactprod(a::Float16, b::Float16) = !signbit(trailing_zeros(a) + trailing_zeros(b) - 11)


@inline function add_round(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_sum(a, b)
    return round_errorfree(hi, lo, rounding)
end
add_round(a::T, b::T) where {T<:SysFloat} = a + b

⊕₌(a::T, b::T) where {T<:SysFloat} = add_round(a, b, RoundNearest)
⊕₊(a::T, b::T) where {T<:SysFloat} = add_round(a, b, RoundUp)
⊕₋(a::T, b::T) where {T<:SysFloat} = add_round(a, b, RoundDown)
⊕₀(a::T, b::T) where {T<:SysFloat} = add_round(a, b, RoundToZero)
⊕₁(a::T, b::T) where {T<:SysFloat} = add_round(a, b, RoundFromZero)

@inline function sub_round(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_diff(a, b)
    return round_errorfree(hi, lo, rounding)
end
sub_round(a::T, b::T) where {T<:SysFloat} = a - b

⊖₌(a::T, b::T) where {T<:SysFloat} = sub_round(a, b, RoundNearest)
⊖₊(a::T, b::T) where {T<:SysFloat} = sub_round(a, b, RoundUp)
⊖₋(a::T, b::T) where {T<:SysFloat} = sub_round(a, b, RoundDown)
⊖₀(a::T, b::T) where {T<:SysFloat} = sub_round(a, b, RoundToZero)
⊖₁(a::T, b::T) where {T<:SysFloat} = sub_round(a, b, RoundFromZero)


@inline function mul_round(a::T, b::T, rounding::RoundingMode) where {T<:SysFloat}
    isexactprod(a, b) && return a*b

    hi, lo = two_prod(a, b)
    if !(iszero(hi) || isinf(hi))
        round_errorfree(hi, lo, rounding)
    else
        mul_round_specialvalues(a, b, hi, rounding)
    end
end

function mul_round_specialvalues(a::T, b::T, hi::T, rounding::RoundingMode) where {T<:SysFloat}
    if iszero(hi)
        if iszero(a) || iszero(b)
            hi
        elseif rounding === RoundDown
            signbit(hi) ? prevfloat(zero(T)) : hi
        elseif rounding === RoundUp
            signbit(hi) ? hi : nextfloat(zero(T))
        else
            hi
        end
    else
        if isinf(a) || isinf(b)
            hi
        elseif rounding === RoundDown
            signbit(hi) ? hi : prevfloat(hi)
        elseif rounding === RoundUp
            signbit(hi) ? nextfloat(hi) : hi
        elseif rounding === RoundToZero
            signbit(hi) ? nextfloat(hi) : prevfloat(hi)
        else
            hi
        end
    end
end

mul_round(a::T, b::T) where {T<:SysFloat} = a * b

⊗₌(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundNearest)
⊗₊(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundUp)
⊗₋(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundDown)
⊗₀(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundToZero)
⊗₁(a::T, b::T) where {T<:SysFloat} = inv_round(a, b, RoundFromZero)

@inline function inv_round(a::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_inv(a)
    if !(iszero(hi) || isinf(hi))
        round_errorfree(hi, lo, rounding)
    else
        hi
    end
end

inv_round(a::T) where {T<:SysFloat} = inv(a)

⚆₌(a::T) where {T<:SysFloat} = inv_round(a, RoundNearest)
⚆₊(a::T) where {T<:SysFloat} = inv_round(a, RoundUp)
⚆₋(a::T) where {T<:SysFloat} = inv_round(a, RoundDown)
⚆₀(a::T) where {T<:SysFloat} = inv_round(a, RoundToZero)
⚆₁(a::T) where {T<:SysFloat} = inv_round(a, RoundFromZero)


@inline function div_round(a::T, b::T, rounding::RoundingMode) where {T<:SysFloat}
    hi, lo = two_div(a, b)
    if !(iszero(hi) || isinf(hi))
        round_errorfree(hi, lo, rounding)
    else
        hi
    end
end

div_round(a::T, b::T) where {T<:SysFloat} = a / b

⊘₌(a::T, b::T) where {T<:SysFloat} = div_round(a, b, RoundNearest)
⊘₊(a::T, b::T) where {T<:SysFloat} = div_round(a, b, RoundUp)
⊘₋(a::T, b::T) where {T<:SysFloat} = div_round(a, b, RoundDown)
⊘₀(a::T, b::T) where {T<:SysFloat} = div_round(a, b, RoundToZero)
⊘₁(a::T, b::T) where {T<:SysFloat} = div_round(a, b, RoundFromZero)

@inline function square_round(a::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_square(a)
    return round_errorfree(hi, lo, rounding)
end
square_round(a::T) where {T<:SysFloat} = a^2

⊚₌(a::T) where {T<:SysFloat} = square_round(a, b, RoundNearest)
⊚₊(a::T) where {T<:SysFloat} = square_round(a, b, RoundUp)
⊚₋(a::T) where {T<:SysFloat} = square_round(a, b, RoundDown)
⊚₀(a::T) where {T<:SysFloat} = square_round(a, b, RoundToZero)
⊚₁(a::T) where {T<:SysFloat} = square_round(a, b, RoundFromZero)

#=
IEEE 754-2008

sqrt(NaN, AnyRoundingMode) == NaN
sqrt(Inf, AnyRoundingMode) == Inf
sqrt(0.0, AnyRoundingMode) == 0.0
sqrt(-0.0, AnyRoundingMode) == -0.0
sqrt(x<0, AnyRoundingMode) is an error

let
  x  be a representable finite, nonnegative floating point number
  s₌ be the floating point value of sqrt(x) [RoundNearest]
  s₋ be the floating point value of sqrt(x) [RoundDown]
  s₊ be the floating point value of sqrt(x) [RoundUp]

by definition
  s₋ === s₌ || s₋ === prevfloat(s₌)
  s₊ === s₌ || s₊ === nextfloat(s₌)

one and only one of these three must hold
  (a) s₌ * s₌ === x
      ∴ s₊ === s₋ === s₌
  (b) s₌ * s₌ < x  && s₊ * s₊ > x
      ∴ s₊ === nextfloat(s₌)
  (c) s₌ * s₌ > x  && s₋ * s₋ < x
      ∴ s₋ === prevfloat(s₌)

if (a)
  RoundDown: return s₌
  RoundUp  : return s₌

if (b)
  RoundDown: return s₌
  RoundUp  : return nextfloat(s₌)

if (c)
  RoundDown: return prevfloat(s₌)
  RoundUp  : return s₌

:::::::::::::::::::::::::::::::::::::::

yet testing compared with these accurate values fails
    giving RoundUp, RoundNearest, RoundDown all as
    1.975754705372688e-77

julia> test = 3.9036066558023176e-154
julia> sqrt(test, RoundUp)      === 1.9757547053726885e-77
julia> sqrt(test, RoundNearest) === 1.975754705372688e-77
julia> sqrt(test, RoundDown)    === 1.975754705372688e-77

=#

@inline function sqrt_round(x::T, ::RoundingMode{:Down}) where T<:SysFloat
    y = sqrt(x)
    z = mul_round(y, y, RoundUp)
    if z > x
      y = prevfloat(y)
    end
    return y
end

@inline function sqrt_round(x::T, ::RoundingMode{:Up}) where T<:SysFloat
    y = sqrt(x)
    z = mul_round(y, y, RoundDown)
    if z < x
      y = nextfloat(y)
    end
    return y
end

@inline function sqrt_round(x::T, ::RoundingMode{:ToZero}) where T<:IEEEFloat
    y = sqrt(x)
    z = y * y
    if z > x
      y = prevfloat(y)
    end
    return y
end

@inline function sqrt_round(x::T, ::RoundingMode{:FromZero}) where T<:SysFloat
    y = sqrt(x)
    z = y * y
    if z < x
      y = nextfloat(y)
    end
    return y
end

sqrt_round(a::T) where {T<:SysFloat} = sqrt(a)

⊙₌(a::T) where {T<:SysFloat} = sqrt_round(a, RoundNearest)
⊙₊(a::T) where {T<:SysFloat} = sqrt_round(a, RoundUp)
⊙₋(a::T) where {T<:SysFloat} = sqrt_round(a, RoundDown)
⊙₀(a::T) where {T<:SysFloat} = sqrt_round(a, RoundToZero)
⊙₁(a::T) where {T<:SysFloat} = sqrt_round(a, RoundFromZero)


#=
    To perform arithmetic with directed rounding more rapidly
      we use error-free transformations to control rounding.
=#

@inline function round_errorfree(hi::T, lo::T, ::RoundingMode{:Nearest})::T where {T<:SysFloat}
     !isinf(hi) && return hi
     return signbit(hi) ? T(-Inf) : T(Inf)
end

@inline function round_errorfree(hi::T, lo::T, ::RoundingMode{:ToZero})::T where {T<:SysFloat}
     !isinf(hi) && return signbit(hi) != signbit(lo) ? next_nearerto_zero(hi) : hi
     return signbit(hi) ? nextfloat(T(-Inf)) : prevfloat(T(Inf))
end

@inline function round_errorfree(hi::T, lo::T, ::RoundingMode{:FromZero})::T where {T<:SysFloat}
    !isinf(hi) && return signbit(hi) == signbit(lo) ? next_awayfrom_zero(hi) : hi
    return signbit(hi) ? T(-Inf) : T(Inf)
end

@inline function round_errorfree(hi::T, lo::T, ::RoundingMode{:Up})::T where {T<:SysFloat}
    !isinf(hi) && return (lo<=zero(T) || isnan(lo))  ? hi : nextfloat(hi)
    return signbit(hi) ? nextfloat(T(-Inf)) : T(Inf)
end

@inline function round_errorfree(hi::T, lo::T, ::RoundingMode{:Down})::T where {T<:SysFloat}
    !isinf(hi) && return (lo>=zero(T) || isnan(lo))  ? hi : prevfloat(hi)
    return signbit(hi) ? T(-Inf) : prevfloat(T(Inf))
end

@inline next_nearerto_zero(x::T) where {T<:SysFloat} = !signbit(x) ? prevfloat(x) : nextfloat(x)
@inline next_awayfrom_zero(x::T) where {T<:SysFloat} = !signbit(x) ? nextfloat(x) : prevfloat(x)


end # module
