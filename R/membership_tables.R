#' Reshape membership table from wide to long format
#' 
#' @param xref Input cross-referencing table (wide format)
#' @param original_names Names or codes of the original ecosystem concepts
#' @param target_names Names or codes of the target ecosystem concepts
#' @param membership_values Membership values (between 0 and 1) 
#' @param target Filter input to focus on specific targets
#' 
#' @return A membership table in long format
#' @export
#' 
membership_table <- function(xref, original_names, target_names, membership_values, target=NULL) {
    if (!is.null(target)) {
       xref <-  dplyr::filter(xref, 
        dplyr::if_any(dplyr::any_of(target_names), ~ .x %in% target))
    }
    
    xref |>
        dplyr::select(
            dplyr::any_of(original_names),
            dplyr::any_of(target_names),
            dplyr::any_of(membership_values)
        ) |> 
    tidyr::pivot_longer(
        dplyr::any_of(c(target_names,membership_values)),
        cols_vary = "slowest",
        names_to = c(".value"),
        names_pattern = "([[:alpha:]]+)")
}