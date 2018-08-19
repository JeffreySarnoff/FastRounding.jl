
## Internal Logic

#### RoundNearest

| sign of `hi` | sign of `lo` | rounding | fastrounding |
|:--:|:--:|:--:|:--:|
| +  | +   | `hi`  | `hi` |
| +  | -   | `hi`  | `hi` |
| -  | +   | `hi`  | `hi` |
| -  | -   | `hi`  | `hi` |

#### RoundDown

| sign of `hi` | sign of `lo` | rounding | fastrounding |
|:--:|:--:|:--:|:--:|
| +  | +   | `hi` | `hi` |
| +  | -   | `prevfloat(hi)`  | `next_nearerto_zero(hi) == prev_float(hi)` |
| -  | +   | `hi`  | `hi` |
| -  | -   | `prevfloat(hi)`  | `next_awayfrom_zero(hi) == prev_float(hi)` |

#### RoundUp

| sign of `hi` | sign of `lo` | rounding | fastrounding |
|:--:|:--:|:--:|:--:|
| +  | +   | `nextfloat(hi)` | `next_awayfrom_zero(hi) == next_float(hi)` |
| +  | -   | `hi`  | `hi` |
| -  | +   | `nextfloat(hi)` | `next_nearerto_zero(hi) == next_float(hi)` |
| -  | -   | `hi`  | `hi` |

#### RoundFromZero

| sign of `hi` | sign of `lo` | rounding | fastrounding |
|:--:|:--:|:--:|:--:|
| +  | +   | `nextfloat(hi)` | `next_awayfrom_zero(hi)` |
| +  | -   | `hi`  | `hi` |
| -  | +   | `hi`  | `hi` |
| -  | -   | `prevfloat(hi)` |  `next_awayfrom_zero(hi)` |


####  RoundToZero

| sign of `hi` | sign of `lo` | rounding | fastrounding |
|:--:|:--:|:--:|:--:|
| +  | +   | `hi`  | `hi` |
| +  | -   | `prevfloat(hi)` |  `next_nearerto_zero(hi)` |
| -  | +   | `nextfloat(hi)` | `next_nearerto_zero(hi)` |
| -  | -   | `hi`  | `hi` |

