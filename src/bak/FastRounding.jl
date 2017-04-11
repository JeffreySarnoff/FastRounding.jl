module FastRounding

import Base: (+),(-),(*),(/),(sqrt)

set_rounding(Float64, RoundNearest)
set_rounding(Float32, RoundNearest)
#set_rounding(Float16, RoundNearest) Julia does not support this in v0.4

include("adjacentFloat.jl")
include("eftArith.jl")
include("eftRound.jl")
include("roundFast.jl")

end # module
