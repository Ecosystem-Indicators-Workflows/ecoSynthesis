library(ggplot2)

test_that("membership_tile_plot returns a ggplot object", {
  # Create a simple test dataset
  test_data <- data.frame(
    interpreter = c("A", "B", "C"),
    target = c("X", "Y", "Z"),
    membership = c(0.5, 0.7, 0.3)
  )

  # Call the function
  result <- membership_tile_plot(test_data)

  # Assert that the result is a ggplot object
  expect_s3_class(result, "ggplot")
})
