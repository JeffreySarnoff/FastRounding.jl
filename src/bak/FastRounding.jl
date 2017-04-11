module FastRounding

import Base: (+),(-),(*),(/),(sqrt)

setrounding(Float64, RoundNearest)
setrounding(Float32, RoundNearest)

include("adjacentFloat.jl")
include("eftArith.jl")
include("eftRound.jl")
include("roundFast.jl")

end # module
