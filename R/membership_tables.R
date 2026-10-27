#' Create a membership table
#'
#' @param data A data frame
#' @param source_id Column containing source ecosystem concepts
#' @param target_id Column containing target ecosystem concepts
#' @param membership Column containing membership values
#' @param interpreter Column containing interpreter information
#' @param round Column containing the date of the interpretation
#'
#' @return An object of class 'membership_tbl'
#' @export
#' @author JR Ferrer-Paris
#' @examples
#' xref <- tibble::tibble(
#'   source = c("A", "A", "B"),
#'   target = c("EFG1", "EFG2", "EFG3"),
#'   membership = c(0.8, 0.2, 1),
#'   interpreter = c("Worrisome Wren","Worrisome Wren","Worrisome Wren")
#' )
#' x <- membership_tbl(
#'   xref,
#'   source_id = "source",
#'   target_id = "target",
#'   membership = "membership",
#'   interpreter = "interpreter"
#' )
#' x
membership_tbl <- function(
  data,
  source_id = "source_id",
  target_id = "target_id",
  membership = "membership",
  interpreter = "interpreter",
  round = NULL
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
    round = round,
    class = c("membership_tbl", class(data))
  )
}

#' Performs checks on a membership table
#'
#' @param x A membership_tbl
#' @param source Lookup table for the source classification
#' @param target Lookup table for the target classification
#'
#' @return List with checks results
#' @import dplyr
#' @export
#' @author JR Ferrer-Paris
check_membership <- function(x, source = NULL, target = NULL) {
  stopifnot(inherits(x, "membership_tbl"))

  membership <- attr(x, "membership")

  m <- x[[membership]]
  eligibility <- is.null(source)
  if (!is.null(source)) {
    stopifnot(inherits(source, "lookup_tbl"))
    source_id <- attr(x, "source_id")
    sid <- x[[source_id]]
    vid <- rlang::sym(attr(source, "id"))
    elig <- rlang::sym(attr(source, "eligible"))
    eid <- dplyr::filter(source, !!elig) |> dplyr::pull(!!vid)
    eligibility <- all(sid %in% eid)
  }
  validity <- is.null(target)
  if (!is.null(target)) {
    stopifnot(inherits(target, "lookup_tbl"))
    target_id <- attr(x, "target_id")
    tid <- x[[target_id]]
    vid <- attr(target, "id")
    elig <- attr(target, "eligible")
    eid <- target[[vid]][target[[elig]]]
    validity <- all(tid %in% eid)
  }
  checks_results <- c(
    numeric_memb = !is.numeric(m),
    na_memb = anyNA(m),
    bounded_memb = any(m[!is.na(m)] < 0 | m[!is.na(m)] > 1),
    source_missing = is.null(source),
    source_eligibility = !eligibility,
    target_missing = is.null(target),
    target_valid = !validity
  )

  errors_list <- c(
    "Membership column is not numeric.",
    "Membership column contains missing values.",
    "Membership values outside bounds [0,1]",
    "No lookup table for source classification provided",
    dplyr::if_else(
      is.null(source),
      "Source ids have not been checked",
      "Some source ids are not eligible"
    ),
    "No lookup table for target classification provided",
    dplyr::if_else(
      is.null(target),
      "Target ids have not been checked",
      "Some target ids are not valid"
    )
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
#' @author JR Ferrer-Paris
print.membership_check <- function(x, ...) {
  if (x$checks["numeric_memb"]) {
    cat(cli::col_red("\u2717 Membership column is not numeric\n"))
  } else {
    cat(cli::col_blue("\u2713 Membership column is numeric\n"))
  }
  if (x$checks["na_memb"]) {
    cat(cli::col_red("\u2717 Membership values contains NA values\n"))
  } else {
    cat(cli::col_blue("\u2713 All records have a membership value\n"))
  }
  if (x$checks["bounded_memb"]) {
    cat(cli::col_red("\u2717 Membership values <0 or >1\n"))
  } else {
    cat(cli::col_blue("\u2713 Membership values are within [0,1]\n"))
  }
  if (x$checks["source_missing"]) {
    cat(cli::col_red(
      "\u2717 No lookup table for source classification provided\n"
    ))
  } else {
    cat(cli::col_blue(
      "\u2713 Lookup table for source classification provided\n"
    ))
  }
  if (x$checks["source_eligibility"]) {
    cat(cli::col_red("\u2717 Problems with eligibility of source ids\n"))
  } else {
    cat(cli::col_blue("\u2713 All source ids are eligible\n"))
  }
  if (x$checks["target_missing"]) {
    cat(cli::col_red(
      "\u2717 No lookup table for target classification provided\n"
    ))
  } else {
    cat(cli::col_blue(
      "\u2713 Lookup table for target classification provided\n"
    ))
  }
  if (x$checks["target_valid"]) {
    cat(cli::col_red("\u2717 Problems with validity of target ids\n"))
  } else {
    cat(cli::col_blue("\u2713 All target ids are valid\n"))
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
#' @author JR Ferrer-Paris
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
#' @author JR Ferrer-Paris
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
#' @param round Round column
#'
#' @return A validated membership_tbl
#' @import tibble
#' @export
#' @author JR Ferrer-Paris
as_membership_tbl <- function(
  x,
  source_id,
  target_id,
  membership,
  interpreter,
  round = NULL
) {
  out <- membership_tbl(
    data = x,
    source_id = source_id,
    target_id = target_id,
    membership = membership,
    interpreter = interpreter,
    round = round
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
#' @param interpreter Name of the interpreter
#'
#' @return A membership table in long format
#' @import dplyr
#' @import tidyr
#' @export
#' @author JR Ferrer-Paris
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
  membership_values,
  interpreter = NULL
) {
  out <- data |>
    dplyr::select(
      dplyr::any_of(original_names),
      dplyr::any_of(target_names),
      dplyr::any_of(membership_values)
    ) |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(c(target_names, membership_values)),
      names_to = c(".value", "pair"),
      names_sep = "_"
    )
  out
  cols <- colnames(out)
  if (is.null(interpreter)) {
    interpreter <- "Worrisome Wren"
  }
  out$interpreter <- interpreter
  membership_tbl(out, cols[1], cols[3], cols[4], "interpreter")
}
