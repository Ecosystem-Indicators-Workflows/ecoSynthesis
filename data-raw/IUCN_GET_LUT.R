## Prepare `IUCN_GET_LUT`
## based on the IUCN Global Ecosystem Typology vocabulary

## Original data description:
## The Global Ecosystem Typology vocabulary is a beta release of the classification structure underpinning the IUCN Global Ecosystem Typology (GET), the first internationally agreed framework for describing and mapping the world's ecosystems. It has been published in Research Vocabularies Australia (RVA) as part of the Ecosystem Indicator Workflows project, giving Australian and international researchers a citable, machine-readable version of the typology's hierarchy for use in data description, discovery and interoperability.

## https://w3id.org/iucn-get/IUCNEcosystemTypology
## Data is available from Research Vocabularies Australia, 
## SPARQL endpoint: https://demo.vocabs.ardc.edu.au/repository/api/sparql/ands-nc_iucn-get-example_2026-04-01-v3

## Summary of steps from data source to prepared data:
## 1. Parse vocabulary file in rdf or ttl format
## 2. Query rdf to extract information of interest
## 3. Data preparation
## 4. Add data to the package repository

## Let's do this:

## 0. Load libraries

library(rdflib)
library(dplyr)
library(readr)

## 1. Parse vocabulary file in rdf or ttl format

online_file <- "https://demo.vocabs.ardc.edu.au/registry/api/resource/downloads/7901/IUCN-GET-profiles-exported-2026-04-01_skos-2.ttl"
IUCNGET <- rdf_parse(online_file)

## Test this is working with a very simple query:
query <- "
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT ?scheme ?title WHERE {
  ?scheme a skos:ConceptScheme ;
          skos:prefLabel ?title .
}
"
rdf_query(IUCNGET,query)

## If title is "IUCN Global Ecosystem Typology" we have the right vocabulary

## 2. Query rdf to extract information of interest

query = "
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX iucn: <https://w3id.org/iucn-get/ontology#>

SELECT ?efg ?efg_id ?efg_name 
       ?biome_id ?biome_name 
       ?realm_id ?realm_name 
WHERE {
  # 1. Get the EFGs
  ?efg a iucn:EcosystemFunctionalGroup ;
             skos:prefLabel ?efg_name ;
             skos:notation ?efg_id ;
             skos:broader ?biome .
  
  # 2. Get the biomes
  ?biome skos:prefLabel ?biome_name ;
         skos:notation ?biome_id ;
         skos:broader ?realm .
  
  # 3. Get the realms
  ?realm skos:prefLabel ?realm_name ;
         skos:notation ?realm_id .
  
  # Language filters
  FILTER(LANG(?efg_name) = 'en' && LANG(?biome_name) = 'en' && LANG(?realm_name) = 'en')
}
"

IUCNGET_profile <- rdf_query(IUCNGET,query)

## 3. Data preparation

IUCN_GET_LUT <- IUCNGET_profile |> 
  mutate(version="RVA demo v3", version_date="2026-04-01") |>
  arrange(efg_id) 

## 4. Add data to the package repository

usethis::use_data(IUCN_GET_LUT, overwrite = TRUE)
