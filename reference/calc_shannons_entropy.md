# Calculate Shannon's entropy for a membership function or vector of probabilities

Calculate Shannon's entropy for a membership function or vector of
probabilities

## Usage

``` r
calc_shannons_entropy(p = numeric(length = 0L), N = NULL, tol = 1e-09)
```

## Arguments

- p:

  a numeric vector of probabilities (non-negative values that sum to 1)

- N:

  an optional numeric value representing the number of categories
  (targets) for normalisation. If not provided, the function will use
  the number of non-zero probabilities in `p` as the baseline for
  normalisation

- tol:

  a numeric value representing the tolerance for checking if the sum of
  probabilities is equal to 1 (default is 1e-9)

## Value

A numeric value representing the Shannon's entropy of the input
probability vector, normalised by the number of non-zero probabilities
if `N` is not provided, or by `N` if it is provided.

A numeric value representing the Shannon's entropy of the input
probability vector. See details for interpretation depending on the
value of `N`.

## Details

### Shannon's entropy

Shannon's entropy is a measure of uncertainty or information content in
a probability distribution. It is calculated as the negative sum of the
probabilities multiplied by their logarithm (base 2), normalised by the
logarithm of the number of non-zero probabilities (default behaviour) or
by the logarithm of `N` if it is provided.

The function handles cases where the input vector has no non-zero values
or only one non-zero value, returning an error or zero, respectively.

#### Normalisation choices, setting `N`

The function allows for two normalisation options:

1.  **Default behaviour**: If `N` is not provided, the function uses the
    number of non-zero probabilities in `p` as the baseline for
    normalisation. This measure shows how decisively a single
    interpreter made their choices (internal evenness).

2.  **Provided `N`**: If `N` is provided, the function uses this value
    as the baseline for normalisation. This allows for comparison of
    entropy across interpreters with different numbers of *selected*
    targets, showing how evenly an interpreter distributed their
    membership across the set of available targets (external evenness).

When `N` is provided, it must be greater than or equal to the number of
non-zero probabilities in `p`. If `N` is less than the number of
non-zero probabilities, the function will throw an error.

When `N` is set to the maximum number number of targets under
consideration for a given source unit, the entropy measure reflects how
evenly an interpreter distributed their membership across all possible
targets for that source unit, regardless of whether they selected them
or not. It standardises interpreters evaluating the exact same source
against each other (gives uncertainty of the membership function
relative to peers)

When `N` is set to the total targets in the cross-map dataset, it
standardises every observation (i.e., a membership function) against the
entire cross-map to highlight overall noise.

### Relation to other functions

This function is used internally by
[`calc_entropy_tbl()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/calc_entropy_tbl.md)
to compute the entropy of membership functions represented as
probability vectors.

## Examples

``` r
# Example 1: Calculate entropy for a simple probability vector (interpreter-normalised calculation)
p <- c(0.5, 0.5, 0, 0)
calc_shannons_entropy(p)
#> [1] 1
# Example 2: Calculate entropy for a probability vector with a specified N (simulating source- and set-normalised calculation)
p <- c(0.5, 0.5, 0, 0)
N <- 4
calc_shannons_entropy(p, N)
#> [1] 0.5
calc_shannons_entropy(p, N)
#> [1] 0.5
```
