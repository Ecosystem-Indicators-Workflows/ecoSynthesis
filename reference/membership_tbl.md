# Create a membership table

Create a membership table

## Usage

``` r
membership_tbl(
  data,
  source_id = "source_id",
  target_id = "target_id",
  membership = "membership",
  interpreter = "interpreter",
  updated = NULL
)
```

## Arguments

- data:

  A data frame

- source_id:

  Column containing source ecosystem concepts

- target_id:

  Column containing target ecosystem concepts

- membership:

  Column containing membership values

- interpreter:

  Column containing interpreter information

- updated:

  Column containing the date of the interpretation

## Value

An object of class 'membership_tbl'
