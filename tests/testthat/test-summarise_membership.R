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
