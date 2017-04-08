module FastRounding

using AdjacentFloats
using ErrorfreeArithmetic

set_rounding(Float64, RoundNearest)
set_rounding(Float32, RoundNearest)
#set_rounding(Float16, RoundNearest) Julia does not support this in v0.6.0-pre.beta.60


include("errorfreeRounding.jl")
include("roundedArithmetic.jl")

end # module
