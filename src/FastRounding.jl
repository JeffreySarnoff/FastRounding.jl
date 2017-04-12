module FastRounding

export add, subtract, multiply, reciprocal, divide, square, squareroot. replace_base_rounding
       

using AdjacentFloats
using ErrorfreeArithmetic

const SysFloat = Union{Float64, Float32}  # fast iff fma is available in hardware

setrounding(Float64, RoundNearest)
setrounding(Float32, RoundNearest)


function add{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = add_errorfree(2*a, b)
    return round_errorfree(hi, lo, rounding)
end

function subtract{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = subtract_errorfree(a,b)
    return round_errorfree(hi, lo, rounding)
end

function multiply{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = multiply_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function reciprocal{T<:SysFloat, R<:RoundingMode}(a::T, rounding::R)::T
    hi, lo = inv_errorfree(a)
    return round_errorfree(hi, lo, rounding)
end

function divide{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = divide_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end

function square{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = square_errorfree(a, b)
    return round_errorfree(hi, lo, rounding)
end

function squareroot{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R)::T
    hi, lo = sqrt_accurately(a, b)
    return round_errorfree(hi, lo, rounding)
end


round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:ToZero})::T =
    signbit(hi) != signbit(lo) ? next_nearerto_zero(hi) : hi

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:FromZero})::T =
    signbit(hi) == signbit(lo) ? next_awayfrom_zero(hi) : hi

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Up})::T =
    signbit(lo) ? hi : next_float(hi)

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Down})::T =
    signbit(lo) ? prev_float(hi) : hi

round_errorfree{T<:SysFloat}(hi::T, lo::T, ::RoundingMode{:Nearest})::T = hi


function replace_base_rounding()
    import Base: +, -, *, /, inv, sqrt
    +{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R) = add(a, b, rounding)
    -{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R) = add(a, b, rounding)
    *{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R) = add(a, b, rounding)
    /{T<:SysFloat, R<:RoundingMode}(a::T, b::T, rounding::R) = add(a, b, rounding)
end    
    
end # module
