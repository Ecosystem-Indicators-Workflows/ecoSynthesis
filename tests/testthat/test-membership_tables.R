# ----- import_paired_membership -----

## Test that different ways of selecting columns produce the same result

test_that("variants of column selection produce same results", {
  result1 <- import_paired_membership(
    make_test_input_table(),
    "re1",
    c("efg_1", "efg_2"),
    c("memb_1", "memb_2")
  )

  result2 <- import_paired_membership(
    make_test_input_table(),
    "re1",
    dplyr::starts_with("efg"),
    dplyr::starts_with("memb")
  )
  expect_equal(result1, result2)
})
