# TASVEG cross-reference dataset for development and testing

This is a test cross-reference of the TASVEG 5.0 classification to the
IUCN Global Ecosystem Typology, used for development and testing
purposes. This table holds membership values assigned by four
interpreters (anonymised using codenames) in a first round of
interpretation. Column names have not been standardised, source ids
(`VEGCODE`) and target ids (`efg`) include some errors (to test checks
and validation).

## Usage

``` r
TASVEG_xref
```

## Format

A tibble with 4 columns:

- VEGCODE:

  Original vegetation code of the `source` unit in the TASVEG 5.0
  dataset, the source id being classified.

- efg:

  Shortcode for the Ecosystem Functional Group (EFG) from the IUCN
  Global Ecosystem Typology, the `target` id.

- memb:

  Membership value between 0 and 1, indicating the degree of membership
  of the `source` vegetation or map unit to the `target` EFG.

- interp:

  Character vector of codenames for interpreters who provided the
  membership value. Anonymous codenames used instead of real names or
  initials.

- round:

  Numeric value for the round of interpretations. Currently only
  includes round 1.

## Source

Mark Tozer (pers. comm.)

## See also

Other data:
[`TASVEG_LUT`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/TASVEG_LUT.md),
[`TASVEG_mini`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/TASVEG_mini.md),
[`TASVEG_mini_expert_wide`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/TASVEG_mini_expert_wide.md)
