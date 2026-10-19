#' Create a membership table
#'
#' @param data A data frame
#' @param source_id Column containing source ecosystem concepts
#' @param target_id Column containing target ecosystem concepts
#' @param membership Column containing membership values
#' @param interpreter Column containing interpreter information
#' @param updated Column containing the date of the interpretation
#'
#' @return An object of class 'membership_tbl'
#' @export
membership_tbl <- function(
  data,
  source_id = "source_id",
  target_id = "target_id",
  membership = "membership",
  interpreter = "interpreter",
  updated = NULL
) {
  stopifnot(is.data.frame(data))

  required <- c(source_id, target_id, membership, interpreter)

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
    source_id = source_id,
    target_id = target_id,
    membership = membership,
    interpreter = interpreter,
    updated = updated,
    class = c("membership_tbl", class(data))
  )
}

#' Performs checks on a membership table
#'
#' @param x A membership_tbl
#'
#' @return List with checks results
#' @export
check_membership <- function(x) {
  stopifnot(inherits(x, "membership_tbl"))

  source_id <- attr(x, "source_id")
  target_id <- attr(x, "target_id")
  membership <- attr(x, "membership")
  interpreter <- attr(x, "interpreter")

  m <- x[[membership]]
  i <- x[[interpreter]]
  checks_results <- c(
    numeric_memb = !is.numeric(m),
    na_memb = anyNA(m),
    bounded_memb = any(m < 0 | m > 1)
  )

  errors_list <- c(
    "Membership column is not numeric.",
    "Membership column contains missing values.",
    "Membership values outside bounds [0,1]"
  )
  res <- list(
    valid = !any(checks_results),
    checks = checks_results,
    errors = errors_list[checks_results]
  )
  class(res) <- c("membership_check", "list")
  res
}


#' Print method for membership_check
#'
#' @param x the membership_check
#' @param ... further arguments passed to or from other methods.
#' @import cli
#' @export
print.membership_check <- function(x, ...) {
  if (x$checks["numeric_memb"]) {
    cat(cli::col_red("\u2717 Membership column is not numeric\n"))
  } else {
    cat(cli::col_blue("\u2713 Membership column is numeric\n"))
  }
  if (x$checks["bounded_memb"]) {
    cat(cli::col_red("\u2717 Membership values <0 or >1\n"))
  } else {
    cat(cli::col_blue("\u2713 Membership values are within [0,1]\n"))
  }
  if (x$valid) {
    cat("All checks passed, Membership table is valid.")
  } else {
    cat(
      "Please fix errors and check data before using other package functions.\n"
    )
  }
}


#' Validate a membership table
#'
#' @param x A membership_tbl
#'
#' @return Invisibly returns x
#' @export
validate_membership <- function(x) {
  stopifnot(inherits(x, "membership_tbl"))
  res <- check_membership(x)

  if (!res$valid) {
    cat(sprintf("Errors: %s\n", paste(res$errors, collapse = "\n")))
    stop(
      "Please fix errors and check data before using other package functions.\n"
    )
  }
}

#' Print method for membership_tbl
#'
#' @param x the membership_tbl
#' @param ... further arguments passed to or from other methods.
#' @import cli
#' @import dplyr
#' @export
print.membership_tbl <- function(x, ...) {
  source_id <- attr(x, "source_id")
  target_id <- attr(x, "target_id")
  membership <- attr(x, "membership")
  interpreter <- attr(x, "interpreter")

  msg <- "<membership_tbl>\nsource_id column: %s\ntarget_id column: %s\nmembership column: %s\ninterpreter column: %s\n\n"
  cat(sprintf(
    msg,
    cli::col_cyan(source_id),
    cli::col_magenta(target_id),
    membership,
    cli::col_grey(interpreter)
  ))

  NextMethod("print", x)
  invisible(x)
}

#' Coerce a data frame to membership_tbl
#'
#' @param x A data frame
#' @param source_id Source concept column
#' @param target_id Target concept column
#' @param membership Membership column
#' @param interpreter Interpreter column
#'
#' @return A validated membership_tbl
#' @import tibble
#' @export
#' @examples
#' xref <- tibble::tibble(
#'   source = c("A", "A", "B"),
#'   target = c("EFG1", "EFG2", "EFG3"),
#'   membership = c(0.8, 0.2, 1),
#'   interpreter = c("Worrisome Wren","Worrisome Wren","Worrisome Wren")
#' )
#' x <- as_membership_tbl(
#'   xref,
#'   source_id = "source",
#'   target_id = "target",
#'   membership = "membership",
#'   interpreter = "interpreter"
#' )
#' x
as_membership_tbl <- function(
  x,
  source_id,
  target_id,
  membership,
  interpreter
) {
  out <- membership_tbl(
    data = x,
    source_id = source_id,
    target_id = target_id,
    membership = membership,
    interpreter = interpreter
  )

  validate_membership(out)

  out
}

#' Reshape membership table from paired columns to long format
#'
#' @param data Input cross-referencing table (paired column format)
#' @param original_names Names or codes of the original ecosystem concepts
#' @param target_names Names or codes of the target ecosystem concepts
#' @param membership_values Membership values (between 0 and 1) 
#' @param target Filter input to focus on specific targets
#' 
#' @return A membership table in long format
#' @import dplyr
#' @import tidyr
#' @export
#' @examples 
#' input_table <- data.frame(
#'  re1 = c(
#'    "Semi-deciduous Forest",
#'    "Deciduous Forest",
#'    "Wet Montane Forest",
#'    "Dry Montane Forest"
#'  ),
#'  efg_1 = c("T1.1", "T1.2", "T1.1", "T1.2"),
#'  memb_1 = c(0.80, 0.80, 0.70, 0.50),
#'  efg_2 = c("T1.2", "T1.1", "T1.3", "T1.3"),
#'  memb_2 = c(0.20, 0.20, 0.30, 0.50)
#')
#'
#'import_paired_membership(
#'  input_table,
#'  "re1",
#'  c("efg_1", "efg_2"),
#'  c("memb_1", "memb_2")
#')
import_paired_membership <- function(
  data,
  original_names,
  target_names,
  membership_values
  ) {    
    out <- data |>
        dplyr::select(
            dplyr::any_of(original_names),
            dplyr::any_of(target_names),
            dplyr::any_of(membership_values)
        ) |> 
    tidyr::pivot_longer(
      cols = c(target_names, membership_values),
      names_to = c(".value", "pair"),
      names_sep = "_"
    )
    out
    cols <- colnames(out)
    out$interpreter <- "Worrisome Wren"
    as_membership_tbl(out, cols[1], cols[3], cols[4], "interpreter")
}