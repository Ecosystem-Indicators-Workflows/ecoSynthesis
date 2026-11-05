#' Calculate the entropy of a membership matrix
#'
#' @param data A `membership_matrix` object returned by [membership_matrix()].
#' @param sources A character vector of `source` units to compare. If `NULL` (default), all `source` units are used.
#' @param targets A character vector of `target` units to compare. If `NULL` (default), all `target` units are used.
#' @param round
#' @param level
#' @param weighting
#'
#' @returns
#'
#' @export
#' @examples
calc_entropy_matrix <- function(
  data,
  sources = NULL,
  targets = NULL,
  round = NULL,
  level = c("interpreter", "source", "overall"),
  weighting = c("observations", "sources")
) {
  # Argument Checks
  checkmate::assert_class(data, "membership_matrix")
  checkmate::assert_number(round, null.ok = TRUE)
  checkmate::assert_character(sources, null.ok = TRUE)
  checkmate::assert_character(targets, null.ok = TRUE)
  checkmate::assert_choice(level, c("interpreter", "source", "overall"))
  checkmate::assert_choice(weighting, c("observations", "sources"))

  #TODO remove this once round is included in membership_matrix
  if (!is.null(round)) {
    cli::cli_warn("{.arg round} is not used yet, all rounds are considered.")
  }

  # Check that sources and targets are valid - i.e. they are present in the membership matrix
  memb_array <- unclass(data) #TODO format of membership_matrix should change so we do not have to call unclass to work with it
  if (!is.null(sources)) {
    checkmate::assert_subset(
      sources,
      dimnames(memb_array)$source,
      empty.ok = FALSE
    )
    memb_array <- memb_array[sources, , , drop = FALSE]
  }

  if (!is.null(targets)) {
    checkmate::assert_subset(
      targets,
      dimnames(memb_array)$target,
      empty.ok = FALSE
    )
    memb_array <- memb_array[, targets, , drop = FALSE]
  }
}

calc_entropy_tbl <- function(
  data,
  sources = NULL,
  targets = NULL,
  round = NULL,
  level = c("interpreter", "source", "overall"),
  weighting = c("observations", "sources")
) {
  # Argument Checks
  checkmate::assert_class(data, "membership_tbl")
  checkmate::assert_number(round, null.ok = TRUE)
  checkmate::assert_character(sources, null.ok = TRUE)
  checkmate::assert_character(targets, null.ok = TRUE)
  checkmate::assert_choice(level, c("interpreter", "source", "overall"))
  checkmate::assert_choice(weighting, c("observations", "sources"))

  #TODO remove this once round is included in membership_tbl
  if (!is.null(round)) {
    cli::cli_warn("{.arg round} is not used yet, all rounds are considered.")
  }

  # Check that sources and targets are valid - i.e. they are present in the membership_tbl
}

#' Calculate Shannon's entropy for a membership function
#'
#' @param p a numeric vector of probabilities (non-negative values that sum to 1)
#'
#' @returns A numeric value representing the Shannon's entropy of the input probability vector, normalised by the number of non-zero probabilities.
#'
#' @details
#' Shannon's entropy is a measure of uncertainty or information content in a probability distribution. It is calculated as the negative sum of the probabilities multiplied by their logarithm (base 2), normalised by the logarithm of the number of non-zero probabilities.
#'
#' The function handles cases where the input vector has no non-zero values or only one non-zero value, returning an error or zero, respectively.
#'
#' @keywords internal
#'
#' @examples
calc_shannons_entropy <- function(p = numeric(length = 0L)) {
  # Remove zero probabilities to avoid log(0) = NaN
  p_nonzero <- p[p > 0]
  S <- length(p_nonzero) # Number of non-zero probabilities

  # Validate the input probability vector
  if (S == 0) {
    cli::cli_abort(
      "Cannot calculate entropy for a membership function with no non-zero values."
    )
  } else if (sum(p) > 1) {
    cli::cli_abort(
      "The sum of the probabilities exceeds 1, which is invalid for a membership function"
    )
  } else if (sum(p) < 1) {
    cli::cli_warn(
      "The sum of the probabilities is less than 1, which may indicate an incomplete membership function"
    )
  } else if (any(p < 0)) {
    cli::cli_abort(
      "Negative probabilities are not allowed in a membership function"
    )
  } else if (any(p > 1)) {
    cli::cli_abort(
      "Probabilities greater than 1 are not allowed in a membership function"
    )
  } else if (S < length(p)) {
    cli::cli_warn(
      "The number of non-zero probabilities is less than the total number of probabilities, which may indicate an incomplete membership function"
    )
  }

  # Calculate normalised Shannon's entropy
  if (S <= 1) {
    entropy <- 0 # Entropy is 0 when there's only one non-zero probability
  } else {
    entropy <- -sum(p_nonzero * log2(p_nonzero)) / log2(S) # Normalise by log2(S)
  }

  return(entropy)
}
