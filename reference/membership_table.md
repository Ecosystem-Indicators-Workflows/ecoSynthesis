# Reshape membership table from wide to long format

Reshape membership table from wide to long format

## Usage

``` r
membership_table(
  xref,
  original_names,
  target_names,
  membership_values,
  target = NULL
)
```

## Arguments

- xref:

  Input cross-referencing table (wide format)

- original_names:

  Names or codes of the original ecosystem concepts

- target_names:

  Names or codes of the target ecosystem concepts

- membership_values:

  Membership values (between 0 and 1)

- target:

  Filter input to focus on specific targets

## Value

A membership table in long format
