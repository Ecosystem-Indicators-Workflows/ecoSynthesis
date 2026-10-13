#' Standardise column names for expert cross-reference data in paired-columns format.
#'
#' @description Standardises a cross-reference data frame in paired-columns format.
#' @param xref A data frame containing the cross-reference data in paired-columns format.
#' @param prefix The prefix used to identify target columns.
#' @param suffix The suffix used to identify membership columns.
#' @param separator The separator used between the prefix and suffix.
#'
#' @returns A data frame with standardised column names for the expert cross-reference data.
#'
#' @details
#' Note that the renaming convention is currently hard-coded into this function rather than being expose as arguments. The function will prefix target columns with `"efg_"` and mebership columns with `"memb_"`. This is to ensure that the output is consistent with the expected format for further processing.
#'
#' Non-target, non-membership columns will be retained in the output data frame with their original names.
#'
#' @export
#' @examples
#' # Example usage of the \code{standardise_xref_pairs} function
#' standardise_xref_pairs(
#'   TASVEG_mini_expert_paired,
#'   prefix = "GET",
#'   suffix = "p",
#'   separator = "_",
#' )
standardise_xref_pairs <- function(
  xref,
  prefix,
  suffix = "p",
  separator = "_"
) {
  target_pat <- glue::glue("^{prefix}(\\d+)$")
  memb_pat <- glue::glue("^{prefix}(\\d+){separator}{suffix}$")

  target_cols <- names(xref) |>
    stringr::str_subset(target_pat)

  memb_cols <- names(xref) |>
    stringr::str_subset(memb_pat)

  # Check that the target columns and membership columns match
  # Ensure that the target columns and membership columns are in the same order
  memb_base <- stringr::str_remove(
    memb_cols,
    glue::glue("{separator}{suffix}$")
  )
  memb_cols <- memb_cols[match(target_cols, memb_base)]

  if (anyNA(memb_cols)) {
    cli::cli_abort(
      "Some target columns do not have matching membership columns."
    )
  }

  target_names <- paste0("efg_", seq_along(target_cols))
  memb_names <- paste0("memb_", seq_along(memb_cols))

  xref |>
    dplyr::rename_with(~target_names, dplyr::all_of(target_cols)) |>
    dplyr::rename_with(~memb_names, dplyr::all_of(memb_cols))
}
