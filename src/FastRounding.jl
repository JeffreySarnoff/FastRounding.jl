module FastRounding

import (+),(-),(*),(/),(sqrt)

set_rounding(Float64, RoundNearest)
set_rounding(Float32, RoundNearest)
set_rounding(Float16, RoundNearest)

include("adjacentFloat.jl")
include("eftArithmetic.jl")
include("eftRounding.jl")

end # module
