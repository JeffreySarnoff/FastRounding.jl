#=
       RoundUp
       hi  lo  rounding        fastrounding
       +   +   nextfloat(hi)   nextAwayFromZero(hi) == nextFloat(hi)
       +   -   hi              hi
       -   +   nextfloat(hi)   nextNearerToZero(hi) == nextFloat(hi)
       -   -   hi              hi
=#

@inline roundingUp{T<:AbstractFloat}(hi::T,lo::T) = (signbit(lo) ? hi : nextFloat(hi))

function (+){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
    hi,lo = eftSum2(a,b)
    roundingUp(hi, lo)
end

function (-){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
    hi,lo = eftDiff2(a,b)
    roundingUp(hi, lo)
end

function (*){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
    hi,lo = eftProd2(a,b)
    roundingUp(hi, lo)
end

function (/){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
    hi,lo = eftDiv2Approx(a,b)
    roundingUp(hi, lo)
end

function (square){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
    hi,lo = eftSquare(a,b)
    roundingUp(hi, lo)
end

function (sqrt){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
    hi,lo = eftSqrtApprox(a,b)
    roundingUp(hi, lo)
end

