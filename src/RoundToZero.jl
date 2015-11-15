#=
       RoundToZero
       hi  lo  rounding        fastrounding
       +   +   hi              hi
       +   -   prevfloat(hi)   nextNearerToZero(hi)
       -   +   hi              hi
       -   -   nextfloat(hi)   nextNearerToZero(hi)
=#

@inline roundingToZero{T<:AbstractFloat}(hi::T,lo::T) = (signbit(lo) ? nextNearerToZero(hi) : hi)

function (+){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:ToZero})
    hi,lo = eftSum2(a,b)
    roundingToZero(hi, lo)
end

function (-){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:ToZero})
    hi,lo = eftDiff2(a,b)
    roundingToZero(hi, lo)
end

function (*){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:ToZero})
    hi,lo = eftProd2(a,b)
    roundingToZero(hi, lo)
end

function (/){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:ToZero})
    hi,lo = eftDiv2Approx(a,b)
    roundingToZero(hi, lo)
end

function (square){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:ToZero})
    hi,lo = eftSquare(a,b)
    roundingToZero(hi, lo)
end

function (sqrt){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:ToZero})
    hi,lo = eftSqrtApprox(a,b)
    roundingToZero(hi, lo)
end



