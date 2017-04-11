function Base.+{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = add_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function Base.-{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = subtract_errorfree(a,b)
    return round_errorfree(hi, lo, rounding)
end

function Base.*{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = multiply_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function Base.inv{T<:AbstractFloat, R<:RoundingMode}(a::T, rounding::R)
    hi, lo = inv_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end

function Base./{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = divide_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end

function square{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = square_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function Base.sqrt{T<:AbstractFloat, R<:RoundingMode}(a::T, b::T, rounding::R)
    hi, lo = sqrt_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end

