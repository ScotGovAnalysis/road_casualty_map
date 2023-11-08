#########################################################################
# Name of file - 00_setup_environment.R
# Data release - Road Casualty Map
# Original Authors - Ivet Gazova
# Original Date - October 2023
#
# Written/run on - RStudio Server
# Version of R - 4.2.2
#
# Description - Sets up environment required for running publication RAP. 
# This is the only file which should require updating every time 
# the process is run.
#
# Approximate run time - xx minutes
#########################################################################


### 1 - Load packages ----

library(here)
library(tidyverse)
library(haven)
library(sf)
library(leaflet)
library(rgdal)  
library(geojsonio)
library(jsonlite)

### 3 - Define dates ----

#### UPDATE THIS SECTION ####

mapyear <- 2022

### END OF SCRIPT ###