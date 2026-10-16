#' Create a membership table
#'
#' @param data A data frame
#' @param source Column containing source ecosystem concepts
#' @param target Column containing target ecosystem concepts
#' @param membership Column containing membership values
#' @param interpreter Column containing interpreter information
#' @param updated Column containing the date of the interpretation
#'
#' @return An object of class 'membership_tbl'
#' @export
membership_tbl <- function(data,
                           source = "source_id",
                           target = "target_id",
                           membership = "membership",
                           interpreter = "interpreter",
                           updated = NULL) {

  stopifnot(is.data.frame(data))

  required <- c(source, target, membership, interpreter)

  missing <- setdiff(required, names(data))

  if (length(missing) > 0) {
    stop(
      "Missing required columns: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }

  data <- tibble::as_tibble(data)

  structure(
    data,
    source = source,
    target = target,
    membership = membership,
    interpreter = interpreter,
    updated = updated,
    class = c("membership_tbl", class(data))
  )
}

#' Validate a membership table
#'
#' @param x A membership_tbl
#'
#' @return Invisibly returns x
#' @export
validate_membership <- function(x) {

  stopifnot(inherits(x, "membership_tbl"))

  source <- attr(x, "source")
  target <- attr(x, "target")
  membership <- attr(x, "membership")

  m <- x[[membership]]

  if (!is.numeric(m)) {
    stop("Membership column must be numeric.", call. = FALSE)
  }

  if (anyNA(m)) {
    stop("Membership column contains missing values.", call. = FALSE)
  }

  if (any(m < 0 | m > 1)) {
    stop(
      "Membership values must be between 0 and 1.",
      call. = FALSE
    )
  }

  invisible(x)
}

#' @export
print.membership_tbl <- function(x, ...) {

  source <- attr(x, "source")
  target <- attr(x, "target")
  membership <- attr(x, "membership")

  cat("<membership_tbl>\n")
  cat(" Source column: ", source, "\n", sep = "")
  cat(" Target column: ", target, "\n", sep = "")
  cat(" Membership column: ", membership, "\n\n", sep = "")

  NextMethod("print", x)
  invisible(x)
}

#' Coerce a data frame to membership_tbl
#'
#' @param x A data frame
#' @param source Source concept column
#' @param target Target concept column
#' @param membership Membership column
#'
#' @return A validated membership_tbl
#' @export
as_membership_tbl <- function(x,
                              source,
                              target,
                              membership,
                              interpreter) {

  out <- membership_tbl(
    data = x,
    source = source,
    target = target,
    membership = membership,
    interpreter = interpreter
  )

  validate_membership(out)

  out
}


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