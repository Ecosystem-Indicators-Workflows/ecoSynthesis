#' Create a lookup table for a classification
#'
#' @param data A data frame
#' @param id Column containing unique ids of the units in the classification system
#' @param name Column containing a name or short description of the units in the classification system
#' @param eligible Column containing a logical flag for eligible (TRUE) and not eligible (FALSE) units
#'
#' @return An object of class 'lookup_tbl'
#' @export
#' @author JR Ferrer-Paris
#' @examples
#' # All units are eligible per default:
#' lookup_tbl(IUCN_GET_LUT, id = "efg_id", name = "efg_name")
#' # If some units are not eligible, this can be defined as:
#' not_eligible <- c("OAQ", "ORO", "OSM")
#' TASVEG_LUT$eligible <- !TASVEG_LUT$VEGCODE %in% not_eligible
#' lookup_tbl(TASVEG_LUT, "VEGCODE", "VEGCODE_D", "eligible")
lookup_tbl <- function(
  data,
  id = "id",
  name = "name",
  eligible = NULL
) {
  stopifnot(is.data.frame(data))

  required <- c(id, name)

  missing <- setdiff(required, names(data))

  if (length(missing) > 0) {
    stop(
      "Missing required columns: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  if (is.null(eligible)) {
    eligible <- "eligible"
    data[eligible] <- TRUE
  }

  data <- tibble::as_tibble(data)

  structure(
    data,
    id = id,
    name = name,
    eligible = eligible,
    class = c("lookup_tbl", class(data))
  )
}

#' Print method for lookup_tbl
#'
#' @param x the lookup_tbl
#' @param ... further arguments passed to or from other methods.
#' @import cli
#' @import dplyr
#' @export
#' @author JR Ferrer-Paris
print.lookup_tbl <- function(x, ...) {
  id <- attr(x, "id")
  name <- attr(x, "name")
  eligible <- attr(x, "eligible")

  msg <- "<lookup_tbl>\nid column: %s\nname column: %s\neligible units: %s of %s\n\n"
  cat(sprintf(
    msg,
    cli::col_cyan(id),
    cli::col_magenta(name),
    sum(x[[eligible]]),
    nrow(x)
  ))

  NextMethod("print", x)
  invisible(x)
}
