# Key concepts of cross-referencing

The need to cross-reference different classification systems arises
frequently in ecology and conservation applications. The conceptual
foundations for cross-referencing classifications are discussed in:

> IUCN (2025). Standards, methods and guidelines for cross-referencing
> ecosystem classifications and maps to the IUCN Global Ecosystem
> Typology. Version 1.0. Keith, D. A., Dayaram, A., Driver, A.,
> Ferrer-Paris, J. R., Francis, R., Hay, S., Murray, N. J., Nicholson,
> E., Santos, J., Skowno, A. L. & Tozer, M. G. (Eds.). Gland,
> Switzerland: IUCN. ISBN: 978-2-8317-2348-8. DOI:10.2305/CPPC6126.

Here we try to apply consistent methods and standards for
cross-referencing in order to make the relationships between units more
explicit and enhance the reproducibility of the process. This will
enable efficient update when more information becomes available, and
minimise divergent or erroneous interpretations of relationships between
classifications.

The process of cross-referencing involves a source classification and a
target classification, where the target classification might have a
broader scope than the source. Elements in the source classification can
be interpreted as directly related to one or more elements in the target
classification. This relationship can be quantified as membership
values, where the source element assigns memberships between 0 and 100%
to each element of the target classification, summing to 100% total.

Membership estimates from multiple interpreters can be combined to
produce more robust cross-referencing relationships. Uncertainty due to
disagreements between interpreters can be quantified and documented for
maximum transparency.

## Overview of stepwise cross-referencing process

A stepwise diagnostic process ensures that the cross-referencing
exercise aligns with four key principles: alignment of classifications,
membership based on entity properties, using weight of evidence, and
transparent representation of uncertainty (IUCN 2025).

``` mermaid
flowchart TB
    subgraph CLASS1 ["Diagnostic tools,<br> replicate interpreters"]
        STEP3[["3: Eliminate implausible candidates"]]:::MainSteps
        STEP4[["4: Estimate (non-zero) memberships"]]:::MainSteps
    end

    STEP1[["1: Assess alignment between classifications"]]:::MainSteps
    STEP2[["2: Assemble information on properties of units"]]:::MainSteps
    STEP5[["5: Synthesis: compile, document methods and uncertainty"]]:::MainSteps

    STEP1 ==> STEP2 ==> STEP3 ==> STEP4 ==> STEP5
    STEP1 -->|No alignment| NO["Units not eligible for cross-referencing "]:::OutSteps
    STEP2 -->|Insufficient info?| RE["Gather more information"]:::OutSteps -->STEP2
    STEP3 --> ZERO["Zero membership value"]:::OutSteps
    CLASS1:::Grp
    classDef MainSteps fill:#f8f9fa,stroke:#1A1A1A,color:#1A1A1A, stroke-width:2px
    classDef OutSteps fill:#eee,stroke:#6C757D,color:#6C757D, stroke-width:2px
    classDef Grp fill:#fff,stroke:#040,color:#040, stroke-width:2px
```

The functions in this package focus on step 5 in this diagram: compiling
membership matrix from multiple interpreters, linking to spatial data
for visualisation, and documenting and analysing sources of
uncertainties.

## Membership tables

The following diagram illustrates a minimal example consisting of two
classifications with two concepts each, and lines joining the source and
target concepts with membership values.

``` mermaid
flowchart LR
    CLASS1:::Clas
    CLASS2:::Clas
    subgraph CLASS1 ["Source classification"]
        ECO1(["Concept A"]):::Ecos
        ECO2(["Concept B"]):::Ecos
    end
    subgraph CLASS2 ["Target classification"]
        ECO3(["Concept Z"]):::Ecos
        ECO4(["Concept W"]):::Ecos
    end


    ECO1 ==>|100%| ECO3
    ECO1 -.->|0%| ECO4
    ECO2 -->|60%| ECO3
    ECO2 -->|40%| ECO4

    classDef Ecos fill:#dfd,stroke:#040,color:#040, stroke-width:2px
    classDef Clas fill:#fff,stroke:#040,color:#040, stroke-width:2px
```

These relationships can be represented in different tabular formats:

### Membership matrix

A membership matrix will have rows for the source classificaton and
columns for the target classification:

|           | Concept Z | Concept W |
|-----------|-----------|-----------|
| Concept A | 100%      | 0%        |
| Concept B | 40%       | 60%       |

The size of the matrix will increase with the number of concepts in each
classification ($`n`$ rows for the source and $`m`$ columns for the
target).

These matrices will expose the information transparently, and can be
useful for data entry purposes, but they can become very clunky when the
number of concepts is both classifications is large, and are not optimal
to store multiple interpretations (see next section).

### Long-format table

An alternative representation of this information is a membership table
in “long” format:

| Source Classification | Target Classification | Membership |
|-----------------------|-----------------------|------------|
| Concept A             | Concept Z             | 100%       |
| Concept B             | Concept W             | 60%        |
| Concept B             | Concept Z             | 40%        |

The size of the table will increase with the number of links between
classifications ($`n \times m`$ rows, but only three columns). If we
ignore or filter out the zero membership values, then the size can be
reduced considerably.

### Paired column format

A membership table can also be represented in wide format if we can
assume that each source concept matches maximum of $`q`$ target
concepts:

| Source Concept | Target Concept 1 | Membership | Target Concept 2 | Membership |
|----------------|------------------|------------|------------------|------------|
| Concept A      | Concept Z        | 100%       |                  |            |
| Concept B      | Concept W        | 60%        | Concept Z        | 40%        |

This table will have $`n`$ rows for all source concept, but a fixed
number of columns ($`1 + (q \times 2)`$)

## Multiple interpreters

Tables in long and wide formats can incorportate multiple interpreters
by adding columns to identify the interpreter.

For maximum transparency, these tables could also include columns for
date of interpretation and for documentation of methods. This would
allow better filtering and comparison of multiple interpretations.

An example with a long format table:

| Source    | Target    | Membership | Interpreter   | Date        | Methods            |
|-----------|-----------|------------|---------------|-------------|--------------------|
| Concept A | Concept Z | 100%       | Interpreter A | 25 May 2011 | Match descriptions |
| Concept B | Concept W | 60%        | Interpreter A | 25 May 2011 | Match descriptions |
| Concept B | Concept Z | 40%        | Interpreter A | 25 May 2011 | Match descriptions |
| Concept A | Concept Z | 80%        | Interpreter B | 25 May 2025 | Compare attributes |
| Concept A | Concept W | 20%        | Interpreter B | 25 May 2025 | Compare attributes |
| Concept B | Concept W | 80%        | Interpreter B | 25 May 2025 | Compare attributes |
| Concept B | Concept Z | 20%        | Interpreter B | 25 May 2025 | Compare attributes |
| Concept A | Concept Z | 100%       | Interpreter A | 25 May 2026 | Revised opinion    |
| Concept B | Concept W | 60%        | Interpreter A | 25 May 2026 | Revised opinion    |
| Concept B | Concept Z | 40%        | Interpreter A | 25 May 2026 | Revised opinion    |
