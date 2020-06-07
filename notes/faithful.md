@assert isfinite(x) && !signbit(x)
faithful_sqrt = calc_faithful_sqrt(x)
e = fma(faithful_sqrt, faithful_sqrt, -x)

nearest_sqrt = iszero(e) ? faithful_sqrt : nextfloat(faithful_sqrt, ifelse(signbit(e), 1, -1))
rounddown_sqrt = iszero(e) ? faithful_sqrt : prevfloat(faithful_sqrt, ifelse(signbit(e), 0, 1))
roundup_sqrt   = iszero(e) ? faithful_sqrt : nextfloat(faithful_sqrt, ifelse(signbit(e), 1, 0))
