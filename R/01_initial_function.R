## this R script reads in the data, cleans it, and prepares for the map

source(here("R", "convert_coordinates.R"))

# bringing in the csv datasets 

snapacctem <- read.csv(here("data", "snapacctem.csv"))
snapcastem <- read.csv(here("data", "snapcastem.csv"))


#merge snapacctem and snapcas to get coordinates for each casualty

snapcasacc <- merge(snapcastem, snapacctem, by.x = "ACCREF", by.y = "ACCREF", all.x = TRUE)

#filter casualties based on year selected, convert coordinates to long/lat
casualties <- snapcasacc %>%
  filter(YEAR.x %in% ((mapyear-4):mapyear), CASSEV %in% c(1,2)) %>% 
  select(YEAR.x, CASAGE, Council, EAST, NORTH, RUSER, CASSEV) %>%
  mutate(road_user = case_when(
    RUSER == 1 ~ 'Pedestrians',
    RUSER == 2 ~ 'Pedal cyclists',
    RUSER == 3 ~ 'Motorcyclists',
    RUSER == 4 ~ 'Cars and taxis',
    RUSER == 5 ~ 'Cars and taxis',
    RUSER == 6 ~ 'Bus, Coach, Minibus',
    RUSER == 7 ~ 'Bus, Coach, Minibus',
    RUSER == 8 ~ 'LGV and HGV',
    RUSER == 9 ~ 'LGV and HGV',
    RUSER == 10 ~ 'Other'
  )) %>% 
  mutate(severity=case_when(
    CASSEV == 1 ~ 'Fatal',
    CASSEV == 2 ~ 'Serious injury',
    CASSEV == 3 ~ 'Slight injury'
  )) %>% 
  rowwise() %>%
  mutate(latitude = convert_coordinates(EAST, NORTH, "lat"),
         longitude = convert_coordinates(EAST, NORTH, "long")) %>%
  ungroup()

casualties_fatal_1 <- casualties %>%
  filter(CASSEV == 1, YEAR.x == mapyear)

casualties_fatal_serious_1 <- casualties %>%
  filter(CASSEV %in% c(1,2), YEAR.x == mapyear) 

casualties_fatal_2 <- casualties %>%
  filter(CASSEV == 1, YEAR.x == mapyear-1)

casualties_fatal_serious_2 <- casualties %>%
  filter(CASSEV %in% c(1,2), YEAR.x == mapyear-1) 

casualties_fatal_3 <- casualties %>%
  filter(CASSEV == 1, YEAR.x == mapyear-2)

casualties_fatal_serious_3 <- casualties %>%
  filter(CASSEV %in% c(1,2), YEAR.x == mapyear-2) 

casualties_fatal_4 <- casualties %>%
  filter(CASSEV == 1, YEAR.x == mapyear-3)

casualties_fatal_serious_4 <- casualties %>%
  filter(CASSEV %in% c(1,2), YEAR.x == mapyear-3) 

casualties_fatal_5 <- casualties %>%
  filter(CASSEV == 1, YEAR.x == mapyear-4)

casualties_fatal_serious_5 <- casualties %>%
  filter(CASSEV %in% c(1,2), YEAR.x == mapyear-4) 

