library(checkmate)
library(ggplot2)

# Create a test dataset that is not a membership_tbl
test_input_data <- make_test_input_table()

# Create a test dataset that is a membership_tbl
test_membership_tbl <- make_test_membership_tbl()

# Create test plot result
result_tile_plot <- test_membership_tbl |> membership_tile_plot()

## ----- membership_tile_plot -----

## test that membership_tile_plot returns error when input is not a membership_tbl
test_that("membership_tile_plot returns error for non-membership_tbl input", {
  # Expect an error when calling membership_tile_plot with non-membership_tbl input
  expect_error(
    membership_tile_plot(test_input_data),
    "Assertion on 'data' failed"
  )
})


test_that("membership_tile_plot returns a ggplot object", {
  # Assert that the result is a ggplot object
  expect_s3_class(result_tile_plot, "ggplot")
})
