library(checkmate)
library(ggplot2)

# Create a test dataset that is not a membership_tbl
test_input_data <- make_test_input_table()

# Create a test dataset that is a membership_tbl
test_membership_tbl <- make_test_membership_tbl()

# Create test plot result
result_tile_plot <- test_membership_tbl |> membership_tile_plot()

## ----- membership_tile_plot - arguments -----

test_that("membership_tile_plot returns error for non-membership_tbl input", {
  # Expect an error when calling membership_tile_plot with non-membership_tbl input
  expect_error(
    membership_tile_plot(test_input_data),
    "Assertion on 'data' failed"
  )
})

## ----- membership_tile_plot - results -----

test_that("membership_tile_plot returns a ggplot object", {
  # Assert that result is a ggplot object
  expect_s3_class(result_tile_plot, "ggplot")
})

test_that("membership_tile_plot returns a plot with correct aesthetics", {
  # Assert that the plot has the correct aesthetics
  expect_equal(
    result_tile_plot$mapping$x,
    with_env(env = get_env(result_tile_plot$mapping$x), quo(.data[["efg"]]))
  )
  expect_equal(
    result_tile_plot$mapping$y,
    with_env(env = get_env(result_tile_plot$mapping$y), quo(.data[["interp"]]))
  )
  expect_equal(
    result_tile_plot$mapping$fill,
    with_env(env = get_env(result_tile_plot$mapping$fill), quo(.data[["memb"]]))
  )
})
