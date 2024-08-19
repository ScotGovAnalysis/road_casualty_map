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

# source script to read required JavaScript plugins
# The JavaScript script created to allow cluster icons with functioning
# layer control. See the plugin that was used and stored in javascript/plugins:
# https://github.com/ghybs/Leaflet.FeatureGroup.SubGroup?tab=readme-ov-file

source(here("R", "load_plugins.R"))

# Path to JavaScript script
js_file <- here("javascript", "createMap.js")

## COMMENTING OUT ALL LINES NOW DONE WITH javascript. 
# See javascript/createMap.js
## this function creates different colours for different severities

# getColor <- function(casualty) {
#   sapply(casualty$CASSEV, function(CASSEV) {
#     if(CASSEV == 1) {
#       "red"
#     } else if (CASSEV == 2) {
#       "orange"
#     } else {
#       "grey"
#     } })
# }
# 
# 
# ## get a map for fatalities and seriously injured
# 
# # adding icons to different mode of users
# 
# iconsped <- makeAwesomeIcon(
#   icon = "ion-android-walk",
#   iconColor = 'black',
#   library = 'ion',
#   markerColor = getColor(ped)
# )
# 
# iconscyc <- makeAwesomeIcon(
#   icon = "fa-bicycle",
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = getColor(cyc)
# )
# 
# iconsmoto <- makeAwesomeIcon(
#   icon = 'fa-motorcycle',
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = getColor(moto)
# )
# 
# iconscar <- makeAwesomeIcon(
#   icon = 'fa-solid fa-car',
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = getColor(car)
# )
# 
# iconsbus <- makeAwesomeIcon(
#   icon = "fa-sharp fa-solid fa-bus",
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = getColor(bus)
# )
# 
# iconslor <- makeAwesomeIcon(
#   icon = 'fa-solid fa-truck',
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = getColor(lor)
# )
# 
# iconsother <- makeAwesomeIcon(
#   icon = "",
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = getColor(other)
# )
# 
# # the names (pedestrian, cyclist in this example) must be the exact values found in the column
# custom_icons <- awesomeIconList('Pedestrians' = iconsped, 
#                                 "Pedal cyclists" = iconscyc,
#                                 "Motorcyclists" = iconsmoto,
#                                 "Cars and taxis" = iconscar,
#                                 "Bus, Coach, Minibus" = iconsbus,
#                                 "LGV and HGV" = iconslor,
#                                 "Other" = iconsother)


roaduser <- leaflet() %>%
  addTiles() %>%
  fitBounds(min(casualties_categories$longitude), 
            min(casualties_categories$latitude), 
            max(casualties_categories$longitude), 
            max(casualties_categories$latitude)) %>% 
  registerPlugin(clusterPlugin) %>% 
  registerPlugin(awesomePlugin) %>% 
  registerPlugin(subgroupPlugin) %>% 
  # This is using the JavaScript code for the marker icons, clusters,
  # and layer control
  onRender(readLines(js_file, warn = FALSE), data = casualties_categories)
  
  # addAwesomeMarkers(
  #   label = ~road_user,
  #   icon = ~ custom_icons[road_user], # the column name
  #   clusterOptions = markerClusterOptions()
  # ) %>% 
  # addLayersControl(
  #   overlayGroups = c("Pedestrians", "Pedal cyclists", "Motorcyclists", 
  #                     "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
  #                     "Other"),
  #   options = layersControlOptions(collapsed = FALSE)) %>% 
  # hideGroup(c("Pedal cyclists", "Motorcyclists", 
  #             "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
  #             "Other"))

    
## fatalities only map

# adding icons to different mode of users

# iconspedf <- makeAwesomeIcon(
#   icon = "ion-android-walk",
#   iconColor = 'black',
#   library = 'ion',
#   markerColor = "red"
# )
# 
# iconscycf <- makeAwesomeIcon(
#   icon = "fa-bicycle",
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = "red"
# )
# 
# iconsmotof <- makeAwesomeIcon(
#   icon = 'fa-motorcycle',
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = "red"
# )
# 
# iconscarf <- makeAwesomeIcon(
#   icon = 'fa-solid fa-car',
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = "red"
# )
# 
# iconsbusf <- makeAwesomeIcon(
#   icon = "fa-sharp fa-solid fa-bus",
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = "red"
# )
# 
# iconslorf <- makeAwesomeIcon(
#   icon = 'fa-solid fa-truck',
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = "red"
# )
# 
# iconsotherf <- makeAwesomeIcon(
#   icon = "",
#   iconColor = 'black',
#   library = 'fa',
#   markerColor = "red"
# )
# 
# # the names (pedestrian, cyclist in this example) must be the exact values found in the column
# custom_icons <- awesomeIconList('Pedestrians' = iconspedf, 
#                                 "Pedal cyclists" = iconscycf,
#                                 "Motorcyclists" = iconsmotof,
#                                 "Cars and taxis" = iconscarf,
#                                 "Bus, Coach, Minibus" = iconsbusf,
#                                 "LGV and HGV" = iconslorf,
#                                 "Other" = iconsotherf)

fatalities <- leaflet() %>%
  addTiles() %>%
  registerPlugin(clusterPlugin) %>% 
  registerPlugin(awesomePlugin) %>% 
  registerPlugin(subgroupPlugin) %>% 
  # Using the JavaScript with this line:
  onRender(readLines(js_file, warn = FALSE), data = casualties_categories) %>%
  # Then can add other data back in R
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
      ))) # %>%
  # Layers control
  # addLayersControl(
  #   overlayGroups = c("Pedestrians", "Pedal cyclists", "Motorcyclists", 
  #                     "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
  #                     "Other"),
  #   options = layersControlOptions(collapsed = FALSE)) 