# Create a test dataset that is not a lookup_tbl
test_input_data <- list(
  id = c("T1.1", "T2.1"),
  name = c("Trop forest", "Temp forest")
)

test_that("lookup_tbl returns error if data is not a data frame", {
  # Expect an error when calling lookup_tbl with list input
  expect_error(
    lookup_tbl(test_input_data),
    "Assertion on 'data' failed"
  )
})
