## Prepare `TASVEG_mini_expert_paired` dataset

TASVEG_mini_expert_paired <-
  tibble::tribble(
    ~VEG_GROUP                   , ~VEGCODE , ~VEGCODE_D                         , ~Notes                                                                                                                                                                                                                                                                                                                                                                               , ~workflow , ~GET1   , ~GET1_p , ~GET2   , ~GET2_p , ~GET3  , ~GET3_p , ~GET4  , ~GET4_p ,
    "Other natural environments" , "OAQ"    , "(OAQ) Water, sea"                 , NA                                                                                                                                                                                                                                                                                                                                                                                   , NA        , "F2.2"  , 0.4     , "F2.1"  , 0.2     , "F3.1" , 0.2     , "F1.2" , 0.2     ,
    "Saltmarsh and wetland"      , "AAP"    , "(AAP) Alkaline pans"              , "Alkaline and ground-water fed:\"Recent evidence that these unique features are spring-fed groundwater-dependent ecosystems refutes the previous interpretation of Alkaline pansas ephemeral disturbance features due to burning of the peat with resultant exposure of underlying alkaline substrates.\" Highly diverse"                                                            , NA        , "TF1.7" , 0.7     , "TF1.6" , 0.3     , NA     , NA      , NA     , NA      ,
    "Saltmarsh and wetland"      , "AWU"    , "(AWU) Wetland (undifferentiated)" , "Since it I fresh it must be F2.3:\"AWU is a generic wetland code, which has been used to map four fresh water wetland communities: Freshwater aquatic herbland (AHF), Lacustrine herbland (AHL), Saline aquatic herbland (AHS) and Freshwater aquatic sedgeland and rushland (ASF) where the separation of these communities using remote-mapping methods has not been possible.\"" , NA        , "F2.3"  , 1       , NA      , NA      , NA     , NA      , NA     , NA
  )


usethis::use_data(TASVEG_mini_expert_paired, overwrite = TRUE)
