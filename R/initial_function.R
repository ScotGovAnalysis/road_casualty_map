## this R script reads in the data, cleans it, and prepares for charts

library(here)
library(tidyverse)
library(ggplot2)
library(plotly)
library(crosstalk)

# bringing in the sas datasets

snapacctem <- read.csv(here("data", "snapacctem.csv"))
snapcastem <- read.csv(here("data", "snapcastem.csv"))

## fatalities - Scotland whole

#creating a data frame of all scotland fatalities by filtering only fatalities and from year 2014. 
#Using summarise to count how many we have.

source(here("R", "chart_functions.R"))

fatalities <- snapcastem %>% 
  group_by(YEAR) %>%
  filter (CASSEV == 1 & YEAR > 2013) %>%
  summarise(casualties = n()) %>% 
  complete(YEAR = 2014:2030) %>% 
  mutate(newyear = YEAR - 2016) %>% #to calculate a correct slope 
  calculate_baseline() %>%
  mutate(slope = reduction_slope(baseline),
         rate_reduction = baseline + slope * newyear)


## seriously injured - Scotland whole 

seriously_injured <- snapcastem %>% 
  group_by(YEAR) %>%
  filter (YEAR > 2013) %>%
  summarise(casualties = sum(cas_adjusted_serious, na.rm=TRUE)) %>% #contains NA values
  complete(YEAR = 2014:2030) %>% 
  mutate(newyear = YEAR - 2016) %>%   #to calculate a correct slope 
  calculate_baseline() %>%
  mutate(slope = reduction_slope(baseline),
         rate_reduction = baseline + slope * newyear)




## child fatalities - Scotland whole

ch_fatalities <- snapcastem %>% 
  group_by(YEAR) %>%
  filter (CASSEV == 1 & YEAR > 2013 & CASAGE < 16) %>%
  summarise(casualties = n()) %>% 
  complete(YEAR = 2014:2030) %>% 
  mutate(newyear = YEAR - 2016) %>%  #to calculate a correct slope 
  calculate_baseline() %>%  
  mutate(slope = reduction_slope(baseline, percent_reduction = 60),
       rate_reduction = baseline + slope * newyear)


## children seriously injured - Scotland whole 

ch_seriously_injured <- snapcastem %>% 
  group_by(YEAR) %>%
  filter (YEAR > 2013 & CASAGE < 16) %>%
  summarise(casualties = sum(cas_adjusted_serious, na.rm=TRUE)) %>% #contains NA values
  complete(YEAR = 2014:2030) %>% 
  mutate(newyear = YEAR - 2016) %>%  #to calculate a correct slope 
  calculate_baseline() %>%  
  mutate(slope = reduction_slope(baseline, percent_reduction = 60),
         rate_reduction = baseline + slope * newyear) 




## council separate


#merge snapacctem and snapcas to get council variable

snapcasacc <- merge(snapcastem, snapacctem, by.x = "ACCREF", by.y = "ACCREF", all.x = TRUE)

#only show the variables that are needed and summarise all casualties per council from 2014 to 2021

## Fatalities

cas_councils <- snapcasacc %>% select(c(ACCREF, RUSER, CASSEV, YEAR.y, YEAR.x, CASAGE, Council)) 

cas_councils <- cas_councils %>% 
  group_by(YEAR.x, Council) %>% 
  filter (CASSEV == 1 & YEAR.x > 2013) %>%
  summarise(casualties = n()) %>%
  ungroup() %>% 
  complete(YEAR.x = 2014:2021, Council, fill = list(casualties = 0)) %>%
  complete(YEAR.x = 2014:2030, Council, fill = list(casualties = NA)) %>% 
  arrange(Council, YEAR.x) %>%
  mutate(newyear = YEAR.x - 2016) %>%
  group_by(Council) %>%
  calculate_baseline() %>%
  mutate(slope = reduction_slope(baseline),
         rate_reduction = baseline + slope * newyear)

#use council_format function to add a name for the council

source(here("R", "council_format.R"))

cas_councils <- council_format(dataset = cas_councils, council_number = 'Council')

## seriously injured

seriously_injured_councils <- snapcasacc %>% select(c(ACCREF, RUSER, CASSEV, YEAR.y, YEAR.x, CASAGE, Council, cas_adjusted_serious)) 


seriously_injured_councils <- seriously_injured_councils %>% 
  group_by(YEAR.x, Council) %>% 
  filter (YEAR.x > 2013) %>%
  summarise(casualties = sum(cas_adjusted_serious, na.rm=TRUE)) %>%
  ungroup() %>% 
  complete(YEAR.x = 2014:2021, Council, fill = list(casualties = 0)) %>%
  complete(YEAR.x = 2014:2030, Council, fill = list(casualties = NA)) %>% 
  arrange(Council, YEAR.x) %>%
  mutate(newyear = YEAR.x - 2016)  %>%  
  group_by(Council) %>%
  calculate_baseline() %>%
  mutate(slope = reduction_slope(baseline),
         rate_reduction = baseline + slope * newyear)


#use council_format function to add a name for the council

source(here("R", "council_format.R"))

seriously_injured_councils <- council_format(dataset = seriously_injured_councils, council_number = 'Council')

## children fatalities council split


ch_cas_councils <- snapcasacc %>% select(c(ACCREF, RUSER, CASSEV, YEAR.y, YEAR.x, CASAGE, Council)) 

ch_cas_councils <- ch_cas_councils %>% 
  group_by(YEAR.x, Council) %>% 
  filter (CASSEV == 1 & YEAR.x > 2013 & CASAGE < 16) %>%
  summarise(casualties = n()) %>%
  ungroup() %>% 
  complete(YEAR.x = 2014:2021, Council, fill = list(casualties = 0)) %>%
  complete(YEAR.x = 2014:2030, Council, fill = list(casualties = NA)) %>% 
  arrange(Council, YEAR.x) %>%
  mutate(newyear = YEAR.x - 2016) %>%  
  group_by(Council) %>%
  calculate_baseline() %>%
  mutate(slope = reduction_slope(baseline, percent_reduction = 60),
         rate_reduction = baseline + slope * newyear)



#use council_format function to add a name for the council

source(here("R", "council_format.R"))

ch_cas_councils <- council_format(dataset = ch_cas_councils, council_number = 'Council')

##children seriously injured councils

ch_seriously_injured_councils <- snapcasacc %>% select(c(ACCREF, RUSER, CASSEV, YEAR.y, YEAR.x, CASAGE, Council, cas_adjusted_serious)) 


ch_seriously_injured_councils <- ch_seriously_injured_councils %>% 
  group_by(YEAR.x, Council) %>% 
  filter (YEAR.x > 2013 & CASAGE < 16) %>%
  summarise(casualties = sum(cas_adjusted_serious, na.rm=TRUE)) %>%
  ungroup() %>% 
  complete(YEAR.x = 2014:2021, Council, fill = list(casualties = 0)) %>%
  complete(YEAR.x = 2014:2030, Council, fill = list(casualties = NA)) %>% 
  arrange(Council, YEAR.x) %>%
  mutate(newyear = YEAR.x - 2016) %>%  
  group_by(Council) %>%
  calculate_baseline() %>%
  mutate(slope = reduction_slope(baseline, percent_reduction = 60),
         rate_reduction = baseline + slope * newyear)


#use council_format function to add a name for the council

source(here("R", "council_format.R"))

ch_seriously_injured_councils <- council_format(dataset = ch_seriously_injured_councils, council_number = 'Council')


