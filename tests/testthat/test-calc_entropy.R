# Membership functions for testing helper `function calc_shannons_entropy`

test_membership_vectors <- list(
  interp_1 = c(1, 0, 0), # concentrated on one target, should have entropy of 0
  interp_2 = c(0.5, 0.5, 0), # Perfectly even across selected targets, should have entropy of 1
  interp_3 = c(1 / 3, 1 / 3, 1 / 3), # Perfectly even across selected targets, should have entropy of 1
  interp_4_approx = c(0.33, 0.33, 0.34), # Close to 1, but with minor rounding skew
  interp_5_error = c(0, 0, 0), # no non-zero values, should throw an error
  interp_6_error = c(0.5, 0.5, 0.7) # sum is > 1, should throw an error
)

# Test that `calc_shannons_entropy` returns expected values for valid inputs

test_that("calc_shannons_entropy returns mathematically correct values", {
  # 1. Concentrated probabilities must equal 0
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_1), 0)

  # 2. Equally split probabilities must equal 1 (regardless of category length)
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_2), 1)
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_3), 1)

  # 3. For rounded values, use tolerance to verify it is close to 1
  expect_equal(
    calc_shannons_entropy(test_membership_vectors$interp_4_approx),
    1.0,
    tolerance = 1e-4 # Allow for minor rounding errors in the calculation
  )
})

# Test that `calc_shannons_entropy` throws errors for invalid inputs
test_that("calc_shannons_entropy correctly validates malformed inputs", {
  # 4. Check for lack of data error
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_5_error),
    regexp = "Cannot calculate entropy"
  )

  # 5. Check for sum > 1 validation error
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_6_error),
    regexp = "The sum of the probabilities exceeds 1"
  )
})
