

#to be removed
library(magrittr)




track_keyword <- function(keyword, number,  sincetype) {
  #accessing Twitter via API
  consumer_key <- 'ugjqg8RGNvuTAL1fEiNtw'
  consumer_secret <- '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I'
  access_token <-
    '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL'
  access_secret <- 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
  twitteR::setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)



  #obtain latitude and longitude of the input city/cityName
  #and make a dataframe from it city lat and long
  df <- ggmap::geocode(location =
                         keyword ,
                       source = "dsk",
                       messaging = FALSE) %>% tibble::as.tibble() %>% dplyr::rename("long" = lon) %>%
    dplyr::mutate(city = keyword) %>% dplyr::select(city, long, lat)



  #saving the result of the function
  sinceInput <- vector(mode = "character", length = 1L)
  #adapting date (since) input


  if (sincetype == "days") {
    sinceInput[1] <-
      (lubridate::today(tzone = Sys.timezone()) - lubridate::days(number)) %>% lubridate::ymd() %>% as.character()



  } else if (sincetype == "weeks") {
    sinceInput[1] <-
      (lubridate::today(tzone = Sys.timezone()) -  lubridate::weeks(number)) %>% lubridate::ymd() %>% as.character()



  } else if (sincetype == "months") {
    #time difference in months (respecting e.g. months with 30 and 31 days)
    sinceInput[1] <-
      (lubridate::today(tzone = Sys.timezone())   -  lubridate::period(1,units="month")) %>% lubridate::ymd() %>% as.character()



  } else if (sincetype == "years") {
    sinceInput[1] <-
      (lubridate::today(tzone = Sys.timezone())   -   lubridate::years(number)) %>% lubridate::ymd() %>% as.character()



  }

  #run query for that keyword (format is #... without any space)
  #first we remove any white space to obtain oneword input
  keyword_input <- gsub(keyword, pattern = " ",replacement = "")
  #then we obtain the #oneword format to be used as input for the Twitter query
  input <- paste("#", keyword_input, sep = "")


  #quer Twitter using the keyword input
  results_twitter <-   twitteR::searchTwitter(
    input ,
    n = 1000,
    resultType = "mixed",
    since =   sinceInput[1]  ,
    until = lubridate::today(tzone = Sys.timezone()) %>% lubridate::ymd() %>% as.character()  ,

    #specifying the geocode to be sure we only obtain e.g. indeed
    #the results published from Paris for search query Paris (tweet should
    #be made within a radius of 40 miles from Paris maximum)

    geocode = paste(df$lat, df$long, "40mi", sep = ",")     )



  #saving search query results in a dataframe
  results_tweetdata <-
    twitteR::twListToDF(results_twitter) %>% tibble::as.tibble()



  #creating the plot of keyword count per day over time (measure of popularity)



  if (  sincetype == "days" &&  number <= 14) {
          #correct date format and keep it with seconds to have a very specific
          #time precision level e.g. to be used during marketing campaigns
          #to identify the time slots where users post the most about a given keywork
          #e.g. to optimize when to run an ad during the day (when people interact/engage
          #the most with our keyword=>more engagement increases the visibility of the company)
          #and for a tourist useful to know e.g. what is the current hot spot e.g. coffee shop to go to now

          #a resaonable time frame to aggregate results is hours in that sense

          results_tweetdata$created <-
            lubridate::ymd_hms(results_tweetdata$created,
                               tz = Sys.timezone(),
                               quiet = TRUE) %>%
            lubridate::round_date(unit =  "hour")



          #plot


          print(
            results_tweetdata %>%

            dplyr::group_by(created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count =
                                                                                               n) %>%

            ggplot2::ggplot() +

            ggplot2::geom_line(
              mapping = ggplot2::aes(x = created, count),
              size = 1,
              alpha = 1
            ) +


            ggplot2::scale_y_continuous(
              breaks = scales::pretty_breaks(8),
              labels = scales::number_format(accuracy = 1)
            ) +
            ggplot2::labs(
              title =  paste(
                paste("Twitter #", keyword, sep = ""),
                "popularity tracking"   ,
                sep = " "
              ),

              caption = paste(

                                "Note: Hourly data (UTC time) fetched from",

                               format(as.Date(sinceInput[1]), "%A, %d-%b. %Y")
                               ,

                               "until",
                               format(as.Date(Sys.Date()), "%A, %d-%b. %Y"),".",
                               sep = " "
              ),
              x = "Days",
              y = "Number of tweets posted"
            ) +
            ggplot2::theme_minimal() +

              ggplot2::theme(
                axis.title = ggplot2::element_text(size = 12, face = "bold"),
                plot.caption = ggplot2::element_text(size = 10,face = "italic",hjust = 0),

                plot.title = ggplot2::element_text(size = 14,face = "bold"),
                axis.text.x = ggplot2::element_text(size=8),axis.text.y = ggplot2::element_text(size=8)
              ) +
              ggplot2::theme(plot.margin = ggplot2::unit(c(2,10,2,2), "mm"))



          )

        } else
          if(sincetype == "weeks" && number < 3) {
    #correct date format and keep it with seconds to have a very specific
    #time precision level e.g. to be used during marketing campaigns
    #to identify the time slots where users post the most about a given keywork
    #e.g. to optimize when to run an ad during the day (when people interact/engage
    #the most with our keyword=>more engagement increases the visibility of the company)
    #and for a tourist useful to know e.g. what is the current hot spot e.g. coffee shop to go to now

    #a resaonable time frame to aggregate results is hours in that sense

    results_tweetdata$created <-
    lubridate::ymd_hms(results_tweetdata$created,
                         tz = Sys.timezone(),
                         quiet = TRUE) %>%
      lubridate::round_date(unit =  "hour")



    #plot


    print(
      results_tweetdata %>%

        dplyr::group_by(created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count =
                                                                                             n) %>%

        ggplot2::ggplot() +

        ggplot2::geom_line(
          mapping = ggplot2::aes(x = created, count),
          size = 2,
          alpha = 0.8
        ) +


        ggplot2::scale_y_continuous(
          breaks = scales::pretty_breaks(8),
          labels = scales::number_format(accuracy = 1)
        ) +
        ggplot2::labs(
          title =  paste(
            paste("Twitter #", keyword, sep = ""),
            "popularity tracking"   ,
            sep = " "
          ),


          caption = paste(

            "Note: Hourly data (UTC time) fetched from",

            format(as.Date(sinceInput[1]), "%A, %d-%b. %Y")
            ,

            "until",
            format(as.Date(Sys.Date()), "%A, %d-%b. %Y"),".",
            sep = " "
          ),
          x = "Days",
          y = "Number of tweets posted"
        ) +
        ggplot2::theme_minimal() +

        ggplot2::theme(
          axis.title = ggplot2::element_text(size = 12, face = "bold"),
          plot.caption = ggplot2::element_text(size = 10,face = "italic",hjust = 0),

          plot.title = ggplot2::element_text(size = 14,face = "bold"),
          axis.text.x = ggplot2::element_text(size=8),axis.text.y = ggplot2::element_text(size=8)
        ) +
        ggplot2::theme(plot.margin = ggplot2::unit(c(2,10,2,2), "mm"))



    )













    } else  {



        results_tweetdata$created <-
      lubridate::ymd_hms(results_tweetdata$created,
                         tz = Sys.timezone(),
                         quiet = TRUE) %>% lubridate::as_date()



    print(
      results_tweetdata %>%  dplyr::group_by(created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count =
                                                                                                                  n) %>%

        ggplot2::ggplot() +

        ggplot2::geom_line(
          mapping = ggplot2::aes(x = created, count),
          size = 2,
          alpha = 0.8
        ) +


        ggplot2::scale_y_continuous(
          breaks = scales::pretty_breaks(8),
          labels = scales::number_format(accuracy = 1)
        ) +
        ggplot2::labs(
          title =  paste(
            paste("Twitter #", keyword, sep = "")     ,
            "popularity tracking"   ,
            sep = " "
          )    ,


          caption = paste(

            "Note: Daily data (UTC time) fetched from",

            format(as.Date(sinceInput[1]), "%A, %d-%b. %Y")
            ,

            "until",
            format(as.Date(Sys.Date()), "%A, %d-%b. %Y"),".",
            sep = " "
          ),
          x = "Days",
          y = "Number of tweets posted"
        ) +
        ggplot2::theme_minimal() +

        ggplot2::theme(
          axis.title = ggplot2::element_text(size = 12, face = "bold"),
          plot.caption = ggplot2::element_text(size = 10,face = "italic",hjust = 0),

          plot.title = ggplot2::element_text(size = 14,face = "bold"),
          axis.text.x = ggplot2::element_text(size=8),axis.text.y = ggplot2::element_text(size=8)
        ) +
        ggplot2::theme(plot.margin = ggplot2::unit(c(2,10,2,2), "mm"))



    )

#for longer timeframe we aggregate data daily to smooth the variations of the dataset



  }






  #return dataframe results
  return(results_tweetdata)


}

#needed to specify the geocode to avoid getting irrelevant content
#then input this into the twitter search page


#example
result <-
  track_keyword(keyword  = "new york",
                number = 1,
                sincetype = "weeks")

#TO be added to function description file!

#keyword can be any keyword input including having spaces e.g. "stadium san siro"!
#number any number
#sincetype either days, weeks, months, or years

