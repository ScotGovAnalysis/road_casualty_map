## council formatting function


council_format <- function(dataset, council_number){
  dataset %>% ungroup() %>%
  mutate(dataset, council_name=case_when(
  dataset[[council_number]] == 100 ~ "Aberdeen City",
  dataset[[council_number]] == 110 ~ "Aberdeenshire",
  dataset[[council_number]] == 120 ~ "Angus",
  dataset[[council_number]] == 130 ~ "Argyll and Bute",
  dataset[[council_number]] == 150 ~ "Clackmannanshire",
  dataset[[council_number]] == 170 ~ "Dumfries and Galloway",
  dataset[[council_number]] == 180 ~ "Dundee City",
  dataset[[council_number]] == 190 ~ "East Ayrshire",
  dataset[[council_number]] == 200 ~ "East Dunbartonshire",
  dataset[[council_number]] == 210 ~ "East Lothian",
  dataset[[council_number]] == 220 ~ "East Renfrewshire",
  dataset[[council_number]] == 230 ~ "Edinburgh, City of",
  dataset[[council_number]] == 235 ~ "Eilean Siar",
  dataset[[council_number]] == 240 ~ "Falkirk",
  dataset[[council_number]] == 250 ~ "Fife",
  dataset[[council_number]] == 260 ~ "Glasgow City",
  dataset[[council_number]] == 270 ~ "Highland",
  dataset[[council_number]] == 280 ~ "Inverclyde",
  dataset[[council_number]] == 290 ~ "Midlothian",
  dataset[[council_number]] == 300 ~ "Moray",
  dataset[[council_number]] == 310 ~ "North Ayrshire",
  dataset[[council_number]] == 320 ~ "North Lanarkshire",
  dataset[[council_number]] == 330 ~ "Orkney Islands",
  dataset[[council_number]] == 340 ~ "Perth and Kinross",
  dataset[[council_number]] == 350 ~ "Renfrewshire",
  dataset[[council_number]] == 355 ~ "Scottish Borders",
  dataset[[council_number]] == 360 ~ "Shetland Islands",
  dataset[[council_number]] == 370 ~ "South Ayrshire",
  dataset[[council_number]] == 380 ~ "South Lanarkshire",
  dataset[[council_number]] == 390 ~ "Stirling",
  dataset[[council_number]] == 395 ~ "West Dunbartonshire",
  dataset[[council_number]] == 400 ~ "West Lothian",
  ))
  }
  


