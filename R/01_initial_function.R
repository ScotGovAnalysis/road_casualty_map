## this R script reads in the data, cleans it, and prepares for the map

source(here("R", "convert_coordinates.R"))

# bringing in the csv datasets 

snapacctem <- read.csv(here("data", "snapacctem.csv"))
snapcastem <- read.csv(here("data", "snapcastem.csv"))


#merge snapacctem and snapcas to get coordinates for each casualty

snapcasacc <- merge(snapcastem, snapacctem, by.x = "ACCREF", by.y = "ACCREF", all.x = TRUE)

#filter casualties based on year selected, convert coordinates to long/lat

casualties <- snapcasacc %>%  
  filter (YEAR.x == mapyear) %>% 
  select(CASAGE, Council, EAST, NORTH, RUSER, CASSEV) %>% 
  mutate(road_user=case_when(
    RUSER == 1 ~ 'Pedestrian',
    RUSER == 2 ~ 'Pedal cycle',
    RUSER == 3 ~ 'Motorcycle',
    RUSER == 4 ~ 'Car',
    RUSER == 5 ~ 'Taxi',
    RUSER == 6 ~ 'Minibus',
    RUSER == 7 ~ 'Bus/coach',
    RUSER == 8 ~ 'LGV',
    RUSER == 9 ~ 'HGV',
    RUSER == 10 ~'Other',
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

casualties_categories <- casualties %>%
  mutate(road_user = case_when(
    road_user == 'Pedestrian' ~ 'Pedestrians',
    road_user == 'Pedal cycle' ~ 'Pedal cyclists',
    road_user == 'Motorcycle' ~ 'Motorcyclists',
    road_user == 'Car' ~ 'Cars and taxis',
    road_user == 'Taxi' ~ 'Cars and taxis',
    road_user == 'Minibus' ~ 'Bus, Coach, Minibus',
    road_user == 'Bus/coach' ~ 'Bus, Coach, Minibus',
    road_user == 'LGV' ~ 'LGV and HGV',
    road_user == 'HGV' ~ 'LGV and HGV',
    road_user == 'Other' ~ 'Other'
  ))

#select for all the different groups for easier manipulation for leaflet

fatals <- casualties %>% 
  filter(CASSEV == 1)

fatalities_ped <- casualties %>% 
  filter(CASSEV == 1 & RUSER == 1)

serious_ped <- casualties %>% 
  filter(CASSEV == 2 & RUSER == 1)

fatalities_cyc <- casualties %>% 
  filter(CASSEV == 1 & RUSER == 2)

serious_cyc <- casualties %>% 
  filter(CASSEV == 2 & RUSER == 2)

fatalities_moto <- casualties %>% 
  filter(CASSEV == 1 & RUSER == 3)

serious_moto <- casualties %>% 
  filter(CASSEV == 2 & RUSER == 3)

fatalities_car <- casualties %>% 
  filter(CASSEV == 1 & (RUSER == 4 | RUSER == 5) )

serious_car <- casualties %>% 
  filter(CASSEV == 2 & (RUSER == 4 | RUSER == 5) )

fatalities_bus <- casualties %>% 
  filter(CASSEV == 1 & (RUSER == 6 | RUSER == 7) )

serious_bus <- casualties %>% 
  filter(CASSEV == 2 & (RUSER == 6 | RUSER == 7) )

fatalities_lor <- casualties %>% 
  filter(CASSEV == 1 & (RUSER == 8 | RUSER == 9) )

serious_lor <- casualties %>% 
  filter(CASSEV == 2 & (RUSER == 8 | RUSER == 9) )

fatalities_other <- casualties %>% 
  filter(CASSEV == 1 & RUSER == 10)

serious_other <- casualties %>% 
  filter(CASSEV == 2 & RUSER == 10)

ped <- casualties %>% 
  filter((CASSEV == 1 | CASSEV == 2)  & RUSER == 1)

cyc <- casualties %>% 
  filter((CASSEV == 1 | CASSEV == 2)  & RUSER == 2)

moto <- casualties %>% 
  filter((CASSEV == 1 | CASSEV == 2)  & RUSER == 3)

car <- casualties %>% 
  filter((CASSEV == 1 | CASSEV == 2)  & (RUSER == 4 | RUSER == 5))

bus <- casualties %>% 
  filter((CASSEV == 1 | CASSEV == 2)  & (RUSER == 6 | RUSER == 7))

lor <- casualties %>% 
  filter((CASSEV == 1 | CASSEV == 2)  & (RUSER == 8 | RUSER == 9))

other <- casualties %>% 
  filter((CASSEV == 1 | CASSEV == 2)  & RUSER == 10)


