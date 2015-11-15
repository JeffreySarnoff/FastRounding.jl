#=
  These routines return +/-Inf when given +/-Inf.
  That differs from nextfloat(-Inf) == -realmax(), prevfloat(Inf) == realmax().
  And steps twice when given values of very small magnitude (see paper).
  ref:
  'Predecessor and Successor In Rounding To Nearest' by Siegried M. Rump
  "The routines deliver the exact answer except for a small range near underflow,
   in which case the true result is overestimated by eta [the value added/subtracted below]."
=#
# exact for |x| > 8.900295434028806e-308
nextNearerToZero(x::Float64)   = (0.9999999999999999*x)-5.0e-324 # (x-1.1102230246251568e-16*x)-5.0e-324 
nextAwayFromZero(x::Float64)   = (1.0000000000000002*x)+5.0e-324 # (x+1.1102230246251568e-16*x)+5.0e-324
secondNearerToZero(x::Float64) = (0.9999999999999998*x)-5.0e-324
secondAwayFromZero(x::Float64) = (1.0000000000000004*x)+5.0e-324
# exact for |x| > 4.814825f-35
nextNearerToZero(x::Float32)   = (0.99999994f0*x)-1.435f-42      # (x-5.960465f-8*x)-1.435f-42
nextAwayFromZero(x::Float32)   = (1.00000010f0*x)+1.435f-42      # (x+5.960465f-8*x)+1.435f-42
secondNearerToZero(x::Float32) = (0.99999990f0*x)-1.435f-42
secondAwayFromZero(x::Float32) = (1.00000020f0*x)+1.435f-42
# the multiplicative formulation for Float16 is exact for |x| > Float16(0.25)
# which is quite coarse, we do not use that here
nextNearerToZero(x::Float16) = (x < 0) ? nextfloat(x) : prevfloat(x)
nextAwayFromZero(x::Float16) = (x < 0) ? prevfloat(x) : nextfloat(x)
secondNearerToZero(x::Float16) = (x < 0) ? nextfloat(nextfloat(x)) : prevfloat(prevfloat(x))
secondAwayFromZero(x::Float16) = (x < 0) ? prevfloat(prevfloat(x)) : nextfloat(nextfloat(x))

nextFloat{T<:AbstractFloat}(x::T) = signbit(x) ? nextNearerToZero(x) : nextAwayFromZero(x)
prevFloat{T<:AbstractFloat}(x::T) = signbit(x) ? nextAwayFromZero(x) : nextNearerToZero(x)
nextnextFloat{T<:AbstractFloat}(x::T) = signbit(x) ? secondNearerToZero(x) : secondAwayFromZero(x)
prevprevFloat{T<:AbstractFloat}(x::T) = signbit(x) ? secondAwayFromZero(x) : secondNearerToZero(x)
