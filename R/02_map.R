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

# roaduser <- leaflet() %>%
#   addTiles() %>%
#   fitBounds(min(casualties_fatal_serious$longitude), 
#             min(casualties_fatal_serious$latitude), 
#             max(casualties_fatal_serious$longitude), 
#             max(casualties_fatal_serious$latitude)) %>% 
#   registerPlugin(clusterPlugin) %>% 
#   registerPlugin(awesomePlugin) %>% 
#   registerPlugin(subgroupPlugin) %>% 
#   # This is using the JavaScript code for the marker icons, clusters,
#   # and layer control
#   onRender(readLines(js_file, warn = FALSE), data = casualties_fatal_serious)

create_roaduser_map <- function(data) {
  leaflet() %>%
    addTiles() %>%
    fitBounds(
      min(data$longitude), 
      min(data$latitude), 
      max(data$longitude), 
      max(data$latitude)
    ) %>%
    registerPlugin(clusterPlugin) %>%
    registerPlugin(awesomePlugin) %>%
    registerPlugin(subgroupPlugin) %>%
    # This is using the JavaScript code for the marker icons, clusters,
    # and layer control
    onRender(readLines(js_file, warn = FALSE), data = data)
}

roaduser_1 <- create_roaduser_map(casualties_fatal_serious_1)
roaduser_2 <- create_roaduser_map(casualties_fatal_serious_2)
roaduser_3 <- create_roaduser_map(casualties_fatal_serious_3)
roaduser_4 <- create_roaduser_map(casualties_fatal_serious_4)
roaduser_5 <- create_roaduser_map(casualties_fatal_serious_5)
  

# fatalities <- leaflet() %>%
#   addTiles() %>%
#   registerPlugin(clusterPlugin) %>% 
#   registerPlugin(awesomePlugin) %>% 
#   registerPlugin(subgroupPlugin) %>% 
#   # Using the JavaScript with this line:
#   onRender(readLines(js_file, warn = FALSE), data = casualties_fatal) %>%
#   # Then can add other data back in R
#   addTopoJSON(geojson) %>%
#   addLabelOnlyMarkers(
#     data = la_xy,
#     lng = ~longitude,
#     lat = ~latitude,
#     label = ~la_name,
#     labelOptions = labelOptions(
#       noHide = TRUE,
#       textOnly = TRUE,
#       style = list(
#         "color" = "#1E22AA",
#         "font-size" = "16px"
#       ))) # %>%
  # Layers control
  # addLayersControl(
  #   overlayGroups = c("Pedestrians", "Pedal cyclists", "Motorcyclists", 
  #                     "Cars and taxis", "Bus, Coach, Minibus", "LGV and HGV", 
  #                     "Other"),
  #   options = layersControlOptions(collapsed = FALSE)) 

create_fatalities_map <- function(data) {
  leaflet() %>%
    addTiles() %>%
    registerPlugin(clusterPlugin) %>%
    registerPlugin(awesomePlugin) %>%
    registerPlugin(subgroupPlugin) %>%
    onRender(readLines(js_file, warn = FALSE), data = data) %>%
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
        )
      )
    )
}

fatalities_1 <- create_fatalities_map(casualties_fatal_1)
fatalities_2 <- create_fatalities_map(casualties_fatal_2)
fatalities_3 <- create_fatalities_map(casualties_fatal_3)
fatalities_4 <- create_fatalities_map(casualties_fatal_4)
fatalities_5 <- create_fatalities_map(casualties_fatal_5)