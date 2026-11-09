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

#' Calculate the entropy of a membership function represented as a probability vector
#'
#' @param data A `membership_tbl` object returned by [membership_tbl()].
#' @param sources A character vector of `source` units to compare. If `NULL` (default), all `source` units are used.
#' @param targets A character vector of `target` units to compare. If `NULL` (default), all `target` units are used.
#' @param round A numeric value representing the round to consider. If `NULL` (default), all rounds are considered.
#' @param level A character string specifying the level of analysis. Can be "interpreter", "source", or "overall".
#' @param weighting A character string specifying the weighting method. Can be "observations" or "sources".
#'
#' @returns
#'
#' @export
#' @examples
#' library(ecoSynthesis)
#' data("TASVEG_xref")
#' TASVEG_memb <- membership_tbl(
#'   TASVEG_xref,
#'   source_id = "VEGCODE",
#'   target_id = "efg",
#'   membership = "memb",
#'   interpreter = "interp"
#' ) |>
#'   filter(VEGCODE %nin% c("AHF", "DOW", "MBS", "OAQ", "NAD")) #TODO rm filter
#' # Note these are placeholder args for level and weighting, flags are currently not implemented
#' TASVEG_memb  |> calc_entropy_tbl(level = "source", weighting = "observations")
calc_entropy_tbl <- function(
  data,
  sources = NULL,
  targets = NULL,
  round = NULL,
  level = c("interpreter", "source", "overall"),
  weighting = c("observations", "sources")
) {
  # -----Argument Checks -----
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
  if (!is.null(sources)) {
    checkmate::assert_true(
      all(sources %in% unique(data$source)),
      msg = "Some sources are not present in the membership_tbl"
    )
  }
  if (!is.null(targets)) {
    checkmate::assert_true(
      all(targets %in% unique(data$target)),
      msg = "Some targets are not present in the membership_tbl"
    )
  }
  # ----- Capture attributes -----
  sid <- attr(data, "source_id")
  tid <- attr(data, "target_id")
  mval <- attr(data, "membership")
  inam <- attr(data, "interpreter")
  #rval <- attr(data, "round")
  rval <- "round" #TODO remove this once round is included in membership_tbl

  # ----- Calculate Entropy based on the specified level and weighting -----

  # %%%%%%%%%%%%%%%%%% SANDBOX TESTING %%%%%%%%%%%%%%%%%%
  # This code runs outside of function, and is used to test the entropy calculations on the TASVEG dataset and needs to be rewritten to work with the function arguments and return a tibble
  # ---- Source-localised entropy -----

  interpreter_entropy_by_source <- data |>
    dplyr::group_by(dplyr::pick(dplyr::any_of(c(sid, rval)))) |> #use pick when passing vector of strings
    tidyr::complete(
      tidyr::nesting(dplyr::pick(dplyr::all_of(c(inam)))),
      .data[[tid]],
      fill = rlang::list2(
        !!mval := 0
      ),
      explicit = FALSE
    ) |>
    dplyr::ungroup() |>
    dplyr::summarise(
      membership_fn = purrr::map2(
        list(.data[[mval]]),
        list(.data[[tid]]),
        stats::setNames
      ),
      .by = dplyr::any_of(c(sid, rval, inam))
    ) |>
    dplyr::mutate(
      N_targets_interp = purrr::map_int(
        membership_fn,
        ~ .x[.x > 0] |> length()
      ),
      .by = dplyr::any_of(c(sid, rval, inam))
    ) |>
    dplyr::mutate(
      N_targets_source = purrr::map_int(membership_fn, ~ length(.x)),
      .by = dplyr::any_of(c(sid, rval))
    ) |>
    dplyr::mutate(
      entropy_source_normalised = purrr::map_dbl(
        membership_fn,
        calc_shannons_entropy,
        N = N_targets_source
      ),
      entropy_interpreter = purrr::map_dbl(
        membership_fn,
        calc_shannons_entropy
      ),
      .keep = "unused",
      .by = dplyr::any_of(c(sid, rval, inam))
    )

  overall_interpreter_entropy_by_source <-
    interpreter_entropy_by_source |>
    dplyr::ungroup() |>
    dplyr::summarise(
#' Calculate Shannon's entropy for a membership function or vector of probabilities
#'
#' @param p a numeric vector of probabilities (non-negative values that sum to 1)
#' @param N an optional numeric value representing the number of categories (targets) for normalisation. If not provided, the function will use the number of non-zero probabilities in `p` as the baseline for normalisation
#' @param tol a numeric value representing the tolerance for checking if the sum of probabilities is equal to 1 (default is 1e-9)
#'
#' @returns A numeric value representing the Shannon's entropy of the input probability vector, normalised by the number of non-zero probabilities if `N` is not provided, or by `N` if it is provided.
#'
#' @details
#'
#' ## Shannon's entropy
#'
#' Shannon's entropy is a measure of uncertainty or information content in a probability distribution. It is calculated as the negative sum of the probabilities multiplied by their logarithm (base 2), normalised by the logarithm of the number of non-zero probabilities (default behaviour) or by the logarithm of `N` if it is provided.
#'
#' The function handles cases where the input vector has no non-zero values or only one non-zero value, returning an error or zero, respectively.
#'
#' ### Normalisation choices, setting `N`
#' The function allows for two normalisation options:
#' 1. **Default behaviour**: If `N` is not provided, the function uses the number of non-zero probabilities in `p` as the baseline for normalisation. This measure shows how decisively a single interpreter made their choices (internal evenness).
#' 2. **Provided `N`**: If `N` is provided, the function uses this value as the baseline for normalisation. This allows for comparison of entropy across interpreters with different numbers of *selected* targets, showing how evenly an interpreter distributed their membership across the set of available targets (external evenness).
#'
#' When `N` is provided, it must be greater than or equal to the number of non-zero probabilities in `p`. If `N` is less than the number of non-zero probabilities, the function will throw an error.
#'
#' When `N` is set to the maximum number number of targets under consideration for a given source unit, the entropy measure reflects how evenly an interpreter distributed their membership across all possible targets for that source unit, regardless of whether they selected them or not. It standardises interpreters evaluating the exact same source against each other (gives uncertainty of the membership function relative to peers)
#'
#' When `N` is set to the total targets in the cross-map dataset, it standardises every observation (i.e., a membership function) against the entire cross-map to highlight overall noise.
#'
#' ## Relation to other functions
#' This function is used internally by [calc_entropy_tbl()] to compute the entropy of membership functions represented as probability vectors.
#'
#' @keywords 'membership uncertainty'
#'
#' @returns A numeric value representing the Shannon's entropy of the input probability vector. See details for interpretation depending on the value of `N`.
#'
#' @examples
#' # Example 1: Calculate entropy for a simple probability vector (interpreter-normalised calculation)
#' p <- c(0.5, 0.5, 0, 0)
#' calc_shannons_entropy(p)
#' # Example 2: Calculate entropy for a probability vector with a specified N (simulating source- and set-normalised calculation)
#' p <- c(0.5, 0.5, 0, 0)
#' N <- 4
#' calc_shannons_entropy(p, N)
#' calc_shannons_entropy(p, N)
calc_shannons_entropy <- function(
  p = numeric(length = 0L),
  N = NULL,
  tol = 1e-9
) {
  # 1. Validation Checks (Value boundaries)
  if (any(p < 0)) {
    cli::cli_abort(
      "Negative probabilities are not allowed in a membership function"
    )
  }
  if (any(p > 1)) {
    cli::cli_abort(
      "Probabilities greater than 1 are not allowed in a membership function"
    )
  }

  if (!is.null(N) && N > length(p)) {
    cli::cli_abort(
      "Provided normalisation base N ({N}) cannot be greater than the membership function length ({length(p)}). All N targets must be represented in the membership function, even if their probabilities are 0."
    )
  }

  # Remove zero probabilities to avoid log(0) = NaN
  p_nonzero <- p[p > 0]
  S <- length(p_nonzero) # Number of non-zero probabilities

  if (S == 0) {
    cli::cli_abort(
      "Cannot calculate entropy for a membership function with no non-zero values."
    )
  }

  # 2. Vector Sum Validation (Using Tolerance)
  p_sum <- sum(p)

  if (p_sum > (1 + tol)) {
    cli::cli_abort(
      "The sum of the probabilities exceeds 1 ({p_sum}), which is invalid for a membership function"
    )
  } else if (p_sum < (1 - tol)) {
    cli::cli_warn(
      "The sum of the probabilities is less than 1 ({p_sum}), which may indicate an incomplete membership function"
    )
  }

  # Normalise Vector internally to fix minor floating-point skew from upstream rounding
  # This guarantees -sum(p * log(p)) won't drift due to p_sum being 1.0000001
  p_nonzero <- p_nonzero / p_sum

  # 3. Determine the value used for normalising (the denominator)
  # Estimand 1: Default to active targets if N is not provided
  denom_targets <- if (is.null(N)) S else N

  # Validate N if provided by the user
  if (!is.null(N)) {
    if (N < S) {
      cli::cli_abort(
        "Provided normalisation base N ({N}) cannot be less than the active target count S ({S})."
      )
    }
  }

  # 4. Calculate normalised Shannon's entropy
  if (denom_targets <= 1) {
    entropy <- 0
  } else {
    # Standard formula: -sum(p * log2(p)) / log2(denominator)
    entropy <- -sum(p_nonzero * log2(p_nonzero)) / log2(denom_targets)
  }

  return(entropy)
}
