# Create a membership matrix

Create a membership matrix

## Usage

``` r
membership_matrix(data)
```

## Arguments

- data:

  A `membership_tbl` object containing membership data in long format,
  with columns for source, target, membership and interpreter values.

## Value

A `membership_matrix` object: a numeric array with dimensions
`[source, target, interpreter]`.

## Details

Returns the membership values as one `source` by `target` matrix per
interpreter, ready for `calc_similarity()`. Targets an interpreter did
not use for a `source` they assessed are filled with 0, and `source`
units an interpreter did not assess are left as `NA`. Repeated targets
for the same `source` and interpreter are summed. Rows with missing
membership values are dropped with a warning.

### Future Enhancements

The function is designed to be flexible and can be extended in the
future. Users may filter by round of elicitation, or add round as a
fourth dimension.

## Author

Abhimanyu Raj Singh

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
membership_matrix(TASVEG_memb)
#> Warning: Dropped 1 row with missing membership values.
#> <membership_matrix> 156 sources x 44 targets x 4 interpreters
#> • Frightened Flamingo: 156 source units assessed
#> • Pointless Panda: 156 source units assessed
#> • Tantalising Tarantula: 156 source units assessed
#> • Worrysome Wren: 156 source units assessed
#> Use `unclass(data)[source, target, interpreter]` to view values.
```
