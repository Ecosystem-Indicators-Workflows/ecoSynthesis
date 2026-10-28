# Negative Value Matching

See `base::%in%` for details. `%nin%` is a binary operator, returning a
logical vector indicating if there is a negative match or not.

## Usage

``` r
lhs %nin% rhs
```

## Source

Function retrieved 2026-10-27 from
<https://stackoverflow.com/a/38352065>. Posted by catastrophic-failure,
modified by community, see also r-help post
<https://stat.ethz.ch/pipermail/r-help/2011-May/277498.html>. See post
'Timeline' for change history. License - CC BY-SA 4.0. Function
documentation written by Elliot Gould and JR Ferrer-Paris.

## Arguments

- lhs:

  vector or NULL: the values to be matched.
  [`Long vectors`](https://rdrr.io/r/base/LongVectors.html) are
  supported.

- rhs:

  vector or NULL: the values to be matched.
  [`Long vectors`](https://rdrr.io/r/base/LongVectors.html) are
  supported.

## Value

A logical vector indicating which value of `lhs` are *not* matched in
`rhs`

## Author

[catastrophic-failure](https://stackoverflow.com/users/2874779/catastrophic-failure),
Elliot Gould and JR Ferrer-Paris.

## Examples

``` r
"A" %nin% LETTERS[1:10]
#> [1] FALSE
TASVEG_LUT$eligible <- TASVEG_LUT$VEGCODE %nin% c("OAQ", "ORO", "OSM")
```
