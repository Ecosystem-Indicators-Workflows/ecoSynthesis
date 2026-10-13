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
#' @source TBC describe source here #TODO
#' @keywords datasets
"TASVEG_mini"

#' A subset of expert cross-reference table in paired-columns format for development and testing
#'
#' @format A tibble with 13 columns:
#' \describe{
#'  \item{VEG_GROUP}{Vegetation group of the `source` unit in the TASVEG 5.0 dataset}
#'  \item{VEGCODE}{Original vegetation code of the `source` unit in the TASVEG 5.0 dataset}
#'  \item{VEGCODE_D}{Description of the `source` unit}
#'  \item{Notes}{Notes on the `source` unit}
#'  \item{workflow}{Workflow information for the `source` unit}
#'  \item{GET1}{First expert assessment of the `source` unit}
#'  \item{GET1_p}{Membership value for the first expert assessment of the `source` unit}
#'  \item{GET2}{Second expert assessment of the `source` unit}
#'  \item{GET2_p}{Membership value for the second expert assessment of the `source` unit}
#'  \item{GET3}{Third expert assessment of the `source` unit}
#'  \item{GET3_p}{Membership value for the third expert assessment of the `source` unit}
#'  \item{GET4}{Fourth expert assessment of the `source` unit}
#'  \item{GET4_p}{Membership value for the fourth expert assessment of the `source` unit}
#' }
#'
#' @source TBC describe source here #TODO
#' @keywords datasets
"TASVEG_mini_expert_paired"
