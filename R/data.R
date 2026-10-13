#' A subset of the TASVEG dataset for development and testing
#'
#' @format A tibble with 4 columns:
#' \describe{
#'   \item{VEGCODE}{Original vegetation code of the `source` unit in the TASVEG 5.0 dataset}
#'   \item{efg}{Code for the `target` Ecosystem Functional Group}
#'   \item{memb}{Membership value between 0 and 1, indicating the degree of membership of the vegetation unit to the `target` EFG}
#'   \item{expert}{Expert who provided the membership value}
#' }
#'
#' @source TBC describe source here #todo
#' @keywords datasets
"TASVEG_mini"
