#=
       RoundDown
       hi  lo  rounding        fastrounding
       +   +   hi              hi
       +   -   prevfloat(hi)   nextNearerToZero(hi) == prevFloat(hi)
       -   +   hi              hi
       -   -   prevfloat(hi)   nextAwayFromZero(hi) == prevFloat(hi)
=#

@inline roundingDown{T<:AbstractFloat}(hi::T,lo::T) = (signbit(lo) ? prevFloat(hi) : hi)

function (+){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
    hi,lo = eftSum2(a,b)
    roundingDown(hi, lo)
end

function (-){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
    hi,lo = eftDiff2(a,b)
    roundingDown(hi, lo)
end

function (*){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
    hi,lo = eftProd2(a,b)
    roundingDown(hi, lo)
end

function (/){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
    hi,lo = eftDiv2Approx(a,b)
    roundingDown(hi, lo)
end

function (square){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
    hi,lo = eftSquare(a,b)
    roundingDown(hi, lo)
end

function (sqrt){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
    hi,lo = eftSqrtApprox(a,b)
    roundingDown(hi, lo)
end
