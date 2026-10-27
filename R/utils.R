#' Negative Value Matching
#'
#' See \code{base::[](`%in%`)} for details. `%nin%` is a binary operator,
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
#' @author [catastrophic-failure](https://stackoverflow.com/users/2874779/catastrophic-failure), Elliot Gould.
#' @source Function retrieved 2026-10-27 from <https://stackoverflow.com/a/38352065>. Posted by catastrophic-failure, modified by community. See post 'Timeline' for change history. License - CC BY-SA 4.0. Function documentation written by Elliot Gould.
#' @examples
#' "A" %nin% LETTERS[1:10]
#' TASVEG_LUT$eligible <- TASVEG_LUT$VEGCODE %nin% c("OAQ", "ORO", "OSM")
#' @family Utility functions
`%nin%` <- Negate(`%in%`)
