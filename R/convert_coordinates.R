
## Alice's function to convert easting, northing to longtude and latitude
# adapted from https://github.com/DataScienceScotland/school-information-dashboard/blob/main/functions/lat_long.R

library(sf)

convert_coordinates <- function(easting, northing, return) {
  
  # Check return is either lat or long, otherwise print error
  if(!return %in% c("lat", "long")) {
    stop("`return` must be either 'lat' or 'long'.")
  }
  
  `%>%` <- magrittr::`%>%`
  
  lat_long <-
    
    # Combine easting and northing into one co-ordinate
    sf::st_point(c(easting, northing)) %>%
    
    # Set co-ordinate reference system to British National Grid code
    # See http://epsg.io/27700
    sf::st_sfc(crs = 27700) %>%
    
    # Transform co-ordinate to longitude and latitude reference system
    # See http://epsg.io/4326
    sf::st_transform(crs = 4326) %>%
    
    # Extract co-ordinates
    sf::st_coordinates()
  
  # Return latitude or longitude co-ordinate depending on `return` argument
  if(return == "lat") return(lat_long[2])
  if(return == "long") return(lat_long[1])
  
}