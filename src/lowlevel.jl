# copied from Base/rounding.jl

const fenv = Vector{Cint}(undef, 9)
ccall(:jl_get_fenv_consts, Cvoid, (Ptr{Cint},), fenv)

const FENV_ROUND_TONEAREST  = fenv[6]
const FENV_ROUND_UPWARD     = fenv[7]
const FENV_ROUND_DOWNWARD   = fenv[8]
const FENV_ROUND_TOWARDZERO = fenv[9]

# cobbled to cover deprecation of setrounding(Type, RoundingMode)

@inline fenv_setrounding_nearest() = ccall(:fesetround,Int32,(Int32,), FENV_ROUND_TONEAREST)
@inline fenv_setrounding_up()      = ccall(:fesetround,Int32,(Int32,), FENV_ROUND_UPWARD)
@inline fenv_setrounding_down()    = ccall(:fesetround,Int32,(Int32,), FENV_ROUND_DOWNWARD)
@inline fenv_setrounding_tozero()  = ccall(:fesetround,Int32,(Int32,), FENV_ROUND_TOWARDZERO)

@inline set_rounding(RoundNearest) = fenv_setrounding_nearest()
@inline set_rounding(RoundUp)      = fenv_setrounding_up()
@inline set_rounding(RoundDown)    = fenv_setrounding_down()
@inline set_rounding(RoundToZero)  = fenv_setrounding_tozero()

fenv_getrounding() = ccall(:fegetround, Int32, ())

function get_rounding()
   fenv_rounding = fenv_getrounding()
   fenv_rounding === FENV_ROUND_TONEAREST  && return RoundNearest
   fenv_rounding === FENV_ROUND_DOWNWARD   && return RoundDown
   fenv_rounding === FENV_ROUND_UPWARD     && return RoundUp
   fenv_rounding === FENV_ROUND_TOWARDZERO && return RoundToZero
   throw(ErrorException("This should occur.  Please raise an issue at Fastrounding.jl with what `versioninfo()` prints and saying: (fenv_rounding == $fenv_rounding)"))
end

for (F,R) in ((:round_nearest, :RoundNearest), (:round_up, :RoundUp),
              (:round_down, :RoundDown), (:round_tozero, :RoundToZero))
  @eval begin
    function $F(op::Function, arg::T) where {T<:AbstractFloat}
        old_rounding = get_rounding()
        set_rounding($R)
        res = op(arg)
        set_rounding(old_rounding)
        return res
    end
    function $F(op::Function, arg1::T, arg2::T) where {T<:AbstractFloat}
        old_rounding = get_rounding()
        set_rounding($R)
        res = op(arg1, arg2)
        set_rounding(old_rounding)
        return res
    end
    function $F(op::Function, arg1::T, arg2::T, arg3::T) where {T<:AbstractFloat}
        old_rounding = get_rounding()
        set_rounding($R)
        res = op(arg1, arg2, arg3)
        set_rounding(old_rounding)
        return res
    end
  end
end
