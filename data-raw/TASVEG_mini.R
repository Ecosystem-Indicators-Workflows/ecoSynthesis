# Creates a mini version of the TASVEG dataset for development and testing purposes.
# TODO we can consider including the full dataset in the package for showing examples of data preparation.
# See `?TASVEG_mini` for documentation

TASVEG_mini <- tibble::tribble(
  ~VEGCODE , ~efg     , ~memb             , ~expert ,
  "AAP"    , "TF1.7"  , 1                 , "AK"    ,
  "AAP"    , "TF1.7"  , 1                 , "AL"    ,
  "AAP"    , "TF1.7"  , 1                 , "JB"    ,
  "AAP"    , "TF1.7"  , 0.7               , "MGT"   ,
  "AAP"    , "TF1.6"  , 0.3               , "MGT"   ,
  "AWU"    , "MFT1.3" , 0.25              , "AK"    ,
  "AWU"    , "TF1.3"  , 0.75              , "AK"    ,
  "AWU"    , "MFT1.3" , 0.3               , "AL"    ,
  "AWU"    , "TF1.3"  , 0.7               , "AL"    ,
  "AWU"    , "TF1.3"  , 0.45              , "JB"    ,
  "AWU"    , "TF1.4"  , 0.3               , "JB"    ,
  "AWU"    , "F2.3"   , 0.2               , "JB"    ,
  "AWU"    , "F2.2"   , 0.05              , "JB"    ,
  "AWU"    , "F2.3"   , 1                 , "MGT"   ,
  "OAQ"    , "F1.1"   , 0.1               , "AK"    ,
  "OAQ"    , "F1.2"   , 0.1               , "AK"    ,
  "OAQ"    , "F1.4"   , 0.1               , "AK"    ,
  "OAQ"    , "F1.5"   , 0.1               , "AK"    ,
  "OAQ"    , "F2.1"   , 0.2               , "AK"    ,
  "OAQ"    , "F2.2"   , 0.1               , "AK"    ,
  "OAQ"    , "F2.3"   , 0.1               , "AK"    ,
  "OAQ"    , "F3.1"   , 0.1               , "AK"    ,
  "OAQ"    , "F3.2"   , 0.1               , "AK"    ,
  "OAQ"    , "F1.1"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F1.2"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F1.4"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F1.5"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F2.1"   , 0.2               , "AL"    ,
  "OAQ"    , "F2.2"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F2.3"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F3.1"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F3.2"   , 0.111111111111111 , "AL"    ,
  "OAQ"    , "F3.1"   , 0.4               , "JB"    ,
  "OAQ"    , "F2.2"   , 0.3               , "JB"    ,
  "OAQ"    , "F1.2"   , 0.2               , "JB"    ,
  "OAQ"    , "F1.1"   , 0.1               , "JB"    ,
  "OAQ"    , "F2.2"   , 0.4               , "MGT"   ,
  "OAQ"    , "F2.1"   , 0.2               , "MGT"   ,
  "OAQ"    , "F3.1"   , 0.2               , "MGT"
)

usethis::use_data(TASVEG_mini, overwrite = TRUE)
