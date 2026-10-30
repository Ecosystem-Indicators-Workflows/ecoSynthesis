test_memb <- function() {
  membership_tbl(
    data.frame(
      source = c("S1", "S1", "S2"),
      target = c("X", "Y", "X"),
      membership = c(0.5, 0.5, 1),
      interpreter = c("A", "A", "B")
    ),
    source_id = "source",
    target_id = "target"
  )
}

test_that("membership_matrix fails when data is not membership_tbl", {
  expect_error(membership_matrix(data.frame(a = 1)))
})

test_that("membership_matrix returns a source x target x interpreter array", {
  m <- membership_matrix(test_memb())

  expect_s3_class(m, "membership_matrix")
  expect_equal(unname(dim(m)), c(2, 2, 2))
  expect_equal(names(dimnames(m)), c("source", "target", "interpreter"))
})

test_that("membership_matrix fills unused targets with 0 and unassessed sources with NA", {
  m <- unclass(membership_matrix(test_memb()))

  expect_equal(m["S1", "Y", "A"], 0.5)
  expect_equal(m["S2", "Y", "B"], 0)
  expect_true(is.na(m["S2", "X", "A"]))
})

test_that("membership_matrix warns and drops missing membership values", {
  x <- test_memb()
  x$membership[1] <- NA

  expect_warning(membership_matrix(x), "missing membership")
})

test_that("print.membership_matrix prints a summary", {
  expect_message(print(membership_matrix(test_memb())), "membership_matrix")
})
