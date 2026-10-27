#' Calculate similarity between interpreters
#'
#' @param data A `membership_matrix` object returned by [membership_matrix()].
#' @param by_source Logical. If `FALSE` (default), returns one row per interpreter pair summarised across `source` units. If `TRUE`, returns one row per `source` unit and interpreter pair.
#'
#' @returns A tibble. With `by_source = FALSE`, columns `interpreter_x`, `interpreter_y`, `n_units`, `similarity`, `median_similarity`, `share_identical` and `dissimilarity`, with one row per interpreter pair in both directions plus the diagonal. With `by_source = TRUE`, columns `source`, `interpreter_a`, `interpreter_b`, `similarity` and `dissimilarity`.
#'
#' @details
#' Returns the similarity between each pair of interpreters as `1 - 0.5 * sum(|a - b|)`, where `a` and `b` are the membership vectors of two interpreters for the same `source` unit. When membership values for a `source` sum to 1, this is the share of membership the two interpreters agree on: 1 means identical membership and 0 means no target in common. Only `source` units assessed by both interpreters are compared. Dissimilarity is calculated as `1 - similarity`.
#'
#' The summary is ready for [membership_heatmap_plot()]: `similarity` is the mean across `source` units, `share_identical` is the share of `source` units with identical membership, and `n_units` counts the units compared. Pairs are mirrored so the matrix is symmetric, and the diagonal is set to 1 with `n_units` as the number of units each interpreter assessed.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future. Users may choose from additional similarity measures, such as the normalised Euclidean distance and the fuzzy Jaccard (Ruzicka) index.
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
#' TASVEG_mat <- membership_matrix(TASVEG_memb)
#' calc_similarity(TASVEG_mat)
#' calc_similarity(TASVEG_mat, by_source = TRUE)
#'
calc_similarity <- function(data, by_source = FALSE) {
  stopifnot(inherits(data, "membership_matrix"))

  interpreters <- dimnames(data)$interpreter
  if (length(interpreters) < 2) {
    cli::cli_abort(
      "At least two interpreters are needed to calculate similarity."
    )
  }

  pairs <- tidyr::expand_grid(
    interpreter_a = interpreters,
    interpreter_b = interpreters
  ) |>
    dplyr::filter(.data$interpreter_a < .data$interpreter_b)

  # half L1 similarity per source, NA where either interpreter did not assess it
  sims <- purrr::map2(pairs$interpreter_a, pairs$interpreter_b, \(a, b) {
    tibble::tibble(
      source = dimnames(data)$source,
      interpreter_a = a,
      interpreter_b = b,
      similarity = 1 -
        0.5 *
          rowSums(abs(
            unclass(data)[,, a, drop = FALSE] -
              unclass(data)[,, b, drop = FALSE]
          ))
    )
  }) |>
    dplyr::bind_rows() |>
    dplyr::filter(!is.na(.data$similarity)) |>
    dplyr::mutate(dissimilarity = 1 - .data$similarity)

  if (by_source) {
    return(sims)
  }

  summary <- dplyr::summarise(
    sims,
    n_units = dplyr::n(),
    median_similarity = stats::median(.data$similarity),
    share_identical = mean(.data$dissimilarity < 0.001),
    similarity = mean(.data$similarity),
    .by = c("interpreter_a", "interpreter_b")
  )

  # mirror pairs and add the diagonal
  dplyr::bind_rows(
    summary,
    dplyr::rename(
      summary,
      interpreter_a = "interpreter_b",
      interpreter_b = "interpreter_a"
    ),
    tibble::tibble(
      interpreter_a = interpreters,
      interpreter_b = interpreters,
      n_units = apply(!is.na(unclass(data)[, 1, , drop = FALSE]), 3, sum),
      median_similarity = 1,
      share_identical = 1,
      similarity = 1
    )
  ) |>
    dplyr::rename(
      interpreter_x = "interpreter_a",
      interpreter_y = "interpreter_b"
    ) |>
    dplyr::relocate("similarity", .after = "n_units") |>
    dplyr::mutate(dissimilarity = 1 - .data$similarity)
}
