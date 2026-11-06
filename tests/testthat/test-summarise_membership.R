test_that("summarise_membership fails when data is not membership_tbl", {
  expect_error(summarise_membership(data.frame(test_memb())))
})


test_that("summarise_membership returns the membership_summary class", {
  m <- summarise_membership(test_memb())
  expect_s3_class(m, "membership_summary")
})

test_that("print.summarise_membership prints a summary", {
  m <- summarise_membership(test_memb())
  expect_message(
    print(m),
    "membership_summary"
  )
})

test_that("summarise_membership errors when passed multiple round values", {
  m <- test_memb()
  round_arg <- c(1, 1)
  expect_error(summarise_membership(m, which_round = round_arg))
})

test_that("summarise_membership errors when passed a round value not in the data", {
  m <- test_memb()
  round_arg <- 2
  expect_error(summarise_membership(m, which_round = round_arg))
})
