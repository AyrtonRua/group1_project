

#to be removed
library(magrittr)

keyword <-  c("paris", "milano", "london")

  number <-2


  sincetype <-"weeks"

track_keyword <- function(keyword, number,  sincetype) {
  #accessing Twitter via API
  consumer_key <- 'ugjqg8RGNvuTAL1fEiNtw'
  consumer_secret <- '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I'
  access_token <-
    '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL'
  access_secret <- 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
  twitteR::setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


#keyword is a vector allowing to compare multiple places as a tourist
  # e.g. keyword <- c("paris", "milano", "london")

  #obtain latitude and longitude of the input city/cityName
  #and make a dataframe from its city lat and long


#obtaining latitude and longitude for each place
  df <- data.frame(city=NA, long=NA,lat=NA)

for (i in 1:length(keyword)) {

  df[i,1] <-  keyword[i]

  df[i,2:3] <- ggmap::geocode(location =
                         keyword[i] ,
                       source = "dsk",
                       messaging = FALSE)

}









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



#saving results of foor loop bellow
  keyword_input <-vector(mode = "character", length = length(keyword)) #remove white space
  input <-vector(mode = "character", length = length(keyword)) #adding #


results_twitter = list()  # saving result in a list




#loop query on Twitter
  for (i in 1:length(keyword)) {
    #run query for that keyword (format is #... without any space)
    #first we remove any white space to obtain oneword input
    keyword_input[i] <-
      gsub(keyword[i], pattern = " ", replacement = "")
    #then we obtain the #oneword format to be used as input for the Twitter query
    input[i] <- paste("#", keyword_input[i], sep = "")




    #number of tweeets per keyword obtained
    n=10
    #query Twitter using the keyword input
    results_twitter[[i]] <-   twitteR::searchTwitter(
      input[i] ,
      n = n,
      resultType = "mixed",
      since =   sinceInput[1]  ,
      until = lubridate::today(tzone = Sys.timezone()) %>% lubridate::ymd() %>% as.character()  ,

      #specifying the geocode to be sure we only obtain e.g. indeed
      #the results published from Paris for search query Paris (tweet should
      #be made within a radius of 40 miles from Paris maximum)

      geocode = paste(df[i, ]$lat, df[i, ]$long, "40mi", sep = ",")


    )



}


  #saving search query results in a dataframe
  results_tweetdata <-
    twitteR::twListToDF(results_twitter %>% unlist()) %>% tibble::as.tibble()


#PROBLEM FROM HERE TO GET KEYWORD NAME



#PROBLEM FROM HERE TO GET KEYWORD NAME











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

            dplyr::group_by(city, created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count =
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

        dplyr::group_by(city, created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count =
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













    }
  else  {



        results_tweetdata$created <-
      lubridate::ymd_hms(results_tweetdata$created,
                         tz = Sys.timezone(),
                         quiet = TRUE) %>% lubridate::as_date()



    print(
      results_tweetdata %>%  dplyr::group_by(city,created) %>% dplyr::count() %>% dplyr::arrange() %>% dplyr::rename(count =
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






  #return dataframe results as well
  return(results_tweetdata)


}

#needed to specify the geocode to avoid getting irrelevant content
#then input this into the twitter search page


#example to be removed at the end =>keep only function and #' (document it ) in this file
result <-
  track_keyword(keyword  = c("new york","milano", "sidney"),
                number = 1,
                sincetype = "weeks")

#TO be added to function description file!

#keyword can be any keyword of a you place you would like to visit / input including having spaces e.g. "stadium san siro"
#number any number
#sincetype either days, weeks, months, or years

