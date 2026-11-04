#' Summarise a membership matrix
#'
#' @param data A `membership_tbl` object containing membership data in long format, with columns for source, target, membership, interpreter, and round values.
#' @param which_round A numeric value matching the selected round in `data`. Defaults to NULL, which matches the highest round available in `data`.
#'
#' @returns A `membership_summary` object.
#'
#' @details
#' Returns the `membership summary` which is a `membership_tbl` with aggregated membership values and extra information.
#'
#'
#' ## Future Enhancements
#' The function is designed to be flexible and can be extended in the future. Users may filter by round of elicitation.
#'
#'
#' @export
#' @author JR Ferrer-Paris
#' @family synthesis
#' @examples
#' # Example usage with the TASVEG_xref dataset
#' data("TASVEG_xref")
#' TASVEG_memb <- membership_tbl(
#'   TASVEG_xref,
#'   source_id = "VEGCODE",
#'   target_id = "efg",
#'   membership = "memb",
#'   interpreter = "interp",
#'   round = "round"
#' )
#' res <- summarise_membership(TASVEG_memb)
#' subset(res,total_memb > total_interp)
#' subset(res,total_memb < total_interp * 0.99)
summarise_membership <- function(data, which_round = NULL) {
  the_call <- match.call()
  checkmate::assert_class(data, "membership_tbl")
  sid <- attr(data, "source_id")
  tid <- attr(data, "target_id")
  mval <- attr(data, "membership")
  inam <- attr(data, "interpreter")
  rval <- attr(data, "round")

  checkmate::assert_numeric(
    data[[mval]],
    .var.name = mval
  )
  checkmate::assert_numeric(
    data[[rval]],
    .var.name = rval
  )
  checkmate::assert_character(
    data[[sid]],
    .var.name = sid
  )
  checkmate::assert_character(
    data[[tid]],
    .var.name = tid
  )
  checkmate::assert_character(
    data[[inam]],
    .var.name = inam
  )

  if (is.null(which_round)) {
    which_round <- max(data[[rval]])
    cli::cli_inform(
      "No round selected, defaults to round {.val {which_round}}."
    )
  } else {
    checkmate::assertTRUE(which_round %in% data[[rval]])
    cli::cli_inform("Round nr. {.val {which_round}} selected.")
  }
  out <-
    data |>
    dplyr::filter(.data[[rval]] == which_round) |>
    dplyr::mutate(
      total_memb = sum(.data[[mval]]),
      total_interp = dplyr::n_distinct(.data[[inam]]),
      .by = all_of(sid)
    ) |>
    dplyr::summarise(
      prop_memb = sum(.data[[mval]] / .data[["total_memb"]]),
      total_memb = unique(.data[["total_memb"]]),
      supporting = dplyr::n_distinct(.data[[inam]]),
      total_interp = unique(.data[["total_interp"]]),
      .by = all_of(c(sid, tid, rval))
    )

  out <-
    out |>
    dplyr::slice_max(
      .data[["prop_memb"]],
      by = all_of(sid),
      with_ties = FALSE,
      n = 1
    )

  structure(
    out,
    call = the_call,
    source_id = sid,
    target_id = tid,
    class = c("membership_summary", class(data))
  )
}


#' Print method for membership_summary
#'
#' @param x the membership_summary
#' @param ... further arguments passed to or from other methods.
#' @import cli
#' @export
#' @author JR Ferrer-Paris
print.membership_summary <- function(x, ...) {
  source_id <- attr(x, "source_id")
  target_id <- attr(x, "target_id")
  the_call <- attr(x, "call")

  cli::cli_rule("{.cls membership_summary}")
  cli::cli_alert_info("source_id column: {.var {source_id}}")
  cli::cli_alert_info("target_id column: {.var {target_id}}")

  cli_end()

  print(the_call)
  NextMethod("print", x, ...)
  invisible(x)
}
