
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ecoSynthesis

<!-- badges: start -->

<!-- badges: end -->

The goal of `ecoSynthesis` is to assist users in the synthesis of
cross-referencing information between two classification systems.

The process of cross-reference implies a source classification and a
target classification, where the target classification might have a
broader scope than the source. Elements in the source classification can
be interpreted as directly related to one or more elements in the target
classification. This relationship can be quantified as membership
values, where the source element has memberships between 0 and 100% to
each element of the target classification.

<figure>
<img src="man/figures/diagram-concept-match.png" alt="Diagram" />
<figcaption aria-hidden="true">Diagram</figcaption>
</figure>

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
    re1 = c("Semi-deciduous Forest","Deciduous Forest","Wet Montane Forest","Dry Montane Forest"),
    efg1 = c("T1.1", "T1.2", "T1.1", "T1.2"),
    memb1 = c(80,80,70,50),
    efg2 = c("T1.2", "T1.1", "T1.3", "T1.3"),
    memb2 = c(20,20,30,50)
)

membership_table(
    input_table, 
    "re1",
    c("efg1","efg2","efg3"),
    c("memb1","memb2"),
    target="T1.3")
#> # A tibble: 4 × 3
#>   re1                efg    memb
#>   <chr>              <chr> <dbl>
#> 1 Wet Montane Forest T1.1     70
#> 2 Dry Montane Forest T1.2     50
#> 3 Wet Montane Forest T1.3     30
#> 4 Dry Montane Forest T1.3     50
```

This package in in the very early stages of development.

| Source Classification | Target Classification | Membership |
|-----------------------|-----------------------|------------|
| Concept A             | Concept Z             | 100%       |
| Concept B             | Concept W             | 60%        |
| Concept B             | Concept Z             | 40%        |
