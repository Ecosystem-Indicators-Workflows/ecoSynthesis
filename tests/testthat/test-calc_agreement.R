# tests/testthat/test-calc_agreement.R
# S1: A splits 0.5/0.5, B puts 1 on X -> similarity 0.5
# S2: A and B both put 1 on X -> similarity 1
# S3: only A assessed it -> not compared

test_mat <- function() {
  membership_tbl(
    data.frame(
      source = c("S1", "S1", "S1", "S2", "S2", "S3"),
      target = c("X", "Y", "X", "X", "X", "X"),
      membership = c(0.5, 0.5, 1, 1, 1, 1),
      interpreter = c("A", "A", "B", "A", "B", "A")
    ),
    source_id = "source",
    target_id = "target"
  ) |>
    membership_matrix()
}

test_that("calc_agreement fails when data is not membership_matrix", {
  expect_error(calc_agreement(data.frame(a = 1)))
})

test_that("calc_agreement needs at least two interpreters", {
  one_interp <- membership_tbl(
    data.frame(
      source = "S1",
      target = "X",
      membership = 1,
      interpreter = "A"
    ),
    source_id = "source",
    target_id = "target"
  ) |>
    membership_matrix()

  expect_error(calc_agreement(one_interp), "two interpreters")
})

test_that("calc_agreement returns the documented columns", {
  out <- calc_agreement(test_mat())

  expect_s3_class(out, "tbl_df")
  expect_named(
    out,
    c(
      "interpreter_x",
      "interpreter_y",
      "n_units",
      "similarity",
      "median_similarity",
      "share_identical",
      "dissimilarity"
    )
  )
  # A-B, B-A, A-A, B-B
  expect_equal(nrow(out), 4)
})

test_that("calc_agreement gives the expected values", {
  out <- calc_agreement(test_mat())
  ab <- out[out$interpreter_x == "A" & out$interpreter_y == "B", ]
  ba <- out[out$interpreter_x == "B" & out$interpreter_y == "A", ]

  expect_equal(ab$n_units, 2)
  expect_equal(ab$similarity, 0.75)
  expect_equal(ab$median_similarity, 0.75)
  expect_equal(ab$share_identical, 0.5)
  expect_equal(ab$dissimilarity, 0.25)
  expect_equal(ba$similarity, ab$similarity)
})

test_that("calc_agreement sets the diagonal to 1 with units assessed", {
  out <- calc_agreement(test_mat())
  diag <- out[out$interpreter_x == out$interpreter_y, ]

  expect_equal(diag$similarity, c(1, 1))
  expect_equal(diag$n_units[diag$interpreter_x == "A"], 3)
  expect_equal(diag$n_units[diag$interpreter_x == "B"], 2)
})

test_that("calc_agreement by_source returns one row per source and pair", {
  out <- calc_agreement(test_mat(), by_source = TRUE)

  expect_named(
    out,
    c("source", "interpreter_a", "interpreter_b", "similarity", "dissimilarity")
  )
  expect_equal(out$source, c("S1", "S2"))
  expect_equal(out$similarity, c(0.5, 1))
})

test_that("calc_agreement filters by sources", {
  out <- calc_agreement(test_mat(), sources = "S1", by_source = TRUE)

  expect_equal(out$source, "S1")
  expect_error(calc_agreement(test_mat(), sources = "NOPE"))
})

test_that("calc_agreement filters by targets", {
  out <- calc_agreement(test_mat(), targets = "X", by_source = TRUE)

  expect_equal(out$similarity, c(0.75, 1))
  expect_error(calc_agreement(test_mat(), targets = "NOPE"))
})

test_that("calc_agreement warns that round is not used yet", {
  expect_warning(calc_agreement(test_mat(), round = 1), "not used yet")
})

test_that("calc_agreement checks by_source is a flag", {
  expect_error(calc_agreement(test_mat(), by_source = "yes"))
})