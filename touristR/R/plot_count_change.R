




plot_count_change <- function(keyword) {






  consumer_key <- 'ugjqg8RGNvuTAL1fEiNtw'
  consumer_secret <- '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I'
  access_token <-
    '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL'
  access_secret <- 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
  options(httr_oauth_cache = TRUE)

  setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
  #
  #
  library(twitteR)





  input <- paste("#", keyword,sep="")

  geocode_id <- keyword

library(tidyverse)
  library(ggmap)

  df <- geocode(location =

                  geocode_id ,

                source = "dsk",messaging=FALSE) %>% as.tibble() %>% rename("long" = lon) %>% mutate(city =
                                                                                      geocode_id) %>% select(city, long, lat)




  #run query for all data per  month going from past 6 month until today


  searchTwitter(
    input,
    n = 10,
    lang = "en",
    resultType = "mixed",
    since = as.character ( (lubridate::ymd(Sys.Date() )  - 30) )   ,
    until = as.character ( lubridate::ymd(Sys.Date()  )       ),

    geocode = paste(df$lat, df$long, "40mi", sep=",")







  )





}

#needed to specify the geocode to avoid getting irrelevant content
#then input this into the twitter search page



plot_count_change(keyword = "lausanne")







