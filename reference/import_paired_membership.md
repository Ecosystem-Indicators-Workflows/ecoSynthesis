# Reshape membership table from paired columns to long format

Reshape membership table from paired columns to long format

## Usage

``` r
import_paired_membership(
  data,
  original_names,
  target_names,
  membership_values,
  interpreter = NULL
)
```

## Arguments

- data:

  Input cross-referencing table (paired column format)

- original_names:

  Names or codes of the original ecosystem concepts

- target_names:

  Names or codes of the target ecosystem concepts

- membership_values:

  Membership values (between 0 and 1)

- interpreter:

  Name of the interpreter

## Value

A membership table in long format

## Author

JR Ferrer-Paris

## Examples

``` r
input_table <- data.frame(
 re1 = c(
   "Semi-deciduous Forest",
   "Deciduous Forest",
   "Wet Montane Forest",
   "Dry Montane Forest"
 ),
 efg_1 = c("T1.1", "T1.2", "T1.1", "T1.2"),
 memb_1 = c(0.80, 0.80, 0.70, 0.50),
 efg_2 = c("T1.2", "T1.1", "T1.3", "T1.3"),
 memb_2 = c(0.20, 0.20, 0.30, 0.50)
)

import_paired_membership(
 input_table,
 "re1",
 c("efg_1", "efg_2"),
 c("memb_1", "memb_2")
)
#> <membership_tbl>
#> source_id column: re1
#> target_id column: efg
#> membership column: memb
#> interpreter column: interpreter
#> 
#> # A tibble: 8 × 5
#>   re1                   pair  efg    memb interpreter   
#> * <chr>                 <chr> <chr> <dbl> <chr>         
#> 1 Semi-deciduous Forest 1     T1.1    0.8 Worrisome Wren
#> 2 Semi-deciduous Forest 2     T1.2    0.2 Worrisome Wren
#> 3 Deciduous Forest      1     T1.2    0.8 Worrisome Wren
#> 4 Deciduous Forest      2     T1.1    0.2 Worrisome Wren
#> 5 Wet Montane Forest    1     T1.1    0.7 Worrisome Wren
#> 6 Wet Montane Forest    2     T1.3    0.3 Worrisome Wren
#> 7 Dry Montane Forest    1     T1.2    0.5 Worrisome Wren
#> 8 Dry Montane Forest    2     T1.3    0.5 Worrisome Wren
```
