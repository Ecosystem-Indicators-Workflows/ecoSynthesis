# ecoSynthesis (0.0.0.9002)

*This package is a work in progress and is not yet ready for use. Please
check back later for updates.*

------------------------------------------------------------------------

The goal of `ecoSynthesis` is to assist users in the synthesis of
cross-referencing information between two classification systems. The
examples in this package focus on ecosystem classifications, and
specifically on cross-referencing from local classifications to a global
standard classification, but functions are designed to work with any
pair of classification systems.

The process of cross-reference implies a source classification and a
target classification, where the target classification might have a
broader scope than the source. Elements in the source classification can
be interpreted as directly related to one or more elements in the target
classification. This relationship can be quantified as membership
values, where the source element has memberships between 0 and 100% to
each element of the target classification.

![Diagram](reference/figures/diagram-concept-match.png)

Diagram

The membership table (long format) looks like this (assuming all other
possible pairs have 0% membership).

| Source Classification | Target Classification | Membership |
|-----------------------|-----------------------|------------|
| Concept A             | Concept Z             | 100%       |
| Concept B             | Concept W             | 60%        |
| Concept B             | Concept Z             | 40%        |

## Installation

You can install the development version of ecoSynthesis from
[GitHub](https://github.com/) with:

``` r

# install.packages("pak")
pak::pak("Ecosystem-Indicators-Workflows/ecoSynthesis")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r

library(ecoSynthesis)

input_table <- data.frame(
    types = rep(c(
        "Semi-deciduous Forest",
        "Deciduous Forest",
        "Wet Montane Forest",
        "Dry Montane Forest"
    ), 2),
    groups = c("T1.1", "T1.2", "T1.1", "T1.2", "T1.2", "T1.1", "T1.3", "T1.3"),
    memb = c(0.80, 0.80, 0.70, 0.50, 0.20, 0.20, 0.30, 0.50),
    name = "Parched Porcupine"
)

membership_tbl(
    input_table,
    source = "types", target = "groups", membership = "memb", interpreter = "name"
)
#> <membership_tbl>
#> source_id column: types
#> target_id column: groups
#> membership column: memb
#> interpreter column: name
#> 
#> # A tibble: 8 × 4
#>   types                 groups  memb name             
#> * <chr>                 <chr>  <dbl> <chr>            
#> 1 Semi-deciduous Forest T1.1     0.8 Parched Porcupine
#> 2 Deciduous Forest      T1.2     0.8 Parched Porcupine
#> 3 Wet Montane Forest    T1.1     0.7 Parched Porcupine
#> 4 Dry Montane Forest    T1.2     0.5 Parched Porcupine
#> 5 Semi-deciduous Forest T1.2     0.2 Parched Porcupine
#> 6 Deciduous Forest      T1.1     0.2 Parched Porcupine
#> 7 Wet Montane Forest    T1.3     0.3 Parched Porcupine
#> 8 Dry Montane Forest    T1.3     0.5 Parched Porcupine
```

This package implements recommended methods from:

> IUCN (2025). Standards, methods and guidelines for cross-referencing
> ecosystem classifications and maps to the IUCN Global Ecosystem
> Typology. Version 1.0. Keith, D. A., Dayaram, A., Driver, A.,
> Ferrer-Paris, J. R., Francis, R., Hay, S., Murray, N. J., Nicholson,
> E., Santos, J., Skowno, A. L. & Tozer, M. G. (Eds.). Gland,
> Switzerland: IUCN. ISBN: 978-2-8317-2348-8. <DOI:10.2305/CPPC6126>.

This package in in the very early stages of development.

Please find more information about the Environmental Indicators
Initiative here;
<https://ardc.edu.au/project/environmental-indicators-initiative/>, and
the Ecosystem Indicator Workflows project here;
<https://ardc.edu.au/project/ecosystem-indicator-workflows/>.
