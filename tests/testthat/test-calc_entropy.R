# Membership functions for testing helper `function calc_shannons_entropy`

test_membership_vectors <- list(
  interp_1 = c(1, 0, 0), # concentrated on one target
  interp_2 = c(0.5, 0.5, 0), # Perfectly even across 2 targets
  interp_3 = c(1 / 3, 1 / 3, 1 / 3), # Perfectly even across 3 targets
  interp_4_approx = c(0.33, 0.33, 0.34), # Close to 1, but with minor rounding skew, spread across 3 targets
  interp_5_error = c(0, 0, 0), # no non-zero values, should throw an error
  interp_6_error = c(0.5, 0.5, 0.7), # sum is > 1, should throw an error
  interp_7_error = c(-0.1, 0.5, 0.6) # negative probability, should throw an error
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

test_that("calc_shannons_entropy handles dynamic normalisation boundaries correctly", {
  # Estimand 1: Local Certainty (Normalising by individual active targets)
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_1), 0)
  expect_equal(calc_shannons_entropy(test_membership_vectors$interp_2), 1) # S=2, max evenness = 1

  # Estimand 2 & 3: Normalising by an explicit system ceiling N
  # Assuming 3 total target options available globally or per source
  expect_equal(
    calc_shannons_entropy(test_membership_vectors$interp_2, N = 3),
    0.6309298,
    tolerance = 1e-7
  )

  # Estimand 3: Normalising by the total number of targets in the cross-map
  # Checking Option 3 with the three-target vector
  expect_equal(
    calc_shannons_entropy(test_membership_vectors$interp_4_approx, N = 3),
    1,
    tolerance = 1e-3 # Loosened slightly to accommodate the user's manual 0.33/0.34 rounding
  )
})

# Test that `calc_shannons_entropy` throws errors for invalid inputs
test_that("calc_shannons_entropy correctly validates malformed inputs", {
  # Check for lack of data error
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_5_error)
  )

  # Check for sum > 1 validation error
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_6_error)
  )

  # Check for negative probabilities error
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_7_error)
  )

  # Check for N > length(p) error
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_2, N = 4)
  )

  # Check for probabilities > 1 error
  expect_error(
    calc_shannons_entropy(test_membership_vectors$interp_6_error)
  )
})

# ----- Testing the `calc_entropy` function with a small example dataset -----

test_tbl <- test_memb() |> dplyr::rename(round = roundr) #TODO rm and insert inline when round is added to the test_memb() helper function

# Argument validation tests for `calc_entropy` function

test_that("calc_entropy correctly validates its arguments", {
  # Check for absent sources error
  expect_error(
    calc_entropy_tbl(test_tbl, sources = LETTERS[1:4])
  )
  # Check for absent targets error
  expect_error(
    calc_entropy_tbl(test_tbl, targets = letters[1:4])
  )
  # check for invalid combinations of sources and targets that do not exist in the membership_tbl
  expect_error(
    calc_entropy_tbl(test_tbl, sources = "S2", targets = "Y") # S2 has no membership for Y
  )
})
