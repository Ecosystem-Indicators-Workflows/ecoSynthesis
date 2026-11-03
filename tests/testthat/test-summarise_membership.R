test_memb <- function() {
  membership_tbl(
    data.frame(
      source = c("S1", "S1", "S2", "S1", "S2"),
      target = c("X", "Y", "X", "X", "X"),
      membership = c(0.5, 0.5, 1, 1, 1),
      interpreter = c("A", "A", "A", "B", "B"),
      roundnr = c(1, 1, 1, 1, 1)
    ),
    source_id = "source",
    target_id = "target",
    interpreter = "interpreter",
    round = "roundnr"
  )
}

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
