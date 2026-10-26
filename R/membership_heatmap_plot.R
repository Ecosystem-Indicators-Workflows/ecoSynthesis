#' Create a heatmap of target use by interpreter
#'
#' @param data A `membership_tbl` object containing membership data in long format, with columns for source, target, membership and interpreter values.
#'
#' @returns A ggplot object representing the heatmap of target use by interpreter.
#'
#' @details
#' Returns a heatmap of how often each `target` is used by each interpreter, for a single round of elicitation. Each tile shows the number of `source` units an interpreter assigned to a `target`, with a colour gradient from light to dark teal for more source units. Empty tiles mean the interpreter never used that target. The plot helps to spot targets used by only one interpreter, which may indicate a difference in interpretation or a typo in the target id.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future to include additional customization options. Users may filter by round of elicitation, show the sum of membership instead of the number of source units, and specify theme options, colour palette, label aesthetics, axis labels, title and subtitle to tailor the plot to their specific needs.
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
#'   target_id = "efg",plot
#'   membership = "memb",
#'   interpreter = "interp"
#' )
#' membership_target_heatmap(TASVEG_memb)
#'
membership_target_heatmap <- function(data) {
  #TODO filter by round once included in membership_tbl
  #TODO allow user to specify theme options
  #TODO allow user to specify title
  #TODO allow user to specify subtitle
  stopifnot(inherits(data, "membership_tbl"))

  ## Extract col names from attributes for use in plot aesthetics
  interp <- attr(data, "interpreter")
  tid <- attr(data, "target_id")

  textcol <- "grey40"

  data |>
    dplyr::count(.data[[tid]], .data[[interp]], name = "n_sources") |>
    ggplot2::ggplot(ggplot2::aes(
      x = .data[[interp]],
      y = .data[[tid]],
      fill = .data$n_sources
    )) +
    ggplot2::geom_tile(colour = "white", linewidth = 1) +
    ggplot2::geom_text(ggplot2::aes(label = .data$n_sources), size = 3) +
    ggplot2::scale_fill_gradient(low = "#E8F4F2", high = "#0F6B66") +
    ggplot2::labs(
      x = "interpreter",
      y = "target",
      title = "Round X Target Use",
      subtitle = "Number of source units assigned to each target"
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
