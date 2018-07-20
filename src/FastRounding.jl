module FastRounding

export add_round, sub_round, mul_round, sqr_round,
       inv_round, div_round, sqrt_round

using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

setrounding(Float64, RoundNearest)
setrounding(Float32, RoundNearest)

@inline function add_round(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_sum(a, b)
    return round_errorfree(hi, lo, rounding)
end
add_round(a::T, b::T) where {T<:SysFloat} = a + b

@inline function sub_round(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_diff(a, b)
    return round_errorfree(hi, lo, rounding)
end
sub_round(a::T, b::T) where {T<:SysFloat} = a - b

@inline function mul_round(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_prod(a, b)
    return round_errorfree(hi, lo, rounding)
end
mul_round(a::T, b::T) = a * b

@inline function inv_round(a::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_inv(a)
    return round_errorfree(hi, lo, rounding)
end
inv_round(a::T) where {T<:SysFloat} = inv(a)

@inline function div_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_div(a, b)
    return round_errorfree(hi, lo, rounding)
end
div_round(a::T, b::T) where {T<:SysFloat} = a / b

@inline function square_round(a::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_square(a)
    return round_errorfree(hi, lo, rounding)
end
square_round(a::T) where {T<:SysFloat} = a^2

@inline function sqrt_round(a::T, rounding::R)::T where {T<:SysFloat, R<:RoundingMode}
    hi, lo = two_sqrt(a)
    return round_errorfree(hi, lo, rounding)
end
sqrt_round(a::T) where {T<:SysFloat} = sqrt(a)

#=
    To perform arithmetic with directed rounding more rapidly
      we use error-free transformations to control rounding
      and quick, accurate float adjacency value calculation.
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
    !isinf(hi) && return (lo<=zero(T) || isnan(lo))  ? hi : next_float(hi)
    return signbit(hi) ? nextfloat(T(-Inf)) : T(Inf)
end

@inline function round_errorfree(hi::T, lo::T, ::RoundingMode{:Down})::T where {T<:SysFloat}
    !isinf(hi) && return (lo>=zero(T) || isnan(lo))  ? hi : prev_float(hi)
    return signbit(hi) ? T(-Inf) : prevfloat(T(Inf))
end

@inline next_nearerto_zero(x::T) where {T<:SysFloat} = !signbit(x) ? prevfloat(x) : nextfloat(x)
@inline next_awayfrom_zero(x::T) where {T<:SysFloat} = !signbit(x) ? nextfloat(x) : prevfloat(x)

end # module
