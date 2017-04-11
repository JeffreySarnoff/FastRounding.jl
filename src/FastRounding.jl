module FastRounding

using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

set_rounding(Float64, RoundNearest)
set_rounding(Float32, RoundNearest)

include("errorfreeRounding.jl")
include("roundedArithmetic.jl")

end # module
