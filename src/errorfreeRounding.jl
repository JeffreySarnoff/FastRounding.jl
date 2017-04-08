
#=

       RoundDown
       hi  lo  rounding        fastrounding
       --------------------------------------------
       +   +   hi              hi
       +   -   prevfloat(hi)   next_nearerto_zero(hi) == prev_float(hi)
       -   +   hi              hi
       -   -   prevfloat(hi)   next_awayfrom_zero(hi) == prev_float(hi)

       RoundUp
       hi  lo  rounding        fastrounding
       --------------------------------------------
       +   +   nextfloat(hi)   next_awayfrom_zero(hi) == next_float(hi)
       +   -   hi              hi
       -   +   nextfloat(hi)   next_nearerto_zero(hi) == next_float(hi)
       -   -   hi              hi

       RoundFromZero
       hi  lo  rounding        fastrounding
       --------------------------------------------
       +   +   nextfloat(hi)   next_awayfrom_zero(hi)
       +   -   hi              hi
       -   +   hi              hi
       -   -   prevfloat(hi)   next_awayfrom_zero(hi)

       RoundToZero
       hi  lo  rounding        fastrounding
       --------------------------------------------
       +   +   hi              hi
       +   -   prevfloat(hi)   next_nearerto_zero(hi)
       -   +   nextfloat(hi)   next_nearerto_zero(hi)
       -   -   hi              hi

      RoundNearest
       hi  lo  rounding        fastrounding
       --------------------------------------------
       +   +   hi              hi
       +   -   hi              hi
       -   +   hi              hi
       -   -   hi              hi
=#


@inline round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:ToZero}) = 
    (signbit(hi)!=signbit(lo) ? nextNearerToZero(hi) : hi)

@inline round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:FromZero}) = 
    (signbit(hi)==signbit(lo) ? nextAwayFromZero(hi) : hi)

@inline round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Up}) = 
    (signbit(lo) ? hi : nextFloat(hi))

@inline round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Down}) = 
    (signbit(lo) ? prevFloat(hi) : hi)

@inline round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Nearest}) = (hi)

