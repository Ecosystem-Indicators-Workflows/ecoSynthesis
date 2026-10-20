# Working with membership tables

This is an example with our internal dataset, first take a look at the
data structure

``` r

library(ecoSynthesis)
data("TASVEG_mini", package = "ecoSynthesis")
head(TASVEG_mini)
```

    # A tibble: 6 × 5
      source target membership interpreter date
      <chr>  <chr>       <dbl> <chr>       <date>
    1 AAP    TF1.7        1    AK          2026-04-23
    2 AAP    TF1.7        1    AL          2026-04-23
    3 AAP    TF1.7        1    JB          2026-04-23
    4 AAP    TF1.7        0.7  MGT         2026-04-23
    5 AAP    TF1.6        0.3  MGT         2026-04-23
    6 AWU    MFT1.3       0.25 AK          2026-04-23

Here we can use the function membership_tbl directly (need to adjust
table column names).

``` r

TASVEG_tbl <- membership_tbl(TASVEG_mini, "VEGCODE", "efg", "memb", "expert")
class(TASVEG_tbl)
print(TASVEG_tbl)
check_membership(TASVEG_tbl)
validate_membership(TASVEG_tbl)
```
