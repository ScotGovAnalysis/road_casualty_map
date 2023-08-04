
# calculate slope function for rate of reduction required

reduction_slope <- function(z, percent_reduction = 50) {
  
  rate_reduction <- 1 - (percent_reduction / 100)
  
  # point 1 = (0, z)
  # point 2 = (14, z * rate_reduction)
  # slope = (y2 - y1) / (x2 - x1)
  
  ((z * rate_reduction) - z) / (14 - 0)
  
}


#function for correcting year in x-axis labels
correctyear <- function(breaks){
  labels <- breaks + 2016
  return(labels)
}


calculate_baseline <- function(dataframe){
  x <- dataframe %>% 
    filter(newyear %in% c("-2", "-1", "0", "1", "2")) %>% 
    summarise(baseline = mean(casualties))
  
  dataframe %>% left_join(x, by = group_vars(dataframe))
}
