#' A subset of the TASVEG dataset for development and testing
#'
#' This is a small subset of the TASVEG 5.0 dataset, used for development and testing purposes (we may choose to use this as an example dataset available for documentation to users).
#'
#' @format A tibble with 4 columns:
#' \describe{
#'   \item{source}{The source unit being classified. Original vegetation code of the `source` unit in the TASVEG 5.0 dataset}
#'   \item{target}{Code for the target classification. theEcosystem Functional Group from the IUCN GET framework}
#'   \item{membership}{Membership value between 0 and 1, indicating the degree of membership of the vegetation unit to the `target` EFG}
#'   \item{interpreter}{Character vector of names/identifiers of the interpreterswho provided the membership value}
#' }
#'
#' @source TBC describe source here #TODO
#' @keywords datasets
"TASVEG_mini"

#' A subset of interpreter cross-reference table in wide format for development and testing
#'
#' @format A tibble with 13 columns:
#' \describe{
#'  \item{VEG_GROUP}{Vegetation group of the `source` unit in the TASVEG 5.0 dataset}
#'  \item{VEGCODE}{Original vegetation code of the `source` unit in the TASVEG 5.0 dataset}
#'  \item{VEGCODE_D}{Description of the `source` unit}
#'  \item{Notes}{Notes on the `source` unit}
#'  \item{workflow}{Workflow information for the `source` unit}
#'  \item{GET1}{Interpreter's first target classification of the `source` unit}
#'  \item{GET1_p}{Membership value for the first interpreter classification of the `source` unit}
#'  \item{GET2}{Interpreter's second target classification of the `source` unit}
#'  \item{GET2_p}{Membership value for the second interpreter classification of the `source` unit}
#'  \item{GET3}{Interpreter's third target classification of the `source` unit}
#'  \item{GET3_p}{Membership value for the third interpreter classification of the `source` unit}
#'  \item{GET4}{Interpreter's fourth target classification of the `source` unit}
#'  \item{GET4_p}{Membership value for the fourth interpreter classification of the `source` unit}
#' }
#'
#' @source TBC describe source here #TODO
#' @keywords datasets
"TASVEG_mini_expert_wide"
