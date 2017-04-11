# FastRounding.jl
Faster directed rounding for inline arithmetic


## Internal Logic

#### RoundDown

| sign of `hi` | sign of `lo` | rounding | fastrounding |
|:--:|:--:|:--|:--|
| +  | +   | `hi` | `hi` |
| +  | -   | `prevfloat(hi)`  | `next_nearerto_zero(hi) == prev_float(hi)` |
| -  | +   | `hi`  | `hi` |
| -  | -   | `prevfloat(hi)`  | `next_awayfrom_zero(hi) == prev_float(hi)` |

| RoundUp |
|:--------|

| sign of `hi` | sign of `lo` | rounding | fastrounding |
|:--:|:--:|:--|:--|
| +  | +   | nextfloat(hi) | next_awayfrom_zero(hi) == next_float(hi) |
| +  | -   | `hi`  | `hi` |
| -  | +   | nextfloat(hi) | next_nearerto_zero(hi) == next_float(hi) |
| -  | -   | `hi`  | `hi` |

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
