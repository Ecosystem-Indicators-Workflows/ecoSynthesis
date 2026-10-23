# Coerce a data frame to membership_tbl

Coerce a data frame to membership_tbl

## Usage

``` r
as_membership_tbl(
  x,
  source_id,
  target_id,
  membership,
  interpreter,
  round = NULL
)
```

## Arguments

- x:

  A data frame

- source_id:

  Source concept column

- target_id:

  Target concept column

- membership:

  Membership column

- interpreter:

  Interpreter column

- round:

  Round column

## Value

A validated membership_tbl

## Examples

``` r
xref <- tibble::tibble(
  source = c("A", "A", "B"),
  target = c("EFG1", "EFG2", "EFG3"),
  membership = c(0.8, 0.2, 1),
  interpreter = c("Worrisome Wren","Worrisome Wren","Worrisome Wren")
)
x <- as_membership_tbl(
  xref,
  source_id = "source",
  target_id = "target",
  membership = "membership",
  interpreter = "interpreter"
)
x
#> <membership_tbl>
#> source_id column: source
#> target_id column: target
#> membership column: membership
#> interpreter column: interpreter
#> 
#> # A tibble: 3 × 4
#>   source target membership interpreter   
#> * <chr>  <chr>       <dbl> <chr>         
#> 1 A      EFG1          0.8 Worrisome Wren
#> 2 A      EFG2          0.2 Worrisome Wren
#> 3 B      EFG3          1   Worrisome Wren
```
