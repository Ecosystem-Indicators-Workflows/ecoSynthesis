#' A Look-up Table for the TASVEG 5.0 dataset
#'
#' This is a Look-up Table generated from the TASVEG 5.0 dataset containing basic description of vegetation units.  TASVEG is a comprehensive digital map of Tasmania’s vegetation, including sub-Antarctic Macquarie Island. This Look-up Table was extracted from TASVEG 5.0 from www.theLIST.tas.gov.au ©State of Tasmania. It includes 156 map classes including coastal heathlands, eucalypt forest, and other vegetation communities. The current release version for mainland Tasmania is TASVEG 5.0 and was published in November 2025. The current release version for Macquarie Island is TASVEG 3.0 Macquarie Island and was published in November 2013. The original data is supplied under Creative Commons Attribution 3.0 Australia (CC BY 3.0 AU) Licence. 
#'
#' @format A data frame with 3 columns:
#' \describe{
#'   \item{VEG_GROUP}{Character vector of Vegetation group, part of the classification hierarchy}
#'   \item{VEGCODE}{Character vector of code for the units in this classification}
#'   \item{VEGCODE_D}{Character vector of one-line descriptions for each unit}
#' }
#'
#' @source Department of Natural Resources and Environment Tasmania. TASVEG 5.0, Released November 2025. Tasmanian Vegetation Monitoring and Mapping Program, Environment Business Unit.​
#' @keywords datasets
"TASVEG_LUT"

#' TASVEG cross-reference dataset for development and testing
#'
#' This is a test crossreference of the TASVEG 5.0 classification to the IUCN Global Ecosystem Typology, used for development and testing purposes. This table holds membership values assigned by four interpreters (anonymised using codenames) in a first round of interpretation. Column names have not been standardised, source ids and target ids include some errors (to test checks and validation). 
#'
#' @format A tibble with 4 columns:
#' \describe{
#'   \item{VEGCODE}{Original vegetation code of the `source` unit in the TASVEG 5.0 dataset, the source id being classified.}
#'   \item{efg}{Shortcode for the Ecosystem Functional Group (EFG) from the IUCN Global Ecosystem Typology, the target id.}
#'   \item{memb}{Membership value between 0 and 1, indicating the degree of membership of the `source` vegetation or map unit to the `target` EFG.}
#'   \item{interp}{Character vector of codenames for interpreters who provided the membership value. Codenames used instead of the real names or initials.}
#'   \item{round}{Numeric value for the round of interpretations. Currently only includes round 1.}
#' }
#'
#' @source Mark Tozer (pers. comm.)
#' @keywords datasets
"TASVEG_xref"

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
