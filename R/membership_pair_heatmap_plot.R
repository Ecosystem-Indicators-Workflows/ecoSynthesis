#' Create a heatmap of shared target use by pairs of interpreters
#'
#' @param data A `membership_tbl` object containing membership data in long format, with columns for source, target, membership and interpreter values.
#'
#' @returns A ggplot object representing the heatmap of shared target use by pairs of interpreters.
#'
#' @details
#' Returns a heatmap of how often each pair of interpreters used the same `target` for the same `source` unit, for a single round of elicitation. Each tile shows the number of `source` units where both interpreters of a pair assigned membership to a `target`, with a colour gradient from light to dark teal for more source units. Empty tiles mean the pair never used that target for the same source unit. Rows with missing or zero membership are not counted as use. The plot helps to spot targets that pairs of interpreters agree or disagree on.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future to include additional customization options. Users may filter by round of elicitation, show the number of source units where only one interpreter of a pair used a target, and specify theme options, colour palette, label aesthetics, axis labels, title and subtitle to tailor the plot to their specific needs.
#'
#'
#' @export
#' @author Abhimanyu Raj Singh
#' @family visualisation
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
#' membership_target_pair_heatmap(TASVEG_memb)
#'
membership_target_pair_heatmap <- function(data) {
  #TODO filter by round once included in membership_tbl
  #TODO allow user to specify theme options
  #TODO allow user to specify title
  #TODO allow user to specify subtitle
  stopifnot(inherits(data, "membership_tbl"))

  ## Extract col names from attributes
  interp <- attr(data, "interpreter")
  tid <- attr(data, "target_id")
  sid <- attr(data, "source_id")
  memb <- attr(data, "membership")

  textcol <- "grey40"

  ## Targets used by each interpreter for each source
  used <- data |>
    dplyr::filter(.data[[memb]] > 0) |>
    dplyr::select(
      source = dplyr::all_of(sid),
      target = dplyr::all_of(tid),
      interpreter = dplyr::all_of(interp)
    ) |>
    dplyr::distinct()

  ## Pair interpreters who used the same target for the same source
  used |>
    dplyr::inner_join(
      used,
      by = c("source", "target"),
      suffix = c("_a", "_b"),
      relationship = "many-to-many"
    ) |>
    dplyr::filter(.data$interpreter_a < .data$interpreter_b) |>
    dplyr::count(
      .data$target,
      pair = paste(.data$interpreter_a, "vs", .data$interpreter_b, sep = "\n"),
      name = "n_sources"
    ) |>
    ggplot2::ggplot(ggplot2::aes(
      x = .data$pair,
      y = .data$target,
      fill = .data$n_sources
    )) +
    ggplot2::geom_tile(colour = "white", linewidth = 1) +
    ggplot2::geom_text(ggplot2::aes(label = .data$n_sources), size = 3) +
    ggplot2::scale_fill_gradient(low = "#E8F4F2", high = "#0F6B66") +
    ggplot2::labs(
      x = "interpreter pair",
      y = "target",
      title = "Round 1 Shared Target Use",
      subtitle = "Number of source units where both interpreters used each target"
    ) +
    ggplot2::theme_grey(base_size = 10) +
    ggplot2::theme(
      legend.title = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(
        colour = textcol,
        size = 7,
        face = "bold"
      ),
      axis.text = ggplot2::element_text(colour = textcol),
      plot.title = ggplot2::element_text(
        colour = textcol,
        size = 14,
        face = "bold"
      ),
      #remove plot background and grid
      plot.background = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank()
    )
}
