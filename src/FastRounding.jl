module FastRounding

import Base: +, -, *, /, sqrt

setrounding(Float64, RoundNearest)
setrounding(Float32, RoundNearest)
# set_rounding(Float16, RoundNearest) Julia does not support this in v0.4

include("adjacent_float.jl")
include("error_free_arithmetic.jl")
include("rounding.jl")
include("rounded_arithmetic.jl")

end # module
