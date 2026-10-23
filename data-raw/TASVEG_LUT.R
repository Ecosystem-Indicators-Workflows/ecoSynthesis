## Prepare `TASVEG_LUT`
## based on TASVEG 5.0 from www.theLIST.tas.gov.au ©State of Tasmania

## Original data description:
## > TASVEG is a comprehensive digital map of Tasmania’s vegetation, including sub-Antarctic Macquarie Island. The map depicts the extent of more than 150 vegetation communities, including coastal heathlands, eucalypt forest and alpine communities.
## > The current release version for mainland Tasmania is TASVEG 5.0 and was published in November 2025. The current release version for Macquarie Island is TASVEG 3.0 Macquarie Island and was published in November 2013.
## > Data is supplied under Creative Commons Attribution 3.0 Australia (CC BY 3.0 AU) Licence http://creativecommons.org/licenses/by/3.0/au/

## Summary of steps from data source to prepared data:
## 1. Obtaining the original data from www.theLIST.tas.gov.au
## 2. Extract target file from downloaded zip archive
## 3. Read dbf file as a data frame
## 4. Data preparation
## 5. Add data to the package repository

## Time for action:

## 0. Load required libraries

library(foreign)
library(dplyr)

# This script requires 'wget' to be installed for downloading files.
# Please install 'wget' using your package manager:
# For macOS users: brew install wget
# For Ubuntu users: sudo apt-get install wget
# For Windows users: Please refer to the wget documentation for installation instructions at:
# https://eternallybored.org/misc/wget/

## 1. Obtaining the original data from www.theLIST.tas.gov.au

## This is the source URL at theLIST repository
data_url <- 'https://listdata.thelist.tas.gov.au/opendata/data/LIST_TASVEG_50_STATEWIDE.zip'

## Download to a tempfile
temp_zip <- tempfile(fileext = ".zip")

## very large file (1.7GB) will require sometime to download
options(timeout = max(300, getOption("timeout")))

## Download with wget seems to be more stable
download.file(
  data_url,
  destfile = temp_zip,
  mode = "wb",
  method = "wget",
  extra = c("-c")
)

## 2. Extract target file from downloaded zip archive

## Choose the target file from the contents of the zip archive
## this is equivalent to `unzip -l` in the commandline
unzip(temp_zip, list = TRUE)

## Use a tempdir
temp_dir <- tempdir()

## Unzip the selected file
unzip(
  temp_zip,
  files = "LIST_TASVEG_50_STATEWIDE/TASVEG_5_0.dbf",
  exdir = temp_dir
)

## 3. Read dbf file as a data frame

TASVEG_DBF <- read.dbf(
  sprintf(
    "%s/LIST_TASVEG_50_STATEWIDE/TASVEG_5_0.dbf",
    temp_dir
  )
)

## 4. Data preparation

## select target columns, arrange, and drop duplicates
TASVEG_LUT <-
  TASVEG_DBF |>
  select(VEG_GROUP, VEGCODE, VEGCODE_D, VEG_GROUP) |>
  arrange(VEG_GROUP, VEGCODE) |>
  unique() |>
  as_tibble()

## 5. Add data to the package

usethis::use_data(TASVEG_LUT, overwrite = TRUE)
