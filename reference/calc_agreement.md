# Calculate agreement between interpreters

Calculate agreement between interpreters

## Usage

``` r
calc_agreement(
  data,
  sources = NULL,
  targets = NULL,
  round = NULL,
  by_source = FALSE
)
```

## Arguments

- data:

  A `membership_matrix` object returned by
  [`membership_matrix()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/membership_matrix.md).

- sources:

  A character vector of `source` units to compare. If `NULL` (default),
  all `source` units are used.

- targets:

  A character vector of `target` units to compare. If `NULL` (default),
  all `target` units are used.

- round:

  A numeric vector of length 1 representing the round of elicitation to
  filter. Not used yet, as round is not included in `membership_tbl`.

- by_source:

  Logical. If `FALSE` (default), returns one row per interpreter pair
  summarised across `source` units, i.e., the mean pairwise
  (dis)similarity across the `source` units. If `TRUE`, returns one row
  per `source` unit and interpreter pair, i.e., the pairwise
  (dis)similarity for each `source` unit.

## Value

A tibble. With `by_source = FALSE`, columns `interpreter_x`,
`interpreter_y`, `n_units`, `mean_similarity`, `median_similarity`,
`share_identical` and `mean_dissimilarity`, with one row per interpreter
pair in both directions plus the diagonal. With `by_source = TRUE`,
columns `source`, `interpreter_x`, `interpreter_y`, `similarity` and
`dissimilarity`, with each interpreter pair once.

## Details

Returns the similarity between each pair of interpreters as
`1 - 0.5 * sum(|a - b|)`, where `a` and `b` are the membership vectors
of two interpreters for the same `source` unit. When membership values
for a `source` sum to 1, this is the share of membership the two
interpreters agree on: 1 means identical membership and 0 means no
target in common. Only `source` units assessed by both interpreters are
compared. Dissimilarity is calculated as `1 - similarity`.

By default pairwise similarity is calculated globally, across all
`source` units, to track change across rounds and report final round
values. `mean_similarity` is the mean across `source` units,
`share_identical` is the share of `source` units with identical
membership, and `n_units` counts the units compared. Pairs of
interpreters are mirrored so the matrix is symmetrical, and the diagonal
is set to 1 with `n_units` representing the number of units each
interpreter assessed. This makes it easy to visualize the agreement
between interpreters using
[`membership_target_pair_heatmap()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/membership_target_pair_heatmap.md).

### Filtering by `sources` and `targets`

Use `sources` to calculate similarity within a subset of `source` units,
such as a single unit or a handful of related units. Use `targets` to
compare only some `target` units; in which case, membership vectors are
then incomplete, so pairwise `similarity` measures agreement on selected
`targets` only, and `source` units where neither interpreter used those
targets count as identical.

### Future Enhancements

The function is designed to be flexible and can be extended in the
future. Users may filter by round of elicitation once round is included
in `membership_tbl`, and choose from additional similarity measures,
such as the normalised Euclidean distance and the fuzzy Jaccard
(Ruzicka) index.

To discuss: add flag to return a non-symmetrical matrix with only one
row per pair of interpreters, or a symmetrical matrix with the diagonal
set to NA for easier plotting / analysis.

## See also

Other similarity:
[`membership_matrix()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/membership_matrix.md)

## Author

Abhimanyu Raj Singh, JR Ferrer-Paris and Elliot Gould

## Examples

``` r
# Example usage with the TASVEG_xref dataset
data("TASVEG_xref")
TASVEG_memb <- membership_tbl(
  TASVEG_xref,
  source_id = "VEGCODE",
  target_id = "efg",
  membership = "memb",
  interpreter = "interp"
)
TASVEG_mat <- membership_matrix(TASVEG_memb)
#> Warning: Dropped 1 row with missing membership values.

# global similarity across all source units
calc_agreement(TASVEG_mat)
#> # A tibble: 16 × 7
#>    interpreter_x         interpreter_y n_units mean_similarity median_similarity
#>    <chr>                 <chr>           <int>           <dbl>             <dbl>
#>  1 Frightened Flamingo   Frightened F…     156           1                  1   
#>  2 Frightened Flamingo   Pointless Pa…     156           0.832              0.95
#>  3 Frightened Flamingo   Tantalising …     156           0.715              0.8 
#>  4 Frightened Flamingo   Worrysome Wr…     156           0.982              1   
#>  5 Pointless Panda       Frightened F…     156           0.832              0.95
#>  6 Pointless Panda       Pointless Pa…     156           1                  1   
#>  7 Pointless Panda       Tantalising …     156           0.696              0.7 
#>  8 Pointless Panda       Worrysome Wr…     156           0.837              0.95
#>  9 Tantalising Tarantula Frightened F…     156           0.715              0.8 
#> 10 Tantalising Tarantula Pointless Pa…     156           0.696              0.7 
#> 11 Tantalising Tarantula Tantalising …     156           1                  1   
#> 12 Tantalising Tarantula Worrysome Wr…     156           0.711              0.8 
#> 13 Worrysome Wren        Frightened F…     156           0.982              1   
#> 14 Worrysome Wren        Pointless Pa…     156           0.837              0.95
#> 15 Worrysome Wren        Tantalising …     156           0.711              0.8 
#> 16 Worrysome Wren        Worrysome Wr…     156           1                  1   
#> # ℹ 2 more variables: share_identical <dbl>, mean_dissimilarity <dbl>

# similarity within a single source unit, or a subset of related units
calc_agreement(TASVEG_mat, sources = "HSW")
#> # A tibble: 16 × 7
#>    interpreter_x         interpreter_y n_units mean_similarity median_similarity
#>    <chr>                 <chr>           <int>           <dbl>             <dbl>
#>  1 Frightened Flamingo   Frightened F…       1            1                 1   
#>  2 Frightened Flamingo   Pointless Pa…       1            0.95              0.95
#>  3 Frightened Flamingo   Tantalising …       1            0.5               0.5 
#>  4 Frightened Flamingo   Worrysome Wr…       1            1                 1   
#>  5 Pointless Panda       Frightened F…       1            0.95              0.95
#>  6 Pointless Panda       Pointless Pa…       1            1                 1   
#>  7 Pointless Panda       Tantalising …       1            0.5               0.5 
#>  8 Pointless Panda       Worrysome Wr…       1            0.95              0.95
#>  9 Tantalising Tarantula Frightened F…       1            0.5               0.5 
#> 10 Tantalising Tarantula Pointless Pa…       1            0.5               0.5 
#> 11 Tantalising Tarantula Tantalising …       1            1                 1   
#> 12 Tantalising Tarantula Worrysome Wr…       1            0.5               0.5 
#> 13 Worrysome Wren        Frightened F…       1            1                 1   
#> 14 Worrysome Wren        Pointless Pa…       1            0.95              0.95
#> 15 Worrysome Wren        Tantalising …       1            0.5               0.5 
#> 16 Worrysome Wren        Worrysome Wr…       1            1                 1   
#> # ℹ 2 more variables: share_identical <dbl>, mean_dissimilarity <dbl>
calc_agreement(TASVEG_mat, sources = c("AHF", "AHL"), by_source = TRUE)
#> # A tibble: 12 × 5
#>    source interpreter_x         interpreter_y         similarity dissimilarity
#>    <chr>  <chr>                 <chr>                      <dbl>         <dbl>
#>  1 AHF    Pointless Panda       Frightened Flamingo        0.7           0.3  
#>  2 AHL    Pointless Panda       Frightened Flamingo        0.1           0.9  
#>  3 AHF    Tantalising Tarantula Frightened Flamingo        0.6           0.4  
#>  4 AHL    Tantalising Tarantula Frightened Flamingo        0             1    
#>  5 AHF    Tantalising Tarantula Pointless Panda            0.65          0.35 
#>  6 AHL    Tantalising Tarantula Pointless Panda            0             1    
#>  7 AHF    Worrysome Wren        Frightened Flamingo        0.9           0.1  
#>  8 AHL    Worrysome Wren        Frightened Flamingo        1             0    
#>  9 AHF    Worrysome Wren        Pointless Panda            0.667         0.333
#> 10 AHL    Worrysome Wren        Pointless Panda            0.1           0.9  
#> 11 AHF    Worrysome Wren        Tantalising Tarantula      0.667         0.333
#> 12 AHL    Worrysome Wren        Tantalising Tarantula      0             1    
```
