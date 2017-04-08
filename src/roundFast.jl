
function (+){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = add_errorfree(a, b)
    round_errorfree(hi, lo, rounding)
end

function (-){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = subtract_errorfree(a,b)
    round_errorfree(hi, lo, rounding)
end

function (*){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = multiply_errorfree(a, b)
    round_errorfree(hi, lo, rounding)
end

function (/){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = divide_accurately(a, b)
    round_errorfree(hi, lo, rounding)
end

function (square){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = square_errorfree(a, b)
    round_errorfree(hi, lo, rounding)
end

function (sqrt){T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi,lo = sqrt_accurately(a, b)
    round_errorfree(hi, lo, rounding)
end

