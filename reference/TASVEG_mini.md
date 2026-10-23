# A subset of the TASVEG dataset for development and testing

This is a small subset of the TASVEG 5.0 dataset, used for development
and testing purposes (we may choose to use this as an example dataset
available for documentation to users).

## Usage

``` r
TASVEG_mini
```

## Format

A tibble with 4 columns:

- source:

  The source unit being classified. Original vegetation code of the
  `source` unit in the TASVEG 5.0 dataset

- target:

  Code for the target classification. theEcosystem Functional Group from
  the IUCN GET framework

- membership:

  Membership value between 0 and 1, indicating the degree of membership
  of the vegetation unit to the `target` EFG

- interpreter:

  Character vector of names/identifiers of the interpreterswho provided
  the membership value

## Source

TBC describe source here \#TODO

## Details

**\[deprecated\]** `TASVEG_mini` is deprecated and will be removed in a
future release. Please use
[TASVEG_xref](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/TASVEG_xref.md)
instead.

## See also

Other data:
[`IUCN_GET_LUT`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/IUCN_GET_LUT.md),
[`TASVEG_LUT`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/TASVEG_LUT.md),
[`TASVEG_mini_expert_wide`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/TASVEG_mini_expert_wide.md),
[`TASVEG_xref`](https://ecosystem-indicators-workflows.github.io/ecoSynthesis/reference/TASVEG_xref.md)
