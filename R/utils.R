#' Negative Value Matching
#'
#' See \code{base::\%in\%} for details. `%nin%` is a binary operator,
#' returning a logical vector indicating if there is a negative match or not.
#'
#' @name %nin%
#' @rdname NotIn
#' @keywords internal
#' @export
#' @usage lhs \%nin\% rhs
#' @param lhs vector or NULL: the values to be matched. \code{\link[base]{Long vectors}} are supported.
#' @param rhs vector or NULL: the values to be matched. \code{\link[base]{Long vectors}}  are supported.
#' @return A logical vector indicating which value of `lhs` are *not* matched in `rhs`
#' @author [catastrophic-failure](https://stackoverflow.com/users/2874779/catastrophic-failure), Elliot Gould and JR Ferrer-Paris.
#' @source Function retrieved 2026-10-27 from <https://stackoverflow.com/a/38352065>. Posted by catastrophic-failure, modified by community, see also r-help post <https://stat.ethz.ch/pipermail/r-help/2011-May/277498.html>. See post 'Timeline' for change history. License - CC BY-SA 4.0. Function documentation written by Elliot Gould and JR Ferrer-Paris.
#' @examples
#' "A" %nin% LETTERS[1:10]
#' TASVEG_LUT$eligible <- TASVEG_LUT$VEGCODE %nin% c("OAQ", "ORO", "OSM")
#' @family Utility functions
`%nin%` <- function(lhs, rhs) match(lhs, rhs, nomatch = 0) == 0
