#' Calculate agreement between interpreters
#'
#' @param data A `membership_matrix` object returned by [membership_matrix()].
#' @param sources A character vector of `source` units to compare. If `NULL` (default), all `source` units are used.
#' @param targets A character vector of `target` units to compare. If `NULL` (default), all `target` units are used.
#' @param round The round of elicitation to compare. Not used yet, as round is not included in `membership_tbl`.
#' @param by_source Logical. If `FALSE` (default), returns one row per interpreter pair summarised across `source` units. If `TRUE`, returns one row per `source` unit and interpreter pair.
#'
#' @returns A tibble. With `by_source = FALSE`, columns `interpreter_x`, `interpreter_y`, `n_units`, `similarity`, `median_similarity`, `share_identical` and `dissimilarity`, with one row per interpreter pair in both directions plus the diagonal. With `by_source = TRUE`, columns `source`, `interpreter_a`, `interpreter_b`, `similarity` and `dissimilarity`.
#'
#' @details
#' Returns the similarity between each pair of interpreters as `1 - 0.5 * sum(|a - b|)`, where `a` and `b` are the membership vectors of two interpreters for the same `source` unit. When membership values for a `source` sum to 1, this is the share of membership the two interpreters agree on: 1 means identical membership and 0 means no target in common. Only `source` units assessed by both interpreters are compared. Dissimilarity is calculated as `1 - similarity`.
#'
#' By default similarity is calculated globally, across all `source` units, to track change across rounds and report final round values. Use `sources` to calculate similarity within a subset of `source` units, such as a single unit or a handful of related units. Use `targets` to compare only some `target` units: membership vectors are then not complete, so similarity measures agreement on those targets only, and `source` units where neither interpreter used those targets count as identical.
#'
#' In the summary, `similarity` is the mean across `source` units, `share_identical` is the share of `source` units with identical membership, and `n_units` counts the units compared. Pairs are mirrored so the matrix is symmetric, and the diagonal is set to 1 with `n_units` as the number of units each interpreter assessed. The summary is ready to plot as a heatmap of interpreter pairs.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future. Users may filter by round of elicitation once round is included in `membership_tbl`, and choose from additional similarity measures, such as the normalised Euclidean distance and the fuzzy Jaccard (Ruzicka) index.
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
#'
#' # global similarity across all source units
#' calc_agreement(TASVEG_mat)
#'
#' # similarity within a single source unit, or a subset of related units
#' calc_agreement(TASVEG_mat, sources = "HSW")
#' calc_agreement(TASVEG_mat, sources = c("AHF", "AHL"), by_source = TRUE)
#'
calc_agreement <- function(
  data,
  sources = NULL,
  targets = NULL,
  round = NULL,
  by_source = FALSE
) {
  #TODO filter by round once included in membership_tbl
  checkmate::assert_class(data, "membership_matrix")
  checkmate::assert_number(round, null.ok = TRUE)
  checkmate::assert_flag(by_source)

  if (!is.null(round)) {
    cli::cli_warn("{.arg round} is not used yet, all rounds are compared.")
  }

  memb_array <- unclass(data)
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

  interpreters <- dimnames(memb_array)$interpreter
  if (length(interpreters) < 2) {
    cli::cli_abort(
      "At least two interpreters are needed to calculate similarity."
    )
  }

  interp_pairs <- tidyr::expand_grid(
    interpreter_a = interpreters,
    interpreter_b = interpreters
  ) |>
    dplyr::filter(interpreter_a < interpreter_b)

  # half L1 similarity per source, NA where either interpreter did not assess it
  sim_by_source <- purrr::map2(
    interp_pairs$interpreter_a,
    interp_pairs$interpreter_b,
    \(a, b) {
      tibble::tibble(
        source = dimnames(memb_array)$source,
        interpreter_a = a,
        interpreter_b = b,
        similarity = 1 -
          0.5 *
            unname(rowSums(abs(
              memb_array[,, a, drop = FALSE] - memb_array[,, b, drop = FALSE]
            )))
      )
    }
  ) |>
    dplyr::bind_rows() |>
    dplyr::filter(!is.na(similarity)) |>
    dplyr::mutate(dissimilarity = 1 - similarity)

  if (by_source) {
    return(sim_by_source)
  }

  sim_pairs <- sim_by_source |>
    dplyr::summarise(
      n_units = dplyr::n(),
      median_similarity = stats::median(similarity),
      share_identical = mean(dissimilarity < 0.001),
      similarity = mean(similarity),
      .by = c("interpreter_a", "interpreter_b")
    )

  # each interpreter compared with themself, n_units is the units they assessed
  sim_diagonal <- tibble::tibble(
    interpreter_a = interpreters,
    interpreter_b = interpreters,
    n_units = unname(apply(!is.na(memb_array[, 1, , drop = FALSE]), 3, sum)),
    median_similarity = 1,
    share_identical = 1,
    similarity = 1
  )

  # mirror pairs so the matrix is symmetric, then add the diagonal
  sim_pairs |>
    dplyr::bind_rows(
      sim_pairs |>
        dplyr::rename(
          interpreter_a = "interpreter_b",
          interpreter_b = "interpreter_a"
        ),
      sim_diagonal
    ) |>
    dplyr::rename(
      interpreter_x = "interpreter_a",
      interpreter_y = "interpreter_b"
    ) |>
    dplyr::relocate("similarity", .after = "n_units") |>
    dplyr::mutate(dissimilarity = 1 - similarity)
}
