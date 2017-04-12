module FastRounding

export add_round, sub_round, mul_round, sqr_round,
       inv_round, div_round, sqrt_round


using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

setrounding(Float64, RoundNearest)
setrounding(Float32, RoundNearest)

add_round{T<:SysFloat}(a::T, b::T) = a + b
function add_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = add_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

sub_round{T<:SysFloat}(a::T, b::T) = a - b
function sub_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = subtract_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

mul_round{T<:SysFloat}(a::T, b::T) = a * b
function mul_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = multiply_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

inv_round{T<:SysFloat}(a::T) = inv(a)
function inv_round{T<:SysFloat, R<:RoundingMode}(a::T, rounding::R)::T
    hi, lo = inv_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end

div_round{T<:SysFloat}(a::T, b::T) = a / b
function div_round{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = divide_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end

sqr_round{T<:SysFloat}(a::T) = a^2
function sqr_round{T<:SysFloat, R<:RoundingMode}(a::T, rounding::R)::T
    hi, lo = square_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end

sqrt_round{T<:SysFloat}(a::T) = sqrt(a)
function sqrt_round{T<:SysFloat, R<:RoundingMode}(a::T, rounding::R)::T
    hi, lo = sqrt_accurately(a)
    return round_errorfree(hi, lo, rounding)
end


round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:ToZero})::T =
    signbit(hi) != signbit(lo) ? AdjacentFloats.next_nearerto_zero(hi) : hi

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:FromZero})::T =
    signbit(hi) == signbit(lo) ? AdjacentFloats.next_awayfrom_zero(hi) : hi

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Up})::T =
    signbit(lo) ? hi : next_float(hi)

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Down})::T =
    signbit(lo) ? prev_float(hi) : hi

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Nearest})::T = hi

    
end # module
