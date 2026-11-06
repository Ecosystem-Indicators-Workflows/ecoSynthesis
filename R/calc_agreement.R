#' Calculate agreement between interpreters
#'
#' @param data A `membership_matrix` object returned by [membership_matrix()].
#' @param sources A character vector of `source` units to compare. If `NULL` (default), all `source` units are used.
#' @param targets A character vector of `target` units to compare. If `NULL` (default), all `target` units are used.
#' @param round The round of elicitation to compare. Not used yet, as round is not included in `membership_tbl`.
#' @param by_source Logical. If `FALSE` (default), returns one row per interpreter pair summarised across `source` units, i.e., the mean pairwise (dis)similarity across the `source` units. If `TRUE`, returns one row per `source` unit and interpreter pair, i.e., the pairwise (dis)similarity for each `source` unit.
#'
#' @returns A tibble. With `by_source = FALSE`, columns `interpreter_x`, `interpreter_y`, `n_units`, `mean_similarity`, `median_similarity`, `share_identical` and `mean_dissimilarity`, with one row per interpreter pair in both directions plus the diagonal. With `by_source = TRUE`, columns `source`, `interpreter_x`, `interpreter_y`, `similarity` and `dissimilarity`, with each interpreter pair once.
#'
#' @details
#' Returns the similarity between each pair of interpreters as `1 - 0.5 * sum(|a - b|)`, where `a` and `b` are the membership vectors of two interpreters for the same `source` unit. When membership values for a `source` sum to 1, this is the share of membership the two interpreters agree on: 1 means identical membership and 0 means no target in common. Only `source` units assessed by both interpreters are compared. Dissimilarity is calculated as `1 - similarity`.
#'
#' By default pairwise similarity is calculated globally, across all `source` units, to track change across rounds and report final round values. `mean_similarity` is the mean across `source` units, `share_identical` is the share of `source` units with identical membership, and `n_units` counts the units compared. Pairs of interpreters are mirrored so the matrix is symmetrical, and the diagonal is set to 1 with `n_units` representing the number of units each interpreter assessed. This makes it easy to visualize the agreement between interpreters using [membership_target_pair_heatmap()].
#'
#' ## Filtering by `sources` and `targets`
#' Use `sources` to calculate similarity within a subset of `source` units, such as a single unit or a handful of related units. Use `targets` to compare only some `target` units; in which case, membership vectors are then incomplete, so pairwise `similarity` measures agreement on selected `targets` only, and `source` units where neither interpreter used those targets count as identical.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future. Users may filter by round of elicitation once round is included in `membership_tbl`, and choose from additional similarity measures, such as the normalised Euclidean distance and the fuzzy Jaccard (Ruzicka) index.
#'
#' To discuss: add flag to return a non-symmetrical matrix with only one row per pair of interpreters, or a symmetrical matrix with the diagonal set to NA for easier plotting / analysis.
#'
#' @export
#' @author Abhimanyu Raj Singh, JR Ferrer-Paris and Elliot Gould
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

  interpreters <- dimnames(memb_array)$interpreter
  if (length(interpreters) < 2) {
    cli::cli_abort(
      "At least two interpreters are needed to calculate similarity."
    )
  }

  interp_pairs <- tidyr::expand_grid(
    interpreter_x = interpreters,
    interpreter_y = interpreters
  )

  # half L1 similarity per source, NA where either interpreter did not assess it
  sim_by_source <- purrr::map2(
    interp_pairs$interpreter_x,
    interp_pairs$interpreter_y,
    \(a, b) {
      dissimilarity <- 0.5 *
        unname(rowSums(abs(
          memb_array[,, a, drop = FALSE] - memb_array[,, b, drop = FALSE]
        )))
      similarity <- 1 - dissimilarity
      tibble::tibble(
        source = dimnames(memb_array)$source,
        interpreter_x = a,
        interpreter_y = b,
        similarity,
        dissimilarity
      )
    }
  ) |>
    dplyr::bind_rows() |>
    dplyr::filter(!is.na(.data$similarity))

  if (by_source) {
    sim_by_source |>
      dplyr::filter(.data$interpreter_x > .data$interpreter_y)
  } else {
    # median and share before similarity, which replaces the per-source column
    sim_by_source |>
      dplyr::summarise(
        n_units = dplyr::n(),
        median_similarity = stats::median(.data$similarity),
        share_identical = mean(.data$dissimilarity < 0.001),
        mean_similarity = mean(.data$similarity),
        mean_dissimilarity = mean(.data$dissimilarity),
        .by = c("interpreter_x", "interpreter_y")
      ) |>
      dplyr::relocate("mean_similarity", .after = "n_units")
  }
}
