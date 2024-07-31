### this script creates a leaflet map of fatal and serious casualties based on the mode of the road user


## get LA boundaries and names 

# create sf polygon layer from geojson for Local Authority for fatalities
# code from Tom Wilson

geojson <- readLines("https://martinjc.github.io/UK-GeoJSON/json/sco/topo_lad.json", warn = FALSE) %>%
  paste(collapse = "\n") %>%
  fromJSON(simplifyVector = FALSE)

geojson$style = list(
  weight = 3,
  color = " #1E22AA",
  opacity = 1,
  fill = FALSE
)


request <- "https://martinjc.github.io/UK-GeoJSON/json/sco/topo_lad.json"

file <- tempfile(fileext = ".geojson")

httr::GET(url = request, httr::write_disk(file))

la_boundaries <- read_sf(file)

# Create centroid layer for different LA 
# code from Tom Wilson

la_xy <- st_centroid(st_geometry(la_boundaries)) %>%
  st_coordinates() %>%
  as_tibble() %>%
  cbind(la_boundaries$LAD13NM) %>%
  setNames(c("longitude", "latitude", "la_name"))

## this function creates different colours for different severities

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


## get a map for fatalities and seriously injured

# adding icons to different mode of users

iconsped <- makeAwesomeIcon(
  icon = "ion-android-walk",
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(ped)
)

iconscyc <- makeAwesomeIcon(
  icon = "fa-bicycle",
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(cyc)
)

iconsmoto <- makeAwesomeIcon(
  icon = 'fa-motorcycle',
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(moto)
)

iconscar <- makeAwesomeIcon(
  icon = 'fa-solid fa-car',
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(car)
)

iconsbus <- makeAwesomeIcon(
  icon = "fa-sharp fa-solid fa-bus",
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(bus)
)

iconslor <- makeAwesomeIcon(
  icon = 'fa-solid fa-truck',
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(lor)
)

iconsother <- makeAwesomeIcon(
  icon = "",
  iconColor = 'black',
  library = 'fa',
  markerColor = getColor(other)
)

# the names (pedestrian, cyclist in this example) must be the exact values found in the column
custom_icons <- awesomeIconList('Pedestrians' = iconsped, 
                                "Pedal cyclists" = iconscyc,
                                "Motorcyclists" = iconsmoto,
                                "Cars and taxis" = iconscar,
                                "Bus, Coach, Minibus" = iconsbus,
                                "LGV and HGV" = iconslor,
                                "Other" = iconsother)


leaflet(casualties_categories) %>%
  addTiles() %>%
  addAwesomeMarkers(
    label = ~road_user,
    icon = ~ custom_icons[road_user], # the column name
    clusterOptions = markerClusterOptions()
    ) %>% 
  addLayersControl(
    overlayGroups = c("Pedestrians", "Pedal cyclists", "Motorcyclists", 
                      "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
                      "Other"),
    options = layersControlOptions(collapsed = FALSE)) %>% 
  hideGroup(c("Pedal cyclists", "Motorcyclists", 
              "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
              "Other"))

    
## fatalities only map

# adding icons to different mode of users

iconspedf <- makeAwesomeIcon(
  icon = "ion-android-walk",
  iconColor = 'black',
  library = 'ion',
  markerColor = "red"
)

iconscycf <- makeAwesomeIcon(
  icon = "fa-bicycle",
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconsmotof <- makeAwesomeIcon(
  icon = 'fa-motorcycle',
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconscarf <- makeAwesomeIcon(
  icon = 'fa-solid fa-car',
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconsbusf <- makeAwesomeIcon(
  icon = "fa-sharp fa-solid fa-bus",
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconslorf <- makeAwesomeIcon(
  icon = 'fa-solid fa-truck',
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

iconsotherf <- makeAwesomeIcon(
  icon = "",
  iconColor = 'black',
  library = 'fa',
  markerColor = "red"
)

# the names (pedestrian, cyclist in this example) must be the exact values found in the column
custom_icons <- awesomeIconList('Pedestrians' = iconspedf, 
                                "Pedal cyclists" = iconscycf,
                                "Motorcyclists" = iconsmotof,
                                "Cars and taxis" = iconscarf,
                                "Bus, Coach, Minibus" = iconsbusf,
                                "LGV and HGV" = iconslorf,
                                "Other" = iconsotherf)

leaflet(casualties_categories) %>%
  addTiles() %>%
  addAwesomeMarkers(
    label = ~road_user,
    icon = ~ custom_icons[road_user], # the column name
    clusterOptions = markerClusterOptions()
  ) %>% 
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