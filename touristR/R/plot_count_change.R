
#to be removed
library(magrittr)


track_keyword <- function(keyword, number,  sincetype ) {



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




#saving the result of the function
sinceInput <- vector(mode = "character", length = 2L)
#adapting date (since) input

 if(sincetype=="days") {

  sinceInput[1] <-  ( lubridate::today(tzone=Sys.timezone()) - lubridate::days(number) ) %>% lubridate::ymd() %>% as.character()

  sinceInput[2] <-"days"

} else if(sincetype=="weeks") {


  sinceInput[1] <- ( lubridate::today(tzone=Sys.timezone()) -  lubridate::weeks(number) ) %>% lubridate::ymd() %>% as.character()

  sinceInput[2] <-"weeks"


}else if(sincetype=="months") {



#time difference in months (respecting e.g. months with 30 and 31 days)
  sinceInput[1] <-  (  lubridate::today(tzone=Sys.timezone())   -  lubridate::months(number) ) %>% lubridate::ymd() %>% as.character()

  sinceInput[2] <-"months"


}else if(sincetype=="years") {

  sinceInput[1] <-  (  lubridate::today(tzone=Sys.timezone())   -   lubridate::years(number) ) %>% lubridate::ymd() %>% as.character()

  sinceInput[2] <-"years"


}


#run query for all data per  month going from past 6 months until today
input <- paste("#", keyword, sep = "")


  #quer Twitter using the keyword input
 results_twitter <-   twitteR::searchTwitter(
     input ,
     n = 1000,
     resultType = "mixed",
     since =   sinceInput[1]  ,
     until = lubridate::today(tzone=Sys.timezone()) %>% lubridate::ymd() %>% as.character()  ,



    #specifying the geocode to be sure we only obtain e.g. indeed
    #the results published from Paris for search query Paris (tweet should
    #be made within a radius of 40 miles from Paris maximum)

    geocode = paste(df$lat, df$long, "40mi", sep = ",")   )



  #saving search query results in a dataframe
  results_tweetdata <-  twitteR::twListToDF(results_twitter)%>% tibble::as.tibble()



#creating the plot of keyword count per day over time (measure of popularity)

if(sincetype=="days"| sincetype=="weeks" ) {


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



#plot

print(

  results_tweetdata %>%

dplyr::group_by(created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count=n) %>%

  ggplot2::ggplot() +

  ggplot2::geom_line(mapping = ggplot2::aes(x=created, count),  size = 2, alpha = 0.8)+


  ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(8),labels = scales::number_format(accuracy = 1) ) +
  ggplot2::labs(title="Twitter keyword popularity tracking",

      subtitle =paste("Data fetched from",   sinceInput[1]  ,"until", lubridate::today() %>% lubridate::ymd() %>% as.character() ,  sep=" "),
      x = "Days", y = "Number of tweets posted")


)


} else if(sincetype=="months"| sincetype== "years") {



  results_tweetdata$created <- lubridate::ymd_hms(results_tweetdata$created,
                                                  tz=Sys.timezone(),
                                                  quiet=TRUE) %>% lubridate::ymd()



  print(

    results_tweetdata %>%  dplyr::group_by(created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count=n) %>%

  ggplot2::ggplot() +

    ggplot2::geom_line(mapping = ggplot2::aes(x=created, count),  size = 2, alpha = 0.8)+


    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(8),labels = scales::number_format(accuracy = 1) ) +
    ggplot2::labs(title="Twitter keyword popularity tracking",

         subtitle =paste("Data fetched from",   sinceInput[1]  ,"until", lubridate::today() %>% lubridate::ymd() %>% as.character() ,  sep=" "),
         x = "Days", y = "Number of tweets posted")


)

#for longer timeframe we aggregate data daily to smooth the variations of the dataset



}








  #return dataframe results
  return(results_tweetdata)


}

#needed to specify the geocode to avoid getting irrelevant content
#then input this into the twitter search page


#example
result <- track_keyword(keyword = "paris",number = 9,sincetype = "weeks")





#https://drsimonj.svbtle.com/label-line-ends-in-time-series-with-ggplot2

#https://cran.rstudio.com/web/packages/sweep/vignettes/SW01_Forecasting_Time_Series_Groups.html

#https://business-science.github.io/sweep/articles/SW00_Introduction_to_sweep.html



