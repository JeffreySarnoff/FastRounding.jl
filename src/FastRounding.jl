module FastRounding

using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

set_rounding(Float64, RoundNearest)
set_rounding(Float32, RoundNearest)


function Base.+{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = add_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function Base.-{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = subtract_errorfree(a,b)
    return round_errorfree(hi, lo, rounding)
end

function Base.*{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = multiply_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function Base.inv{T<:AbstractFloat, R<:RoundingMode}(a::T, rounding::R)
    hi, lo = inv_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end

function Base./{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = divide_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end

function square{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = square_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function Base.sqrt{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
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
