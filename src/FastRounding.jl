module FastRounding

using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

set_rounding(Float64, RoundNearest)
set_rounding(Float32, RoundNearest)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:ToZero}) =
    (signbit(hi)!=signbit(lo) ? next_nearerto_zero(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:FromZero}) =
    (signbit(hi)==signbit(lo) ? next_awayfrom_zero(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Up}) =
    (signbit(lo) ? hi : next_float(hi))

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Down}) =
    (signbit(lo) ? prev_float(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Nearest}) = hi


include("errorfreeRounding.jl")
include("roundedArithmetic.jl")

end # module
