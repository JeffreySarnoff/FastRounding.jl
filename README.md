# FastRounding.jl
Faster directed rounding for inline arithmetic

## Quick Overview

* This package provides arithmetic with directed rounding    
  (RoundNearest, RoundUp, RoundDown, RoundToZero, RoundFromZero)
  
* Julia already does that. Our implementation is twice as fast.


We calculate two results of the LLVM's directed roundingbuilt-in  provides directed rounding for the basic arithmetic operations.

To perform arithmetic with directed rounding more rapidly than the LLVM allows, 
we provide our own directed rounding control and calculation for arithmetic operations.
manner of calculation  arithmetic with directed rounding results use error-free transformations to control rounding
      and quick, accurate float adjacency value calculation.

## Internal Logic

See AdjacentFloats.jl for `next_float`, `prev_float`, `next_nearerto_zero`, `next_nearerto_zero`.

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


