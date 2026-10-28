# Create a membership table

Create a membership table

## Usage

``` r
membership_tbl(
  data,
  source_id = "source_id",
  target_id = "target_id",
  membership = "membership",
  interpreter = "interpreter",
  round = NULL
)
```

## Arguments

- data:

  A data frame

- source_id:

  Column containing source ecosystem concepts

- target_id:

  Column containing target ecosystem concepts

- membership:

  Column containing membership values

- interpreter:

  Column containing interpreter information

- round:

  Column containing the date of the interpretation

## Value

An object of class 'membership_tbl'

## Author

JR Ferrer-Paris

## Examples

``` r
xref <- tibble::tibble(
  source = c("A", "A", "B"),
  target = c("EFG1", "EFG2", "EFG3"),
  membership = c(0.8, 0.2, 1),
  interpreter = c("Worrisome Wren","Worrisome Wren","Worrisome Wren")
)
x <- membership_tbl(
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
