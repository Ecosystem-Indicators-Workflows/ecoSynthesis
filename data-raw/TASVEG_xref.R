# This is a (imperfect) version of the TASVEG cross-reference dataset for development and testing purposes.
# This table holds membership values assigned by four interpreters (anonymised using codenames) in a first round of interpretation. Column names have not been standardised, source ids and target ids include some errors (to test checks and validation)

library(tibble)

TASVEG_xref <- read.csv(
  "data-raw/TASVEG-xref-first-round-anon.csv",
  row.names = 1
) |>
  as_tibble()

usethis::use_data(TASVEG_xref, overwrite = TRUE)
