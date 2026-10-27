#' Create a membership matrix
#'
#' @param data A `membership_tbl` object containing membership data in long format, with columns for source, target, membership and interpreter values.
#'
#' @returns A `membership_matrix` object: a numeric array with dimensions `[source, target, interpreter]`.
#'
#' @details
#' Returns the membership values as one `source` by `target` matrix per interpreter, ready for `calc_similarity()`. Targets an interpreter did not use for a `source` they assessed are filled with 0, and `source` units an interpreter did not assess are left as `NA`. Repeated targets for the same `source` and interpreter are summed. Rows with missing membership values are dropped with a warning.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future. Users may filter by round of elicitation, or add round as a fourth dimension.
#'
#'
#' @export
#' @author Abhimanyu Raj Singh
#' @family similarity
#' @examples
#' # Example usage with the TASVEG_xref dataset
#' data("TASVEG_xref")
#' TASVEG_memb <- membership_tbl(
#'   TASVEG_xref,
#'   source_id = "VEGCODE",
#'   target_id = "efg",
#'   membership = "memb",
#'   interpreter = "interp"
#' )
#' membership_matrix(TASVEG_memb)
#'
membership_matrix <- function(data) {
  #TODO filter by round once included in membership_tbl
  checkmate::assert_class(data, "membership_tbl")
  long <- data |>
    tibble::as_tibble() |>
    dplyr::select(
      source = attr(data, "source_id"),
      target = attr(data, "target_id"),
      membership = attr(data, "membership"),
      interpreter = attr(data, "interpreter")
    ) |>
    dplyr::mutate(dplyr::across(
      c("source", "target", "interpreter"),
      as.character
    ))

  n_missing <- sum(is.na(long$membership))
  if (n_missing > 0) {
    cli::cli_warn("Dropped {n_missing} row{?s} with missing membership values.")
    long <- dplyr::filter(long, !is.na(.data$membership))
  }

  long <- dplyr::summarise(
    long,
    membership = sum(.data$membership),
    .by = c("source", "target", "interpreter")
  )

  dims <- list(
    source = sort(unique(long$source)),
    target = sort(unique(long$target)),
    interpreter = sort(unique(long$interpreter))
  )
  m <- array(NA_real_, dim = lengths(dims), dimnames = dims)

  # sources an interpreter assessed get 0 for unused targets, the rest stay NA
  assessed <- dplyr::distinct(long, .data$source, .data$interpreter)
  n_targets <- length(dims$target)
  m[cbind(
    rep(assessed$source, each = n_targets),
    dims$target,
    rep(assessed$interpreter, each = n_targets)
  )] <- 0
  m[cbind(long$source, long$target, long$interpreter)] <- long$membership

  structure(m, class = "membership_matrix")
}

#' @export
print.membership_matrix <- function(x, ...) {
  d <- dim(x)
  cli::cli_text(
    "<membership_matrix> {d[1]} source{?s} x {d[2]} target{?s} x {d[3]} interpreter{?s}"
  )
  n_assessed <- apply(!is.na(unclass(x)[, 1, , drop = FALSE]), 3, sum)
  cli::cli_bullets(stats::setNames(
    paste0(names(n_assessed), ": ", n_assessed, " source units assessed"),
    rep("*", length(n_assessed))
  ))
  cli::cli_text(
    "Use {.code unclass(x)[source, target, interpreter]} to view values."
  )
  invisible(x)
}
