### this script creates a leaflet map of fatal and serious casualties based on the mode of the road user


library(here)
library(leaflet)
library(rgdal)  
library(geojsonio)
library(tidyverse)


source(here("R", "convert_coordinates.R"))

library(jsonlite)

geojson <- readLines("https://martinjc.github.io/UK-GeoJSON/json/sco/topo_lad.json", warn = FALSE) %>%
  paste(collapse = "\n") %>%
  fromJSON(simplifyVector = FALSE)

geojson$style = list(
  weight = 3,
  color = " #1E22AA",
  opacity = 1,
  fill = FALSE
)

# create sf polygon layer from geojson ------------------------------------


request <- "https://martinjc.github.io/UK-GeoJSON/json/sco/topo_lad.json"

file <- tempfile(fileext = ".geojson")

httr::GET(url = request, httr::write_disk(file))

la_boundaries <- read_sf(file)



# Create centroid layer
la_xy <- st_centroid(st_geometry(la_boundaries)) %>%
  st_coordinates() %>%
  as_tibble() %>%
  cbind(la_boundaries$LAD13NM) %>%
  setNames(c("longitude", "latitude", "la_name"))




getColor <- function(casualty) {
  sapply(casualty$CASSEV, function(CASSEV) {
    if(CASSEV == 1) {
      "red"
    } else if (CASSEV == 2) {
      "orange"
    } else {
      "grey"
    } })
}

iconsped <- awesomeIcons(
  icon = "ion-android-walk",
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(ped)
)

iconscyc <- awesomeIcons(
  icon = "fa-bicycle",
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(cyc)
)

iconsmoto <- awesomeIcons(
  icon = 'fa-motorcycle',
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(moto)
)

iconscar <- awesomeIcons(
  icon = 'fa-solid fa-car',
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(car)
)

iconsbus <- awesomeIcons(
  icon = "fa-sharp fa-solid fa-bus",
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(bus)
)

iconslor <- awesomeIcons(
  icon = 'fa-solid fa-truck',
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(lor)
)

iconsother <- awesomeIcons(
  icon = "",
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(other)
)

roaduser2022 <- leaflet()  %>% 
  addTiles() %>% 
  addAwesomeMarkers(data = ped, group = "Pedestrians", label = ~severity, icon = iconsped, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = cyc, group = "Pedal cyclists", label = ~severity, icon = iconscyc, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = moto, group = "Motorcyclists", label = ~severity, icon = iconsmoto, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = car, group = "Cars and taxis", label = ~severity, icon = iconscar, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = bus, group = "Bus, Coach, Minibus", label = ~severity, icon = iconsbus, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = lor, group = "LGV and HGV", label = ~severity, icon = iconslor, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = other, group = "Other", label = ~severity, icon = iconsother, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  # addTopoJSON(geojson) %>% 
  # addLabelOnlyMarkers(
  #   data = la_xy,
  #   lng = ~longitude,
  #   lat = ~latitude,
  #   label = ~la_name,
  #   labelOptions = labelOptions(
  #     noHide = TRUE,
  #     textOnly = TRUE,
  #     style = list(
  #       "color" = "#1E22AA",
#       "font-size" = "16px" 
#     ))) %>% 
  # Layers control
  addLayersControl(
  overlayGroups = c("Pedestrians", "Pedal cyclists", "Motorcyclists", 
                    "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
                    "Other"),
  options = layersControlOptions(collapsed = FALSE)) %>% 
  hideGroup(c("Pedal cyclists", "Motorcyclists", 
            "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
            "Other"))

### fatalities only map


iconspedf <- awesomeIcons(
  icon = "ion-android-walk",
  iconColor = 'black',
  library = 'ion',
  markerColor = "red"
)

iconscycf <- awesomeIcons(
  icon = "fa-bicycle",
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconsmotof <- awesomeIcons(
  icon = 'fa-motorcycle',
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconscarf <- awesomeIcons(
  icon = 'fa-solid fa-car',
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconsbusf <- awesomeIcons(
  icon = "fa-sharp fa-solid fa-bus",
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconslorf <- awesomeIcons(
  icon = 'fa-solid fa-truck',
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconsotherf <- awesomeIcons(
  icon = "",
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

# custom_icons <- awesomeIconList('Pedestrian' = iconspedf, 
#                                 'Pedal cycle' = iconscycf
#                                 )
# 
# leaflet(fatals)  %>% 
#   addTiles() %>% 
#   addAwesomeMarkers(label = ~road_user, icon = custom_icons[road_user], 
#                     clusterOptions = markerClusterOptions(freezeAtZoom = 15))

fatalities2022 <-leaflet()  %>% 
  addTiles() %>% 
  addAwesomeMarkers(data = fatalities_ped, group = "Pedestrians", label = ~road_user, icon = iconspedf, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = fatalities_cyc, group = "Pedal cyclists", label = ~road_user, icon = iconscycf, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = fatalities_moto, group = "Motorcyclists", label = ~road_user, icon = iconsmotof, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = fatalities_car, group = "Cars and taxis", label = ~road_user, icon = iconscarf, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  #addAwesomeMarkers(data = fatalities_bus, group = "Bus, Coach, Minibus", label = ~road_user, icon = iconsbusf) %>% 
  addAwesomeMarkers(data = fatalities_lor, group = "LGV and HGV", label = ~road_user, icon = iconslorf, clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addAwesomeMarkers(data = fatalities_other, group = "Other", label = ~road_user, icon = iconsotherf,clusterOptions = markerClusterOptions(freezeAtZoom = 15)) %>% 
  addTopoJSON(geojson) %>%
  addLabelOnlyMarkers(
    data = la_xy,
    lng = ~longitude,
    lat = ~latitude,
    label = ~la_name,
    labelOptions = labelOptions(
      noHide = TRUE,
      textOnly = TRUE,
      style = list(
        "color" = "#1E22AA",
        "font-size" = "16px"
    ))) %>%
# Layers control
  addLayersControl(
  overlayGroups = c("Pedestrians", "Pedal cyclists", "Motorcyclists", 
                    "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
                    "Other"),
  options = layersControlOptions(collapsed = FALSE)) 




