# Purpose: Generate Summary Figures for Supply Chain Risk Tool Phase 2 Reports
# Author: Althea Marks
# Date Created: 2023-01-24


## Packages
library("groundhog")
# list additional packages in vector below
pkgs <- c(
  "readr",
  "tidyverse", 
  "magrittr") 
# Keep this date set to load in version controlled packages
groundhog.library(pkgs, "2023-01-01") 


## Set up directories 
if(dir.exists(file.path("./figures"))){
  fig_dir <- file.path("./figures")
} else{dir.create(file.path("./figures"))
  fig_dir <- file.path("./figures")
}

if(dir.exists(file.path("./data"))){
  data_dir <- file.path("./data")
} else{dir.create(file.path("./data"))
  data_dir <- file.path("./data")
}

## Read in compiled vessel data
comp_vessels <- read_csv(file.path(data_dir,"CompiledVesselsIndicators-2023-01-24.csv"))

## Set company variable (change based on which report is being generated)
company <- "NESI"

## Filter data by company
vessels <- comp_vessels %>% 
  filter(c == company)
