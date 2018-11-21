library(httr)
library(rlist)
library(jsonlite)
library(dplyr)
library(plyr)

getTripadvisorData <- function(city){
  tripadvisor_url <- paste0("https://www.tripadvisor.com/TypeAheadJson?action=API"
                            ,"&query=",city)
  tripadvisor_url <- gsub(" ","%20", tripadvisor_url)
  resp <- GET(tripadvisor_url)
  http_type(resp)
  jsonResp <- content(resp, as="parsed")
  
  modJson <- jsonResp$results[[1]]
  city_id <- modJson$document_id
  
  data_url <- paste0("https://www.tripadvisor.co.uk/GMapsLocationController?Actio"
                     ,"n=update&g=",city_id,"&mz=10&mw=1400&mh=420&pinSel=v2")
  resp_data <- fromJSON(data_url ,simplifyVector = F)
  resp_df <- ldply (resp_data$attractions, data.frame)
  latlng_df <- resp_df[c("customHover.title", "lat", "lng")]
  
  latlng_df <- data.frame(lapply(latlng_df, function(x) { gsub("\\", "", x, fixed=TRUE) }))
  latlng_df <- data.frame(lapply(latlng_df, function(x) { gsub("&amp", "&", x, fixed=TRUE) }))
  
  names(latlng_df) <- c("name", "lat", "lng")
  latlng_df
}

getTopNAttractions <- function(city, n) {
  head(getTripadvisorData(city), n)
}

getTopNAttractions("Paris", 30)





