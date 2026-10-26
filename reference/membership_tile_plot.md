# Create a tile plot of membership data

Create a tile plot of membership data

## Usage

``` r
membership_tile_plot(data)
```

## Arguments

- data:

  A data frame containing membership data in long format, with columns
  for interpreter, target, and membership values.

## Value

A ggplot object representing the tile plot of membership data.

## Details

Returns a tile plot of membership functions among interpreters for a
single `source` for a single round of elicitation. The plot uses a color
gradient to represent membership values, with tiles colored according to
the membership value for each interpreter-target pair. The plot includes
labels for each tile showing the rounded membership value.

### Future Enhancements

The function is designed to be flexible and can be extended in the
future to include additional customization options. Users may specify
theme options, text color, label aesthetics, geom_tile options, axis
labels, title, and subtitle to tailor the plot to their specific needs.
These enhancements will allow for greater control over the visual
presentation of the membership data.

## See also

Other visualisation:
[`membership_target_heatmap()`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/membership_target_heatmap.md)

## Author

Elliot Gould

## Examples

``` r
#' # Example usage with the TASVEG_mini dataset
data("TASVEG_mini")
TASVEG_mini |> dplyr::filter(source == "AAP") |> membership_tile_plot()

TASVEG_mini |> dplyr::filter(source == "OAQ") |> membership_tile_plot()

```
