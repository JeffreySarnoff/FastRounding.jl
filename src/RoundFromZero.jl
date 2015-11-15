#=
       RoundFromZero
       hi  lo  rounding        fastrounding
       +   +   nextfloat(hi)   nextAwayFromZero(hi)
       +   -   hi              hi
       -   +   hi              hi
       -   -   prevfloat(hi)   nextAwayFromZero(hi
=#

@inline roundingFromZero{T<:AbstractFloat}(hi::T,lo::T) = (signbit(hi)==signbit(lo) ? nextAwayFromZero(hi) : hi)

function (+){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:FromZero})
    hi,lo = eftSum2(a,b)
    roundingFromZero(hi, lo)
end

function (-){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:FromZero})
    hi,lo = eftDiff2(a,b)
    roundingFromZero(hi, lo)
end

function (*){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:FromZero})
    hi,lo = eftProd2(a,b)
    roundingFromZero(hi, lo)
end

function (/){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:FromZero})
    hi,lo = eftDiv2Approx(a,b)
    roundingFromZero(hi, lo)
end

function (square){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:FromZero})
    hi,lo = eftSquare(a,b)
    roundingFromZero(hi, lo)
end

function (sqrt){T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:FromZero})
    hi,lo = eftSqrtApprox(a,b)
    roundingFromZero(hi, lo)
end

