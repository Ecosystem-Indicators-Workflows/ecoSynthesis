# Calculate the entropy of a membership function represented as a probability vector

Calculate the entropy of a membership function represented as a
probability vector

## Usage

``` r
calc_entropy_tbl(
  data,
  sources = NULL,
  targets = NULL,
  round = NULL,
  overall = NULL
)
```

## Arguments

- data:

  A `membership_tbl` object returned by
  [`membership_tbl()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/membership_tbl.md).

- sources:

  A character vector of `source` units to compare. If `NULL` (default),
  all `source` units are used.

- targets:

  A character vector of `target` units to compare. If `NULL` (default),
  all `target` units are used.

- round:

  A numeric value representing the round to consider. If `NULL`
  (default), all rounds are considered.

- overall:

  A character string specifying the level at which to calculate overall
  entropy. Options are "by_source", "by_target", "by_interpreter", or
  "overall". If `NULL` (default), entropy is calculated for each
  source-interpreter combination.

## Value

A data frame with interpreter-normalised, source-normalised and
set-normalised entropy values. Defaults to source-interpreter entropy
(averaged across interpreters for each source unit per round) if
`overall` is `NULL`. If `overall` is specified, returns the mean entropy
values based on the specified level.

## Examples

``` r
data("TASVEG_xref")
TASVEG_memb <- TASVEG_xref |> dplyr::filter(VEGCODE %nin% c("AHF", "DOW", "MBS", "OAQ", "NAD")) |> membership_tbl(
  source_id = "VEGCODE",
  target_id = "efg",
  membership = "memb",
  interpreter = "interp"
)
  #TODO rm filter
TASVEG_memb  |> calc_entropy_tbl()
#> # A tibble: 604 × 9
#>    VEGCODE round interp          N_targets_interp N_targets_source N_targets_set
#>    <chr>   <int> <chr>                      <int>            <int>         <int>
#>  1 FWU         1 Frightened Fla…                5                5            37
#>  2 FWU         1 Worrysome Wren                 5                5            37
#>  3 AUS         1 Tantalising Ta…                2                2            37
#>  4 FAL         1 Tantalising Ta…                2                2            37
#>  5 RKS         1 Tantalising Ta…                2                2            37
#>  6 SLL         1 Worrysome Wren                 2                2            37
#>  7 FPE         1 Pointless Panda                2                2            37
#>  8 WSU         1 Tantalising Ta…                3                3            37
#>  9 ASF         1 Tantalising Ta…                2                2            37
#> 10 DAD         1 Tantalising Ta…                2                2            37
#> # ℹ 594 more rows
#> # ℹ 3 more variables: entropy_source_normalised <dbl>,
#> #   entropy_interpreter_normalised <dbl>, entropy_set_normalised <dbl>
TASVEG_memb  |> calc_entropy_tbl(overall = "by_source")
#> # A tibble: 151 × 5
#>    VEGCODE round mean_by_source_entropy_source_normalised mean_by_source_entro…¹
#>    <chr>   <int>                                    <dbl>                  <dbl>
#>  1 DPD         1                                    0.949                  0.949
#>  2 SSK         1                                    0.949                  0.949
#>  3 FAL         1                                    0.933                  0.933
#>  4 SLL         1                                    0.916                  0.916
#>  5 DSC         1                                    0.881                  0.881
#>  6 NAR         1                                    0.841                  0.841
#>  7 DVF         1                                    0.801                  0.801
#>  8 RPW         1                                    0.720                  0.891
#>  9 FWU         1                                    0.707                  0.741
#> 10 SRF         1                                    0.689                  0.770
#> # ℹ 141 more rows
#> # ℹ abbreviated name: ¹​mean_by_source_entropy_interpreter_normalised
#> # ℹ 1 more variable: mean_by_source_entropy_set_normalised <dbl>
TASVEG_memb |> calc_entropy_tbl(overall = "by_interpreter")
#> # A tibble: 4 × 5
#>   interp                round mean_by_interpreter_entro…¹ mean_by_interpreter_…²
#>   <chr>                 <int>                       <dbl>                  <dbl>
#> 1 Tantalising Tarantula     1                       0.440                  0.510
#> 2 Pointless Panda           1                       0.303                  0.350
#> 3 Frightened Flamingo       1                       0.160                  0.210
#> 4 Worrysome Wren            1                       0.155                  0.200
#> # ℹ abbreviated names: ¹​mean_by_interpreter_entropy_source_normalised,
#> #   ²​mean_by_interpreter_entropy_interpreter_normalised
#> # ℹ 1 more variable: mean_by_interpreter_entropy_set_normalised <dbl>
TASVEG_memb |> calc_entropy_tbl(overall = "by_target")
#> # A tibble: 37 × 5
#>    efg   round mean_by_target_entropy_source_normalised mean_by_target_entropy…¹
#>    <chr> <int>                                    <dbl>                    <dbl>
#>  1 T7.1      1                                    0.820                    0.837
#>  2 MT1.1     1                                    0.644                    0.644
#>  3 T3.4      1                                    0.644                    0.644
#>  4 T7.2      1                                    0.585                    0.747
#>  5 MT1.4     1                                    0.482                    0.579
#>  6 T7.5      1                                    0.474                    0.643
#>  7 MT3.1     1                                    0.463                    0.678
#>  8 T3.1      1                                    0.463                    0.678
#>  9 T4.4      1                                    0.416                    0.499
#> 10 TF1.2     1                                    0.413                    0.542
#> # ℹ 27 more rows
#> # ℹ abbreviated name: ¹​mean_by_target_entropy_interpreter_normalised
#> # ℹ 1 more variable: mean_by_target_entropy_set_normalised <dbl>
TASVEG_memb |> calc_entropy_tbl(overall = "overall")
#> # A tibble: 1 × 4
#>   round mean_entropy_source_norm…¹ mean_entropy_interpr…² mean_entropy_set_nor…³
#>   <int>                      <dbl>                  <dbl>                  <dbl>
#> 1     1                      0.265                  0.318                 0.0706
#> # ℹ abbreviated names: ¹​mean_entropy_source_normalised,
#> #   ²​mean_entropy_interpreter_normalised, ³​mean_entropy_set_normalised
TASVEG_memb |> calc_entropy_tbl(sources = c("AHL", "WVI"))
#> # A tibble: 8 × 9
#>   VEGCODE round interp           N_targets_interp N_targets_source N_targets_set
#>   <chr>   <int> <chr>                       <int>            <int>         <int>
#> 1 WVI         1 Tantalising Tar…                2                2             7
#> 2 AHL         1 Pointless Panda                 4                5             7
#> 3 AHL         1 Frightened Flam…                1                5             7
#> 4 AHL         1 Tantalising Tar…                1                5             7
#> 5 AHL         1 Worrysome Wren                  1                5             7
#> 6 WVI         1 Frightened Flam…                1                2             7
#> 7 WVI         1 Pointless Panda                 1                2             7
#> 8 WVI         1 Worrysome Wren                  1                2             7
#> # ℹ 3 more variables: entropy_source_normalised <dbl>,
#> #   entropy_interpreter_normalised <dbl>, entropy_set_normalised <dbl>
TASVEG_memb |> calc_entropy_tbl(targets = c("MT1.4"))
#> # A tibble: 8 × 9
#>   VEGCODE round interp           N_targets_interp N_targets_source N_targets_set
#>   <chr>   <int> <chr>                       <int>            <int>         <int>
#> 1 ORO         1 Frightened Flam…                3                3             6
#> 2 ORO         1 Pointless Panda                 3                3             6
#> 3 ORO         1 Worrysome Wren                  3                3             6
#> 4 OSM         1 Tantalising Tar…                3                4             6
#> 5 OSM         1 Worrysome Wren                  2                4             6
#> 6 OSM         1 Frightened Flam…                2                4             6
#> 7 ORO         1 Tantalising Tar…                1                3             6
#> 8 OSM         1 Pointless Panda                 1                4             6
#> # ℹ 3 more variables: entropy_source_normalised <dbl>,
#> #   entropy_interpreter_normalised <dbl>, entropy_set_normalised <dbl>
```
