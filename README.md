# FastRounding.jl
### Faster directed rounding for inline arithmetic


#### Copyright © 2015-2017 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/FastRounding.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/FastRounding.jl)

-----


## Quick Overview

* What we do is what Julia already does.  We do it considerably faster.

* This package provides arithmetic with directed rounding    

* The numeric types
  { Float32, Float64 }
  
* The arithmetic operations    
  { +, -, *, inv, /, sqrt }     

* The directed rounding modes    
  { RoundNearest, RoundUp, RoundDown, RoundToZero, RoundFromZero }
  
* Speedup is **2x** or better on many systems

* Speedup is **8x** or better with interval-reliant computations

-------

## Internal Logic

See [AdjacentFloats.jl](https://github.com/JeffreySarnoff/AdjacentFloats.jl) for `next_float`, `prev_float`, `next_nearerto_zero`, `next_nearerto_zero`.

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


