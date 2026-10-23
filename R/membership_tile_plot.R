#' Create a tile plot of membership data
#'
#' @param data A data frame containing membership data in long format, with columns for interpreter, target, and membership values.
#'
#' @returns A ggplot object representing the tile plot of membership data.
#'
#' @details
#' Returns a tile plot of membership functions among interpreters for a single `source` for a single round of elicitation. The plot uses a color gradient to represent membership values, with tiles colored according to the membership value for each interpreter-target pair. The plot includes labels for each tile showing the rounded membership value.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future to include additional customization options. Users may specify theme options, text color, label aesthetics, geom_tile options, axis labels, title, and subtitle to tailor the plot to their specific needs. These enhancements will allow for greater control over the visual presentation of the membership data.
#'
#'
#' @export
#' @author Elliot Gould
#' @family visualisation
#' @examples
#' #' # Example usage with the TASVEG_mini dataset
#' data("TASVEG_mini")
#' TASVEG_mini |> dplyr::filter(source == "AAP") |> membership_tile_plot()
#' TASVEG_mini |> dplyr::filter(source == "OAQ") |> membership_tile_plot()
#'
membership_tile_plot <- function(data) {
  # Checks
  checkmate::assert(
    checkmate::checkClass(data, "membership_tbl")
  )

  #TODO filter by round once included in example data after #49 merged in
  #TODO ensure interoperable with membership classes

  #TODO allow user to specify theme options
  #TODO allow user to specify text color
  #TODO allow user to specify label aesthetics
  #TODO allow user to specify geom_tile options
  #TODO allow user to specify axis labels
  #TODO allow user to specify title
  #TODO allow user to specify subtitle

  ## Extract col names from attributes for use in plot aesthetics
  interp <- attr(TASVEG_memb, "interpreter")
  sid <- attr(TASVEG_memb, "source_id")
  tid <- attr(TASVEG_memb, "target_id")
  memb <- attr(TASVEG_memb, "membership")

  ## Set text color for plot elements and extract source label for subtitle
  textcol <- "grey40"
  label_source <- data |> pluck(!!!sid, unique)

  data |>
    ggplot(aes(
      y = .data[[interp]],
      x = .data[[tid]],
      fill = .data[[memb]],
      fill_alpha = 0.4
    )) +
    ggplot2::geom_tile(
      colour = "white",
      lwd = 1.5,
      show.legend = TRUE,
      linetype = 1
    ) +
    ggplot2::scale_colour_continuous(
      name = waiver(),
      guide = "colourbar",
      aesthetics = "fill",
      na.value = "grey50",
    ) +
    #remove axis labels, add title
    labs(
      x = "Target",
      y = "Interpreter",
      title = "Round 1 Cross-Referencing", #TODO allow user to specify title
      subtitle = glue::glue("Source: {label_source}") #TODO allow user to specify subtitle
    ) +
    geom_label(
      #TODO allow user to specify label aesthetics
      aes(label = round(.data[[memb]], 2)),
      color = "black",
      size = 4,
      fill = "white"
    ) +
    #equal aspect ratio x and y axis
    coord_fixed() +
    #set base size for all font elements
    ggplot2::theme_grey(base_size = 10) +
    #theme options
    theme(
      palette.colour.continuous = "BuPu",
      #remove legend title
      legend.title = element_blank(),
      #remove legend margin
      legend.spacing = grid::unit(0, "cm"),
      #change legend text properties
      legend.text = element_text(colour = textcol, size = 7, face = "bold"),
      #change legend key height
      legend.key.height = grid::unit(0.8, "cm"),
      #set a slim legend
      legend.key.width = grid::unit(0.2, "cm"),
      #set x axis text size and colour
      axis.text.x = element_text(size = 10, colour = textcol),
      #set y axis text colour and adjust vertical justification
      axis.text.y = element_text(vjust = 0.2, colour = textcol),
      #change axis ticks thickness
      axis.ticks = element_line(linewidth = 0.4),
      #change title font, size, colour and justification
      plot.title = element_text(
        colour = textcol,
        hjust = 0,
        size = 14,
        face = "bold"
      ),
      #remove plot background
      plot.background = element_blank(),
      panel.grid = element_blank(),
      panel.background = element_blank(),
      #remove plot border
      panel.border = element_blank()
    )
}
