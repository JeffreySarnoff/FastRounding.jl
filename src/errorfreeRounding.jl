round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:ToZero}) =
    (signbit(hi)!=signbit(lo) ? next_nearerto_zero(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:FromZero}) =
    (signbit(hi)==signbit(lo) ? next_awayfrom_zero(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Up}) =
    (signbit(lo) ? hi : next_float(hi))

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Down}) =
    (signbit(lo) ? prev_float(hi) : hi)

round_errorfree{T<:AbstractFloat}(hi::T, lo::T, ::RoundingMode{:Nearest}) = hi
