# Summarise a membership matrix

Summarise a membership matrix

## Usage

``` r
summarise_membership(data, keep_all = TRUE, which_round = NULL)
```

## Arguments

- data:

  A `membership_tbl` object containing membership data in long format,
  with columns for source, target, membership, interpreter, and round
  values.

- keep_all:

  Logical, defaults to FALSE (keep only the best candidate). If TRUE the
  result will keep all candidates.

- which_round:

  A numeric value of length 1 matching the selected round in `data`.
  Defaults to NULL, which matches the highest round available in `data`.

## Value

A `membership_summary` object.

## Details

Returns the `membership summary` which is a `membership_tbl` with
aggregated membership values and extra information.

### Future Enhancements

The function is designed to be flexible and can be extended in the
future. Users may filter by round of elicitation.

## Author

JR Ferrer-Paris

## Examples

``` r
# Example usage with the TASVEG_xref dataset
data("TASVEG_xref")
TASVEG_memb <- membership_tbl(
  TASVEG_xref,
  source_id = "VEGCODE",
  target_id = "efg",
  membership = "memb",
  interpreter = "interp",
  round = "round"
)
res <- summarise_membership(TASVEG_memb)
#> No round selected, defaults to last round 1.
subset(res,total_memb > total_interp)
#> ── <membership_summary> ────────────────────────────────────────────────────────
#> ℹ source_id column: `VEGCODE`
#> ℹ target_id column: `efg`
#> ✔ `summarise_membership(data = TASVEG_memb)`
#> # A tibble: 7 × 7
#>   VEGCODE efg   round prop_memb total_memb supporting total_interp
#>   <chr>   <chr> <int>     <dbl>      <dbl>      <int>        <int>
#> 1 AHF     F2.2      1    0.242        4.07          3            4
#> 2 AHF     F2.3      1    0.516        4.07          4            4
#> 3 AHF     TF1.3     1    0.217        4.07          4            4
#> 4 AHF     F3.1      1    0.0246       4.07          1            4
#> 5 MBS     TF1.6     1    0.963        4.05          4            4
#> 6 MBS     T3.2      1    0.0247       4.05          1            4
#> 7 MBS     TF1.2     1    0.0123       4.05          1            4
subset(res,total_memb < total_interp * 0.99)
#> ── <membership_summary> ────────────────────────────────────────────────────────
#> ℹ source_id column: `VEGCODE`
#> ℹ target_id column: `efg`
#> ✔ `summarise_membership(data = TASVEG_memb)`
#> # A tibble: 12 × 7
#>    VEGCODE efg   round prop_memb total_memb supporting total_interp
#>    <chr>   <chr> <int>     <dbl>      <dbl>      <int>        <int>
#>  1 NAD     T2.5      1    0.842        3.8           4            4
#>  2 NAD     TF1.2     1    0.105        3.8           1            4
#>  3 NAD     T2.4      1    0.0526       3.8           1            4
#>  4 OAQ     F1.1      1    0.08         3.89          3            4
#>  5 OAQ     F1.2      1    0.106        3.89          3            4
#>  6 OAQ     F1.4      1    0.0543       3.89          2            4
#>  7 OAQ     F1.5      1    0.0543       3.89          2            4
#>  8 OAQ     F2.1      1    0.154        3.89          3            4
#>  9 OAQ     F2.2      1    0.234        3.89          4            4
#> 10 OAQ     F2.3      1    0.0543       3.89          2            4
#> 11 OAQ     F3.1      1    0.209        3.89          4            4
#> 12 OAQ     F3.2      1    0.0543       3.89          2            4
```
