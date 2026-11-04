# Create a heatmap of shared target use by pairs of interpreters

Create a heatmap of shared target use by pairs of interpreters

## Usage

``` r
membership_target_pair_heatmap(data)
```

## Arguments

- data:

  A `membership_tbl` object containing membership data in long format,
  with columns for source, target, membership and interpreter values.

## Value

A ggplot object representing the heatmap of shared target use by pairs
of interpreters.

## Details

Returns a heatmap of how often each pair of interpreters used the same
`target` for the same `source` unit, for a single round of elicitation.
Each tile shows the number of `source` units where both interpreters of
a pair assigned membership to a `target`, with a colour gradient from
light to dark teal for more source units. Empty tiles mean the pair
never used that target for the same source unit. Rows with missing or
zero membership are not counted as use. The plot helps to spot targets
that pairs of interpreters agree or disagree on.

### Future Enhancements

The function is designed to be flexible and can be extended in the
future to include additional customization options. Users may filter by
round of elicitation, show the number of source units where only one
interpreter of a pair used a target, and specify theme options, colour
palette, label aesthetics, axis labels, title and subtitle to tailor the
plot to their specific needs.

## See also

Other visualisation:
[`membership_target_heatmap()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/membership_target_heatmap.md),
[`membership_tile_plot()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/membership_tile_plot.md)

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
membership_target_pair_heatmap(TASVEG_memb)

```
