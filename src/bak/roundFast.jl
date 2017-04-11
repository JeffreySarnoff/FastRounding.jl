
function (+){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = eftSum2(a,b)
    eftRound(hi, lo, rounding)
end

function (-){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = eftDiff2(a,b)
    eftRound(hi, lo, rounding)
end

function (*){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = eftProd2(a,b)
    eftRound(hi, lo, rounding)
end

function (/){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = eftDiv2Approx(a,b)
    eftRound(hi, lo, rounding)
end

function (square){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = eftSquare(a,b)
    eftRound(hi, lo, rounding)
end

function (sqrt){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = eftSqrtApprox(a,b)
    eftRound(hi, lo, rounding)
end
