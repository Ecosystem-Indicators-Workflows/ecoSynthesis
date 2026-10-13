# Standardise column names for expert cross-reference data in paired-columns format.

Standardises a cross-reference data frame in paired-columns format.

## Usage

``` r
standardise_xref_pairs(xref, prefix, suffix = "p", separator = "_")
```

## Arguments

- xref:

  A data frame containing the cross-reference data in paired-columns
  format.

- prefix:

  The prefix used to identify target columns.

- suffix:

  The suffix used to identify membership columns.

- separator:

  The separator used between the prefix and suffix.

## Value

A data frame with standardised column names for the expert
cross-reference data.

## Details

Note that the renaming convention is currently hard-coded into this
function rather than being expose as arguments. The function will prefix
target columns with `"efg_"` and mebership columns with `"memb_"`. This
is to ensure that the output is consistent with the expected format for
further processing.

Non-target, non-membership columns will be retained in the output data
frame with their original names.

## Examples

``` r
# Example usage of the \code{standardise_xref_pairs} function
standardise_xref_pairs(
  TASVEG_mini_expert_paired,
  prefix = "GET",
  suffix = "p",
  separator = "_"
)
#> # A tibble: 3 × 13
#>   VEG_GROUP     VEGCODE VEGCODE_D Notes workflow efg_1 memb_1 efg_2 memb_2 efg_3
#>   <chr>         <chr>   <chr>     <chr> <lgl>    <chr>  <dbl> <chr>  <dbl> <chr>
#> 1 Other natura… OAQ     (OAQ) Wa…  NA   NA       F2.2     0.4 F2.1     0.2 F3.1 
#> 2 Saltmarsh an… AAP     (AAP) Al… "Alk… NA       TF1.7    0.7 TF1.6    0.3 NA   
#> 3 Saltmarsh an… AWU     (AWU) We… "Sin… NA       F2.3     1   NA      NA   NA   
#> # ℹ 3 more variables: memb_3 <dbl>, efg_4 <chr>, memb_4 <dbl>
```
