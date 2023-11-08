### this code renders the Rmarkdown file 
### please run this code 

library(rmarkdown)
library(here)

render(
  input = here("R","Rmarkdown.Rmd"),
  output_file = here ("R", "Casualty_map.html")
)