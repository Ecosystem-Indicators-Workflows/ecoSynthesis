# Crossreferencing Tasmanian vegetation communities

This article describes steps for cross-referencing using a real example
from the state of Tasmania, Australia. Example data is provided as part
of the package `ecoSynthesis`.

``` r

library(ecoSynthesis)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

## Source and target classifications

The target classification is the IUCN Global Ecosystem Typology. We
create a lookup table for this dataset using the `IUCN_GET_LUT` data and
the `lookup_tbl` function:

``` r

IUCN_GET <- lookup_tbl(IUCN_GET_LUT, id = "efg_id", name = "efg_name")
```

We will use the Tasmanian vegetation communities described in the TASVEG
5.0 dataset. A look-up table for this dataset is available in the
`TASVEG_LUT` data:

``` r

TASVEG_LUT
#> # A tibble: 156 × 3
#>    VEG_GROUP                        VEGCODE VEGCODE_D                           
#>    <chr>                            <chr>   <chr>                               
#>  1 Dry eucalypt forest and woodland DAC     (DAC) Eucalyptus amygdalina coastal…
#>  2 Dry eucalypt forest and woodland DAD     (DAD) Eucalyptus amygdalina forest …
#>  3 Dry eucalypt forest and woodland DAM     (DAM) Eucalyptus amygdalina forest …
#>  4 Dry eucalypt forest and woodland DAS     (DAS) Eucalyptus amygdalina forest …
#>  5 Dry eucalypt forest and woodland DAZ     (DAZ) Eucalyptus amygdalina inland …
#>  6 Dry eucalypt forest and woodland DBA     (DBA) Eucalyptus barberi forest and…
#>  7 Dry eucalypt forest and woodland DCO     (DCO) Eucalyptus coccifera forest a…
#>  8 Dry eucalypt forest and woodland DCR     (DCR) Eucalyptus cordata forest     
#>  9 Dry eucalypt forest and woodland DDE     (DDE) Eucalyptus tasmaniensis dry f…
#> 10 Dry eucalypt forest and woodland DDP     (DDP) Eucalyptus dalrympleana - Euc…
#> # ℹ 146 more rows
```

### Assessing alignment

One of the first steps of the cross-referencing process is to assess the
alignment between classifications. Units are eligible for
cross-referencing if they represent similar concepts.

The TASVEG 5.0 is a map of vegetation communities. Most units represent
a single vegetation community. These vegetation communities do align
with the ecosystem concept used in the IUCN GET.

However, some TASVEG units are described based on mappable units that do
not align with the ecosystem concept. This units might represent mosaics
of multiple communities, or represent un-vegetated ecological features.

For example, these units grouped as “Other natural environments” in
TASVEG are probably not eligible for cross-referencing.

``` r

TASVEG_LUT |>
  dplyr::filter(VEGCODE %in% c("OAQ", "ORO", "OSM"))
#> # A tibble: 3 × 3
#>   VEG_GROUP                  VEGCODE VEGCODE_D             
#>   <chr>                      <chr>   <chr>                 
#> 1 Other natural environments OAQ     (OAQ) Water, sea      
#> 2 Other natural environments ORO     (ORO) Lichen lithosere
#> 3 Other natural environments OSM     (OSM) Sand, mud
```

Here, we create a lookup table with explicit eligible units:

``` r

TASVEG_LUT_SS <- TASVEG_LUT |>
  dplyr::mutate(elig = !VEGCODE %in% c("OAQ", "ORO", "OSM")) |>
  lookup_tbl(id = "VEGCODE", name = "VEGCODE_D", eligible = "elig")
```

## Interpretation of classifications

In 2026 a group of four interpreters looked at full descriptions of the
vegetation community units in the TASVEG 5.0 dataset and assigned them
to ecosystem functional groups from the IUCN GET. This data is contained
in a table containing source and target ids, membership values, and
interpreter information (anonymised using codenames). This represents a
first round of interpretation. The table is available in the
`TASVEG_xref` data:

``` r

TASVEG_xref
#> # A tibble: 965 × 5
#>    VEGCODE efg    memb interp                round
#>    <chr>   <chr> <dbl> <chr>                 <int>
#>  1 AAP     TF1.7 1     Frightened Flamingo       1
#>  2 AAP     TF1.7 1     Worrysome Wren            1
#>  3 AAP     TF1.7 1     Pointless Panda           1
#>  4 AAP     TF1.7 0.7   Tantalising Tarantula     1
#>  5 AAP     TF1.6 0.3   Tantalising Tarantula     1
#>  6 AHF     F2.2  0.4   Frightened Flamingo       1
#>  7 AHF     F2.3  0.4   Frightened Flamingo       1
#>  8 AHF     TF1.3 0.2   Frightened Flamingo       1
#>  9 AHF     F2.2  0.333 Worrysome Wren            1
#> 10 AHF     F2.3  0.4   Worrysome Wren            1
#> # ℹ 955 more rows
```

### Our first membership table

If we want to use this data in our package we need to transform this
table into a `membership_tbl` object. We explicitly declare which
columns will be used as source and target ids, and which ones contain
membership values and interpreter info.

``` r

TASVEG_memb <- membership_tbl(
  TASVEG_xref,
  source_id = "VEGCODE",
  target_id = "efg",
  membership = "memb",
  interpreter = "interp"
)
TASVEG_memb
#> <membership_tbl>
#> source_id column: VEGCODE
#> target_id column: efg
#> membership column: memb
#> interpreter column: interp
#> 
#> # A tibble: 965 × 5
#>    VEGCODE efg    memb interp                round
#>  * <chr>   <chr> <dbl> <chr>                 <int>
#>  1 AAP     TF1.7 1     Frightened Flamingo       1
#>  2 AAP     TF1.7 1     Worrysome Wren            1
#>  3 AAP     TF1.7 1     Pointless Panda           1
#>  4 AAP     TF1.7 0.7   Tantalising Tarantula     1
#>  5 AAP     TF1.6 0.3   Tantalising Tarantula     1
#>  6 AHF     F2.2  0.4   Frightened Flamingo       1
#>  7 AHF     F2.3  0.4   Frightened Flamingo       1
#>  8 AHF     TF1.3 0.2   Frightened Flamingo       1
#>  9 AHF     F2.2  0.333 Worrysome Wren            1
#> 10 AHF     F2.3  0.4   Worrysome Wren            1
#> # ℹ 955 more rows
```

### Cleaning and preparing the data

This dataset has some errors that need to be corrected:

- `NA` values in membership column
- some source units are invalid (valid id, but unit not aligned with
  ecosystem concept)
- some `target_id`s are invalid (label does not exists in IUCN GET,
  likely typos)

The `check_membership` function can detect the problem with `NA` values:

``` r

check_membership(TASVEG_memb, source = TASVEG_LUT_SS, target = IUCN_GET)
#> ✔ Membership column is numeric
#> ✖ Membership values contains NA values
#> ✔ Membership values are within [0,1]
#> ✔ Lookup table for source classification provided
#> ✖ Problems with eligibility of source ids
#> ✔ Lookup table for target classification provided
#> ✖ Problems with validity of target ids
#> ℹ Please fix errors and check data before using other package functions.
```

> **Placeholder**
>
> The following code block will be replaced with a function later.

``` r

sid <- attr(TASVEG_memb, "source_id")
table(TASVEG_memb[[sid]] %in% TASVEG_LUT_SS$VEGCODE)
#> 
#> TRUE 
#>  965
tid <- attr(TASVEG_memb, "target_id")
table(TASVEG_memb[[tid]] %in% IUCN_GET_LUT$efg_id)
#> 
#> FALSE  TRUE 
#>     6   959
```

### Summarising the data

> **Placeholder**
>
> The following code block will be replaced with a function later.

``` r

interp <- rlang::sym(attr(TASVEG_memb, "interpreter"))
sid <- rlang::sym(attr(TASVEG_memb, "source_id"))
tid <- rlang::sym(attr(TASVEG_memb, "target_id"))
memb <- rlang::sym(attr(TASVEG_memb, "membership"))
TASVEG_memb |>
  group_by(interpreter = !!interp) |>
  summarise(
    n_sources = n_distinct(!!sid),
    n_targets = n_distinct(!!tid),
    merbership_sum = sum(!!memb, na.rm = TRUE)
  )
#> # A tibble: 4 × 4
#>   interpreter           n_sources n_targets merbership_sum
#>   <chr>                     <int>     <int>          <dbl>
#> 1 Frightened Flamingo         156        34           156 
#> 2 Pointless Panda             156        35           156.
#> 3 Tantalising Tarantula       156        28           156.
#> 4 Worrysome Wren              156        34           156.
```

## Visualisations

### Tile plot

We want to visualise the different assignments from all interpreters for
one single source unit.

We will use a tile plot, and select the following unit:

``` r

TASVEG_LUT |>
  dplyr::filter(VEGCODE == "HSW")
#> # A tibble: 1 × 3
#>   VEG_GROUP                    VEGCODE VEGCODE_D                              
#>   <chr>                        <chr>   <chr>                                  
#> 1 Highland treeless vegetation HSW     (HSW) Western alpine sedgeland/herbland
```

> **Work in progress**
>
> This will require modifications to existing functions.

``` r

TASVEG_memb |>
  dplyr::filter(VEGCODE == "HSW") |>
  membership_tile_plot()
```

![](TASVEG-example_files/figure-html/tile%20plot-1.png)

``` r


#Alternatively, code the filter in the function:
membership_tile_plot(TASVEG_memb, select_source = "HSW")
#> Error in `membership_tile_plot()`:
#> ! unused argument (select_source = "HSW")
# would internally use:
# sid <- attr(TASVEG_memb,"source_id")
# data <- filter(TASVEG_memb, sid == select_source)
```
