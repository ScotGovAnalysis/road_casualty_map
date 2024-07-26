### export SAS datasets into csv for latest updated versions

library(haven)
library(here)

snapacctem <- read_sas("//s0177a/sasdata1/trans/rsruser/snapacctem.sas7bdat")
snapcastem <- read_sas("//s0177a/sasdata1/trans/rsruser/snapcastem.sas7bdat")

#export files to csv, use relative path

readr::write_csv(snapacctem, here("data", "snapacctem.csv"))
readr::write_csv(snapcastem, here("data", "snapcastem.csv"))