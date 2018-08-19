# FastRounding.jl
### Faster directed rounding for inline arithmetic


#### Copyright © 2015-2018 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/FastRounding.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/FastRounding.jl)

-----


## Quick Overview

* This package provides arithmetic with directed rounding

* The numeric types    
  { Float32, Float64 }
  
* The arithmetic operations
  { +, -, *, inv, /, sqrt }     

* The directed rounding modes    
  { RoundNearest, RoundUp, RoundDown, RoundToZero, RoundFromZero }
  
* These functions ran faster than Julia's erstwhile `setrounding`

-------

### Rounding Modes

- RoundNearest
- RoundUp
- RoundDown
- RoundToZero
- RoundFromZero

### Exports

- add_round, sub_round
- square_round, mul_round
- sqrt_round, inv_round
- div_round

### Equivalent Exports

| subscript | signifies mode |
|:---------:|:--------------|
| ◌₌        | RoundNearest  |
| ◌₊        | RoundUp       |
| ◌₋        | RoundDown     |
| ◌₀        | RoundToZero   |
| ◌₁        | RoundFromZero |
  
-----

| unicode op | arithmetic op |
|:----------:|:-------------:|
| ⊕          | +             |
| ⊖          | -             |
| ⊗          | *             |
| ⚆          | inv           |
| ⊘          | /             |
| ⊚          | square        |
| ⊙          | sqrt          |
 

## Use

```julia
julia> using FastRounding

julia> a = Float32(pi)
3.1415927f0

julia> b = inv(Float32(pi))
0.31830987f0

julia> mul_round(a, b, RoundUp)
1.0f0

julia> mul_round(a, b, RoundNearest)
1.0f0

julia> mul_round(a, b, RoundDown)
0.99999994f0

julia> mul_round(a, b, RoundToZero)
0.99999994f0

julia> mul_round(a, b, RoundFromZero)
1.0f0

julia> two = Float64(2)
2.0

julia> sqrt_round(two, RoundUp)
1.4142135623730951

julia> sqrt_round(two, RoundNearest)
1.4142135623730951

julia> sqrt_round(two, RoundDown)
1.414213562373095

julia> inv_round(-two, RoundToZero)
-0.5

julia> inv_round(-two, RoundFromZero)
-0.5000000000000001

julia> ⊙₋(two)  # sqrt(2) rounding down
1.414213562373095

julia> two ⊘₁ ans  # 2 / (sqrt(2) rounding down) rounding away from zero
1.4142135623730954

```

-------

## Conformance

These functions conform to the requirements of the IEEE Interval Floating Point Standard
for directed rounding, passing their tests as implemented in IntervalArithmetic.jl.

While not required by the IEEE Floating Point Standard, RoundToZero and RoundFromZero modes exist.

The determination of last bit(s) is correct to twice the significance of the rounded value.
We do not provide the equivalent of infinitly precise evaluation when at doubled the given
precision, all least significant bits are zero.  We are accurate and fast.

If you require that RoundUp, RoundDown pairs assure enclosure of the theoretical result
at a precision that exceeds 106 bits when working with Float64s (which have 53 significant bits),
please let me know.  I could force `nextfloat` and `prevfloat` calls in those cases, forgoing
the tightest results for the most inclusive.  Those routines run a little slower than these.
Note that those routines may not match the Standard test suite values in those adjusted cases.

