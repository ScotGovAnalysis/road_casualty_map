### this code renders the Rmarkdown file 
### please run this code 

library(rmarkdown)
library(here)

render(
  input = here("R","Rmarkdown1.Rmd"),
  output_file = here ("R", "Casualty_map.html")
)

render(
  input = here("R","Rmarkdown2.Rmd"),
  output_file = here ("R", "Casualty_map_2022.html")
)

render(
  input = here("R","Rmarkdown3.Rmd"),
  output_file = here ("R", "Casualty_map_2021.html")
)

render(
  input = here("R","Rmarkdown4.Rmd"),
  output_file = here ("R", "Casualty_map_2020.html")
)

render(
  input = here("R","Rmarkdown5.Rmd"),
  output_file = here ("R", "Casualty_map_2019.html")
)
