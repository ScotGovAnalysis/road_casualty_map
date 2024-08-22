# leaflet R package includes clusters but need to use this plugin in
# JavaScript code so need to load as htmlDependency
cluster_plugin_dir <- normalizePath(file.path(
  system.file(package = "leaflet"),
  "htmlwidgets",
  "plugins",
  "Leaflet.markercluster"
))

clusterPlugin <- htmlDependency("leafletCluster.plugins", "1.4.1",
  src = cluster_plugin_dir,
  script = c("leaflet.markercluster.js"),
  stylesheet = c(
    "MarkerCluster.Default.css",
    "MarkerCluster.css"
  )
)

# same with awesome icons plugin
awesome_plugin_dir <- normalizePath(file.path(
  system.file(package = "leaflet"),
  "htmlwidgets",
  "plugins",
  "Leaflet.awesome-markers"
))

awesomePlugin <- htmlDependency("Leaflet.awesome-markers", "2.0.3",
  src = awesome_plugin_dir,
  script = c(
    "leaflet.awesome-markers.js",
    "leaflet.awesome-markers.min.js",
    "bootstrap.min.js"
  ),
  stylesheet = c(
    "leaflet.awesome-markers.css",
    "ionicons.min.css",
    "font-awesome.min.css",
    "bootstrap.min.css",
    "bootstrap-theme.min.css"
  ),
  all_files = TRUE
)


subgroupPlugin <- htmlDependency("leafletSubGroup.plugins", "1.0.2",
  src = normalizePath(here(
    "javascript",
    "plugins"
  )),
  script = c("leaflet.featuregroup.subgroup.js")
)

# We then need a function to register the plugins with the leaflet map
registerPlugin <- function(map, plugin) {
  map$dependencies <- c(map$dependencies, list(plugin))
  map
}
