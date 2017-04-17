module FastRounding

export add_round, sub_round, mul_round, sqr_round,
       inv_round, div_round, sqrt_round

using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

setrounding(Float64, RoundNearest)
setrounding(Float32, RoundNearest)

@inline function add_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = add_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end
@inline add_round{T<:SysFloat}(a::T, b::T) = a + b

@inline function sub_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = subtract_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end
@inline sub_round{T<:SysFloat}(a::T, b::T) = a - b

@inline function mul_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = multiply_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end
@inline mul_round{T<:SysFloat}(a::T, b::T) = a * b

@inline function inv_round{T<:SysFloat, R<:RoundingMode}(a::T, rounding::R)::T
    hi, lo = inv_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end
@inline inv_round{T<:SysFloat}(a::T) = inv(a)

@inline function div_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = divide_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end
@inline div_round{T<:SysFloat}(a::T, b::T) = a / b

@inline function sqr_round{T<:SysFloat, R<:RoundingMode}(a::T, rounding::R)::T
    hi, lo = square_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end
@inline sqr_round{T<:SysFloat}(a::T) = a^2

@inline function sqrt_round{T<:SysFloat, R<:RoundingMode}(a::T, rounding::R)::T
    hi, lo = sqrt_accurately(a)
    return round_errorfree(hi, lo, rounding)
end
@inline sqrt_round{T<:SysFloat}(a::T) = sqrt(a)

#=
    To perform arithmetic with directed rounding more rapidly
      we use error-free transformations to control rounding
      and quick, accurate float adjacency value calculation.
=#      

@inline round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Nearest}) = hi

@inline round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:ToZero}) =
    signbit(hi) != signbit(lo) ? AdjacentFloats.next_nearerto_zero(hi) : hi

@inline round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:FromZero}) =
    signbit(hi) == signbit(lo) ? AdjacentFloats.next_awayfrom_zero(hi) : hi

@inline round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Up}) =
    lo<=zero(T)  ? hi : next_float(hi)

@inline round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Down}) =
    signbit(lo) ? prev_float(hi) : hi

    
end # module
