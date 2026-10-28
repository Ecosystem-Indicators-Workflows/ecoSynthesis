# Working with membership tables

This is an example with our internal dataset, first take a look at the
data structure

``` r

library(ecoSynthesis)
data("TASVEG_xref")
head(TASVEG_xref)
#> # A tibble: 6 × 5
#>   VEGCODE efg    memb interp                round
#>   <chr>   <chr> <dbl> <chr>                 <int>
#> 1 AAP     TF1.7   1   Frightened Flamingo       1
#> 2 AAP     TF1.7   1   Worrysome Wren            1
#> 3 AAP     TF1.7   1   Pointless Panda           1
#> 4 AAP     TF1.7   0.7 Tantalising Tarantula     1
#> 5 AAP     TF1.6   0.3 Tantalising Tarantula     1
#> 6 AHF     F2.2    0.4 Frightened Flamingo       1
```

Here we can use the function `membership_tbl` directly.

``` r

TASVEG_tbl <- TASVEG_xref |>
  membership_tbl(
    source_id = "VEGCODE",
    target_id = "efg",
    membership = "memb",
    interpreter = "interp"
  )
class(TASVEG_tbl)
#> [1] "membership_tbl" "tbl_df"         "tbl"            "data.frame"
print(TASVEG_tbl)
#> <membership_tbl>
#> source_id column: VEGCODE
#> target_id column: efg
#> membership column: memb
#> interpreter column: interp
#> 
#> # A tibble: 965 × 5
#>    VEGCODE efg    memb interp                round
#>  * <chr>   <chr> <dbl> <chr>                 <int>
#>  1 AAP     TF1.7 1     Frightened Flamingo       1
#>  2 AAP     TF1.7 1     Worrysome Wren            1
#>  3 AAP     TF1.7 1     Pointless Panda           1
#>  4 AAP     TF1.7 0.7   Tantalising Tarantula     1
#>  5 AAP     TF1.6 0.3   Tantalising Tarantula     1
#>  6 AHF     F2.2  0.4   Frightened Flamingo       1
#>  7 AHF     F2.3  0.4   Frightened Flamingo       1
#>  8 AHF     TF1.3 0.2   Frightened Flamingo       1
#>  9 AHF     F2.2  0.333 Worrysome Wren            1
#> 10 AHF     F2.3  0.4   Worrysome Wren            1
#> # ℹ 955 more rows
check_membership(TASVEG_tbl)
#> ✔ Membership column is numeric
#> ✖ Membership values contains NA values
#> ✔ Membership values are within [0,1]
#> ✖ No lookup table for source classification provided
#> ✔ All source ids are eligible
#> ✖ No lookup table for target classification provided
#> ✔ All target ids are valid
#> ℹ Please fix errors and check data before using other package functions.
validate_membership(TASVEG_tbl)
#> Errors: Membership column contains missing values.
#> No lookup table for source classification provided
#> No lookup table for target classification provided
#> Error in `validate_membership()`:
#> ! Please fix errors and check data before using other package functions.
```
