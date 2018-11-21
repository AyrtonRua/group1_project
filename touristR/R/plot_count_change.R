




track_keyword <- function(keyword) {



#accessing Twitter via API
  consumer_key <- 'ugjqg8RGNvuTAL1fEiNtw'
  consumer_secret <- '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I'
  access_token <- '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL'
  access_secret <- 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
 twitteR::setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)





  #obtain latitude and longitude of the input city/keyword
  #and make a dataframe from it city lat and long
  df <- ggmap::geocode(location =
                    keyword ,
                source = "dsk",
                messaging = FALSE) %>% tibble::as.tibble() %>% dplyr::rename("long" = lon) %>%
    dplyr::mutate(city = keyword) %>% dplyr::select(city, long, lat)





  #run query for all data per  month going from past 6 month until today

  input <- paste("#", keyword, sep = "")


  #quer Twitter using the keyword input
 results_twitter <-   twitteR::searchTwitter(
     input ,
     n = 10,
     lang = "en"  ,
     resultType = "mixed",
     since = as.character ((lubridate::ymd(Sys.Date())  - 30))   ,
     until = as.character (lubridate::ymd(Sys.Date())),

    #specifying the geocode to be sure we only obtain e.g. indeed
    #the results published from Paris for search query Paris (tweet should
    #be made within a radius of 40 miles from Paris maximum)

    geocode = paste(df$lat, df$long, "40mi", sep = ",")

                    )



  #saving search query results in a dataframe
  results_tweetdata <-  twitteR::twListToDF(results_twitter)%>% tibble::as.tibble()


  #correct date format and keep it with seconds to have a very specific
  #time precision level e.g. to be used during marketing campaigns
  #to identify the time slots where users post the most about a given keywork
  #e.g. to optimize when to run an ad during the day (when people interact/engage
  #the most with our keyword=>more engagement increases the visibility of the company)
  #and for a tourist useful to know e.g. what is the current hot spot e.g. coffee shop to go to now

  #a resaonable time frame to aggregate results is hours in that sense

  results_tweetdata$created <- lubridate::ymd_hms(results_tweetdata$created,
                                                  tz=Sys.timezone(),
                                                  quiet=TRUE) %>% lubridate::round_date(unit="hour")





#creating the plot of keyword count per day over time (measure of popularity)



  #return dataframe results
  return(results_tweetdata)


}

#needed to specify the geocode to avoid getting irrelevant content
#then input this into the twitter search page


#example
result <- track_keyword(keyword = "bern")


#getting the count of tweets for each day
result %>%  dplyr::group_by(created) %>% dplyr::count() %>% dplyr::arrange() %>%

  ggplot2::ggplot() +
#
  ggplot2::geom_line(mapping = ggplot2::aes(x=created, n),  size = 2, alpha = .8)


#https://drsimonj.svbtle.com/label-line-ends-in-time-series-with-ggplot2

#https://cran.rstudio.com/web/packages/sweep/vignettes/SW01_Forecasting_Time_Series_Groups.html

#https://business-science.github.io/sweep/articles/SW00_Introduction_to_sweep.html



