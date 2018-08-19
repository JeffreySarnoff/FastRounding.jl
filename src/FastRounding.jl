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

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware


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

@inline function mul_round(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_prod(a, b)
    return round_errorfree(hi, lo, rounding)
end
mul_round(a::T, b::T) where {T<:SysFloat} = a * b

⊗₌(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundNearest)
⊗₊(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundUp)
⊗₋(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundDown)
⊗₀(a::T, b::T) where {T<:SysFloat} = mul_round(a, b, RoundToZero)
⊗₁(a::T, b::T) where {T<:SysFloat} = inv_round(a, b, RoundFromZero)

@inline function inv_round(a::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_inv(a)
    return round_errorfree(hi, lo, rounding)
end
inv_round(a::T) where {T<:SysFloat} = inv(a)

⚆₌(a::T) where {T<:SysFloat} = inv_round(a, RoundNearest)
⚆₊(a::T) where {T<:SysFloat} = inv_round(a, RoundUp)
⚆₋(a::T) where {T<:SysFloat} = inv_round(a, RoundDown)
⚆₀(a::T) where {T<:SysFloat} = inv_round(a, RoundToZero)
⚆₁(a::T) where {T<:SysFloat} = inv_round(a, RoundFromZero)

@inline function div_round(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_div(a, b)
    return round_errorfree(hi, lo, rounding)
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

@inline function sqrt_round(a::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_sqrt(a)
    return round_errorfree(hi, lo, rounding)
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
