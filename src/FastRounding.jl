module FastRounding

export RoundToZero, RoundFromZero, RoundUp, RoundDown

set_rounding(Float64, RoundNearest)
set_rounding(Float32, RoundNearest)
set_rounding(Float16, RoundNearest)

include("eftArithmetic.jl")
include("adjacentFloat.jl")

include("RoundToZero.jl")
include("RoundFromZero.jl")
include("RoundUp.jl")
include("RoundDown.jl")

end # module
