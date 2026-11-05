# Membership functions for testing helper function calc_shannons_entropy
test_membership_vectors <- list(
  interp_1 = c(1, 0, 0), # concentrated on one target, should have entropy of 0
  interp_2 = c(0.5, 0.5, 0), # spread across two targets, should have entropy of 0.5
  interp_3 = c(0.33, 0.33, 0.34), # spread across three targets, should have entropy of 1
  interp_4_error = c(0, 0, 0), # no non-zero values, should throw an error
  interp_5_error = c(0.5, 0.5, 0.7) # sum is > 1, should throw an error
)

# Test that `calc_shannons_entropy` returns expected values for valid inputs

test_that("calc_shannons_entropy returns expected values", {
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_1), 0)
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_2), 0.5)
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_3), 1)
})

# Test that `calc_shannons_entropy` throws errors for invalid inputs

test_that("calc_shannons_entropy throws errors for invalid inputs", {
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_4_error),
    "no non-zero values"
  )
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_5_error),
    "sum of the probabilities exceeds 1"
  )
})
