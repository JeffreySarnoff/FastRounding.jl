
# functions of one argument

@inline function eftSquare{T<:AbstractFloat}(a::T)
    x = a * a
    y = fma(a, a, -x)
    x,y
end

function eftCube{T<:AbstractFloat}(a::T)
    p = a*a; e = fma(a, a, -p)
    x = p*a; p = fma(p, a, -x)
    y = e*a
    x,y
end

# !!sassafrass!!
# 'y' must be negated to get the right result
# I do not know why.
#
@inline function eftRecip{T<:AbstractFloat}(a::T)
     x = one(Float64)/a
     y = -fma(x,a,-1.0)/a
     x,y
end

# when only the sign of y is needed, omit the final division
@inline function eftRecipApprox{T<:AbstractFloat}(a::T)
     x = one(Float64)/a
     y = -fma(x,a,-1.0)
     x,y
end

#=
   While not strictly an error-free transformation it is quite reliable and recommended for use.
   Augmented precision square roots, 2-D norms and discussion on correctly reounding sqrt(x^2 + y^2)
   by Nicolas Brisebarre, Mioara Joldes, Erik Martin-Dorel, Hean-Michel Muller, Peter Kornerup
=#
@inline function eftSqrt{T<:AbstractFloat}(a::T)
     x = sqrt(a)
     t = fma(x,-x,a)
     y = t / (x*2.0)
     x,y
end     

# when only the sign of y is needed, omit the final division
@inline function eftSqrtApprox{T<:AbstractFloat}(a::T)
     x = sqrt(a)
     y = fma(x,-x,a)
     x,y
end     

     
# functions of two arguments

@inline function eftSum2{T<:AbstractFloat}(a::T, b::T)
  x = a + b
  t = x - a
  y = (a - (x - t)) + (b - t)
  x,y
end


# only use where |a| <= |b|
@inline function eftSum2inOrder{T<:AbstractFloat}(a::T, b::T)
  x = a + b
  y = b - (x - a)
  x,y
end


@inline function eftDiff2{T<:AbstractFloat}(a::T, b::T)
  x = a - b
  t = x - a
  y = (a - (x - t)) - (b + t)
  x,y
end


# only use where |a| <= |b|
@inline function eftDiff2inOrder{T<:AbstractFloat}(a::T, b::T)
  x = a - b
  y = (a - x) - b
  x,y
end

@inline function eftProd2{T<:AbstractFloat}(a::T, b::T)
    x = a * b
    y = fma(a, b, -x)
    x,y
end

# !!sassafrass!!
# 'y' must be negated to get the right result
# I do not know why.

@inline function eftDiv2{T<:AbstractFloat}(a::T,b::T)
     x = a/b
     y = -(fma(x,b,-a)/b)
     x,y
end

# when only the sign of y is needed, omit the final division
@inline function eftDiv2Approx{T<:AbstractFloat}(a::T,b::T)
     x = a/b
     y = -fma(x,b,-a)
     x,y
end

