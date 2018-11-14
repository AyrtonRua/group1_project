##############################################
# What it does: Takes name of city and returns tripadvisor URL
# Sample input: Zurich
# Sample output: 
# > hotel_url
# [1] "https://www.tripadvisor.com/Hotels-g188113-Zurich-Hotels.html"
# > restaurant_url
# [1] "https://www.tripadvisor.com/Restaurants-g188113-Zurich.html"
# > attractions_url
# [1] "https://www.tripadvisor.com/Attractions-g188113-Activities-Zurich.html"
##############################################

library(httr)
library(rlist)
library(jsonlite)
library(dplyr)

city <- "Zurich"
url <- paste0("https://www.tripadvisor.com/TypeAheadJson?action=API&query=",city,"&injectLists=true")

resp <- GET(url)
http_type(resp)
jsonResp <- content(resp, as="parsed")

modJson <- jsonResp$results

hotel_url <- paste0("https://www.tripadvisor.com", modJson[[1]]$children[[1]]$url)
restaurant_url <- paste0("https://www.tripadvisor.com", modJson[[1]]$children[[2]]$url)
attractions_url <-paste0("https://www.tripadvisor.com", modJson[[1]]$children[[3]]$url)

hotel_url
restaurant_url
attractions_url
