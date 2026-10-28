# Create a lookup table for a classification

Create a lookup table for a classification

## Usage

``` r
lookup_tbl(data, id = "id", name = "name", eligible = NULL)
```

## Arguments

- data:

  A data frame

- id:

  Column containing unique ids of the units in the classification system

- name:

  Column containing a name or short description of the units in the
  classification system

- eligible:

  Column containing a logical flag for eligible (TRUE) and not eligible
  (FALSE) units

## Value

An object of class 'lookup_tbl'

## Author

JR Ferrer-Paris

## Examples

``` r
# All units are eligible per default:
lookup_tbl(IUCN_GET_LUT, id = "efg_id", name = "efg_name")
#> ── <lookup_tbl> ────────────────────────────────────────────────────────────────
#> ℹ id column: `efg_id`
#> ℹ name column: `efg_name`
#> ℹ eligible units: 110 of 110
#> # A tibble: 110 × 10
#>    efg           efg_id efg_name biome_id biome_name realm_id realm_name version
#>  * <chr>         <chr>  <chr>    <chr>    <chr>      <chr>    <chr>      <chr>  
#>  1 https://w3id… F1.1   Permane… F1       Rivers an… F        Freshwater RVA de…
#>  2 https://w3id… F1.2   Permane… F1       Rivers an… F        Freshwater RVA de…
#>  3 https://w3id… F1.3   Freeze-… F1       Rivers an… F        Freshwater RVA de…
#>  4 https://w3id… F1.4   Seasona… F1       Rivers an… F        Freshwater RVA de…
#>  5 https://w3id… F1.5   Seasona… F1       Rivers an… F        Freshwater RVA de…
#>  6 https://w3id… F1.6   Episodi… F1       Rivers an… F        Freshwater RVA de…
#>  7 https://w3id… F1.7   Large l… F1       Rivers an… F        Freshwater RVA de…
#>  8 https://w3id… F2.1   Large p… F2       Lakes bio… F        Freshwater RVA de…
#>  9 https://w3id… F2.10  Subglac… F2       Lakes bio… F        Freshwater RVA de…
#> 10 https://w3id… F2.2   Small p… F2       Lakes bio… F        Freshwater RVA de…
#> # ℹ 100 more rows
#> # ℹ 2 more variables: version_date <chr>, eligible <lgl>
# If some units are not eligible, this can be defined as:
not_eligible <- c("OAQ", "ORO", "OSM")
TASVEG_LUT$eligible <- TASVEG_LUT$VEGCODE %nin% not_eligible
lookup_tbl(TASVEG_LUT, "VEGCODE", "VEGCODE_D", "eligible")
#> ── <lookup_tbl> ────────────────────────────────────────────────────────────────
#> ℹ id column: `VEGCODE`
#> ℹ name column: `VEGCODE_D`
#> ℹ eligible units: 153 of 156
#> # A tibble: 156 × 4
#>    VEG_GROUP                        VEGCODE VEGCODE_D                   eligible
#>  * <chr>                            <chr>   <chr>                       <lgl>   
#>  1 Dry eucalypt forest and woodland DAC     (DAC) Eucalyptus amygdalin… TRUE    
#>  2 Dry eucalypt forest and woodland DAD     (DAD) Eucalyptus amygdalin… TRUE    
#>  3 Dry eucalypt forest and woodland DAM     (DAM) Eucalyptus amygdalin… TRUE    
#>  4 Dry eucalypt forest and woodland DAS     (DAS) Eucalyptus amygdalin… TRUE    
#>  5 Dry eucalypt forest and woodland DAZ     (DAZ) Eucalyptus amygdalin… TRUE    
#>  6 Dry eucalypt forest and woodland DBA     (DBA) Eucalyptus barberi f… TRUE    
#>  7 Dry eucalypt forest and woodland DCO     (DCO) Eucalyptus coccifera… TRUE    
#>  8 Dry eucalypt forest and woodland DCR     (DCR) Eucalyptus cordata f… TRUE    
#>  9 Dry eucalypt forest and woodland DDE     (DDE) Eucalyptus tasmanien… TRUE    
#> 10 Dry eucalypt forest and woodland DDP     (DDP) Eucalyptus dalrymple… TRUE    
#> # ℹ 146 more rows
```
