module FastRounding

export square
import Base.Math: +, -, *, /, inv, sqrt

using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

setrounding(Float64, RoundNearest)
setrounding(Float32, RoundNearest)


function +{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = add_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function -{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = subtract_errorfree(a,b)
    return round_errorfree(hi, lo, rounding)
end

function *{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = multiply_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function inv{T<:AbstractFloat, R<:RoundingMode}(a::T, rounding::R)
    hi, lo = inv_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end

function /{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = divide_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end

function square{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = square_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function sqrt{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = sqrt_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end


round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:ToZero}) =
    (signbit(hi)!=signbit(lo) ? next_nearerto_zero(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:FromZero}) =
    (signbit(hi)==signbit(lo) ? next_awayfrom_zero(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Up}) =
    (signbit(lo) ? hi : next_float(hi))

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Down}) =
    (signbit(lo) ? prev_float(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Nearest}) = hi

end # module
