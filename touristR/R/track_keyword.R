#' @title track_keyword
#'
#' @description Provide a timeline plot of keyword counts based on data obtained
#' from Twitter.
#'
#' @param keyword A character vector of maximum length 4 (keywords requested)
#' @param number An integer value (Timeframe parameter)
#' @param sincetype A character (Timeframe parameter) can be (uniquely)
#' on of the following: either "days", "weeks", "months" or "years"
#'
#' @param provideN An integer value
#' (Number ot tweets to fectch for each keyword)
#'
#' @return A timeseries scatter plot with the keyword count
#' for each requested keyword.
#' @return A dataframe containing all results fetched from Twitter (e.g. tweets)
#' based on package \code{\link{twitteR}}
#'
#' @author Ayrton Rua: \email{ayrton.gomesmartinsrua@unil.ch}
#' @author Maurizio Griffo: \email{maurizio.griffo@unil.ch}
#' @author Ali Karray: \email{mohamedali.karray@unil.ch}
#' @author Mohit Mehrotra: \email{mohit.mehrotra@unil.ch}
#' @author Youness Zarhloul: \email{youness.zarhloul@unil.ch}
#'
#' @references Orso, S., Molinari, R., Lee,
#' J., Guerrier, S., & Beckman, M. (2018).
#' An Introduction to Statistical Programming Methods with R.
#' Retrieved from \url{https://smac-group.github.io/ds/}
#'
#' @seealso \code{\link{touristR} & \link{run_shiny}}
#'
#' @examples \dontrun{track_keyword(
#' keyword = c("eiffel tower", "san francisco", "london"),
#' number = 2,
#' sincetype = "weeks",
#' provideN = 100
#' )
#' }
#'
#' @details The function automatically obtains the latitude and longitude of
#' each requested place,then query the Twitter API to obtain the number of
#' tweets with the requested # keywords for the desired timeframe, and returns
#' finally at the end a \code{\link{ggplot2}} scatterplot,
#' allowing thus to analyze which places are the most popular
#' over a given time period. \cr
#' It should be noted in that sense that if the time frame selected by the user
#' is less than or equal to 2 weeks, the plot returned groups data by hour,
#' whereas if the user requests longer timeframes the result will be grouped by
#' days for better representation of the changes over time (short/long term). \cr \cr
#' Lastly, we advise the user to keep the parameter \code{provideN} short
#' to avoid long delay responses from Twitter API (e.g. setting provideN=100
#' would be preferable than 1000)
#'
#' @importFrom magrittr %>%
#'
#' @export
track_keyword <- function(keyword, number,  sincetype, provideN) {
  if (length(keyword) > 4) {
    stop("Please input maximum 4 keywords!")

  } else{
    #accessing Twitter via API
    consumer_key <- 'ugjqg8RGNvuTAL1fEiNtw'
    consumer_secret <- '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I'
    access_token <-
      '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL'
    access_secret <-
      'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
    #
    twitteR::setup_twitter_oauth(consumer_key,
                                 consumer_secret,
                                 access_token,
                                 access_secret)


    #keyword is a vector allowing to compare multiple places as a tourist
    # e.g. keyword <- c("paris", "milano", "london")

    #obtain latitude and longitude of the input city/cityName
    #and make a dataframe from its city lat and long


    #obtaining latitude and longitude for each place
    df <- data.frame(city = NA,
                     long = NA,
                     lat = NA)

    for (i in 1:length(keyword)) {
      df[i, 1] <-  keyword[i]

      df[i, 2:3] <- ggmap::geocode(location =
                                     keyword[i] ,
                                   source = "dsk",
                                   messaging = FALSE)

    }









    #saving the result of the function
    sinceInput <- vector(mode = "character", length = 1L)
    #adapting date (since) input


    if (sincetype == "days") {
      sinceInput[1] <-
        (lubridate::today(tzone = Sys.timezone()) -
           lubridate::days(number)) %>%
        lubridate::ymd() %>% as.character()



    } else if (sincetype == "weeks") {
      sinceInput[1] <-
        (lubridate::today(tzone = Sys.timezone()) -
           lubridate::weeks(number)) %>% lubridate::ymd() %>% as.character()



    } else if (sincetype == "months") {
      #time difference in months (respecting e.g. months with 30 and 31 days)
      sinceInput[1] <-
        (lubridate::today(tzone = Sys.timezone())   -
           lubridate::period(1, units = "month")) %>%
        lubridate::ymd() %>% as.character()



    } else if (sincetype == "years") {
      sinceInput[1] <-
        (lubridate::today(tzone = Sys.timezone())  -
           lubridate::years(number)) %>%
        lubridate::ymd() %>% as.character()



    }



    #saving results of for loop bellow
    keyword_input <-
      vector(mode = "character", length = length(keyword)) #remove white space
    input <-
      vector(mode = "character", length = length(keyword)) #adding #


    results_twitter = list()  # saving result in a list

    #number of tweeets per keyword obtained
    #provideN

    #loop query on Twitter
    for (i in 1:length(keyword)) {
      #run query for that keyword (format is #... without any space)
      #first we remove any white space to obtain oneword input
      keyword_input[i] <-
        gsub(keyword[i], pattern = " ", replacement = "")
      #then we obtain the #oneword format to be used as input for
      #the Twitter query
      input[i] <- paste("#", keyword_input[i], sep = "")




      #query Twitter using the keyword input
      results_twitter[[i]] <-   twitteR::searchTwitter(
        input[i] ,
        n = provideN,
        resultType = "mixed",
        since =   sinceInput[1]  ,
        until = lubridate::today(tzone = Sys.timezone()) %>%
        lubridate::ymd() %>% as.character()  ,

        #specifying the geocode to be sure we only obtain e.g. indeed
        #the results published from Paris for search query Paris (tweet should
        #be made within a radius of 60 miles from Paris maximum)

        geocode = paste(df[i,]$lat, df[i,]$long, "60mi", sep = ",")


      )
      #saving search query results in a dataframe each one for 1 city

    }
    if (length(keyword) == 4) {
      results_twitter1 <-
        results_twitter[[1]] %>% unlist()  %>% twitteR::twListToDF() %>%
        tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[1])

      results_twitter2 <-
        results_twitter[[2]] %>% unlist()  %>% twitteR::twListToDF() %>%
        tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[2])

      results_twitter3 <-
        results_twitter[[3]] %>% unlist()  %>% twitteR::twListToDF() %>%
        tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[3])

      results_twitter4 <-
        results_twitter[[4]] %>% unlist()  %>% twitteR::twListToDF() %>%
        tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[4])


      finaldata <-
        rbind(results_twitter1,
              results_twitter2,
              results_twitter3,
              results_twitter4)


    } else if (length(keyword) == 3) {
      results_twitter1 <-
        results_twitter[[1]] %>% unlist()  %>% twitteR::twListToDF() %>%
        tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[1])

      results_twitter2 <-
        results_twitter[[2]] %>% unlist()  %>% twitteR::twListToDF() %>%
        tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[2])

      results_twitter3 <-
        results_twitter[[3]] %>% unlist()  %>% twitteR::twListToDF() %>%
        tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[3])


      finaldata <-
        rbind(results_twitter1, results_twitter2, results_twitter3)

    } else if (length(keyword) == 2) {
      results_twitter1 <-
        results_twitter[[1]] %>% unlist()  %>%
        twitteR::twListToDF() %>% tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[1])

      results_twitter2 <-
        results_twitter[[2]] %>% unlist()  %>%
        twitteR::twListToDF() %>% tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[2])


      finaldata <- rbind(results_twitter1, results_twitter2)


    } else if (length(keyword) == 1) {
      results_twitter1 <-
        results_twitter[[1]] %>% unlist()  %>%
        twitteR::twListToDF() %>% tibble::as.tibble() %>%
        dplyr::mutate(city = keyword[1])


      finaldata <- results_twitter1


    }







    #creating the plot of keyword count per day over time
    #(measure of popularity)



    if (sincetype == "days" &&  number <= 14) {
      #correct date format and keep it with seconds to have a very specific
      #time precision level e.g. to be used during marketing campaigns
      #to identify the time slots where users post the most about a
      #given keywork
      #e.g. to optimize when to run an ad during the day
      #(when people interact/engage
      #the most with our keyword=>more engagement increases the
      #visibility of the company)
      #and for a tourist useful to know e.g. what is the
      #current hot spot e.g. coffee shop to go to now

      #a resaonable time frame to aggregate results is hours in that sense


      finaldata$created <-
        lubridate::ymd_hms(finaldata$created,
                           tz = Sys.timezone(),
                           quiet = TRUE) %>%
        lubridate::round_date(unit =  "hour")



      #plot

      finaldata$created_correct <-
        base::as.POSIXct(base::format(finaldata$created, "%Y-%m-%d %H:%M:%S"),
                         format = "%Y-%m-%d %H")

      print(
        finaldata %>%

          dplyr::group_by(city, created_correct) %>% dplyr::count() %>%
          dplyr::arrange() %>%
          dplyr::rename(count = n) %>%




          ggplot2::ggplot() +

          ggplot2::geom_point(
            mapping = ggplot2::aes(x = created_correct, count , color = city),
            size = 3,
            alpha = 0.8
          ) +

          ggplot2::geom_line(
            ggplot2::aes(x = created_correct, count , color = city),
            size = 0.5
          )   +

          ggplot2::scale_y_continuous(
            breaks = scales::pretty_breaks(8),
            labels = scales::number_format(accuracy = 1)
          ) +


          ggplot2::labs(
            title = "Twitter keyword popularity tracking",

            caption = paste(
              "Note: Hourly data (UTC time) fetched from",

              format(as.Date(sinceInput[1]), "%A, %d-%b. %Y")  ,

              "until",
              format(as.Date(Sys.Date()), "%A, %d-%b. %Y"),
              ".",
              sep = " "
            ),
            x = "Days",
            y = "Number of tweets posted"
          ) +
          ggplot2::theme_minimal() +

          ggplot2::theme(
            axis.title = ggplot2::element_text(size = 12, face = "bold"),
            plot.caption = ggplot2::element_text(
              size = 10,
              face = "italic",
              hjust = 0
            ),

            plot.title = ggplot2::element_text(size = 14, face = "bold"),
            axis.text.x = ggplot2::element_text(
              size = 8,
              angle = 25,
              vjust = 1.0,
              hjust = 1.0
            ),
            axis.text.y = ggplot2::element_text(size = 8)

          ) +
          ggplot2::theme(plot.margin = ggplot2::unit(c(2, 10, 2, 2), "mm")) +
          viridis::scale_color_viridis(
            discrete = TRUE ,
            direction =  -1,
            alpha = 0.6
          ) +
          ggplot2::scale_x_datetime(
            labels = scales::date_format("%b %d - %H:%M"),
            breaks = scales::date_breaks("5 hour")
          ) +


          ggrepel::geom_text_repel(
            data = finaldata %>%

              dplyr::group_by(city, created_correct) %>%
              dplyr::count() %>% dplyr::arrange(desc(n)) %>%
              dplyr::filter(created_correct == lubridate::today()) %>%
              dplyr::rename(count = n) %>%
              dplyr::top_n(length(keyword))   ,




            ggplot2::aes(x = created_correct,


                         count , label = factor(city))
            ,
            fontface = 'bold',
            color = 'black',
            box.padding = 1,
            point.padding = 1,
            segment.color = 'black' ,
            size = 4
          ) + ggplot2::guides(color = ggplot2::guide_legend(title = "Place"))



      )




    } else
      if (sincetype == "weeks" && number < 3) {
        #correct date format and keep it with seconds to have a very specific
        #time precision level e.g. to be used during marketing campaigns
        #to identify the time slots where users post the most about a given
        #keywork
        #e.g. to optimize when to run an ad during the day
        #(when people interact/engage
        #the most with our keyword=>more engagement increases the visibility
        #of the company)
        #and for a tourist useful to know e.g. what is the current
        #hot spot e.g. coffee shop to go to now

        #a resaonable time frame to aggregate results is hours in that sense

        #correct date format
        finaldata$created <-
          lubridate::ymd_hms(finaldata$created,
                             tz = Sys.timezone(),
                             quiet = TRUE) %>%
          lubridate::round_date(unit =  "hour")


        finaldata$created_correct <-
          base::as.POSIXct(base::format(finaldata$created, "%Y-%m-%d %H:%M:%S"),
                           format = "%Y-%m-%d %H")





        #plot


        print(
          finaldata %>%

            dplyr::group_by(city, created_correct) %>%
            dplyr::count() %>% dplyr::arrange() %>%
            dplyr::rename(count = n) %>%




            ggplot2::ggplot() +

            ggplot2::geom_point(
              mapping = ggplot2::aes(x = created_correct, count , color = city),
              size = 3,
              alpha = 0.8
            ) +

            ggplot2::geom_line(
              ggplot2::aes(x = created_correct, count , color = city),
              size = 0.5
            )   +

            ggplot2::scale_y_continuous(
              breaks = scales::pretty_breaks(8),
              labels = scales::number_format(accuracy = 1)
            ) +


            ggplot2::labs(
              title = "Twitter keyword popularity tracking",

              caption = paste(
                "Note: Hourly data (UTC time) fetched from",

                format(as.Date(sinceInput[1]), "%A, %d-%b. %Y")  ,

                "until",
                format(as.Date(Sys.Date()), "%A, %d-%b. %Y"),
                ".",
                sep = " "
              ),
              x = "Days",
              y = "Number of tweets posted"
            ) +
            ggplot2::theme_minimal() +

            ggplot2::theme(
              axis.title = ggplot2::element_text(size = 12, face = "bold"),
              plot.caption = ggplot2::element_text(
                size = 10,
                face = "italic",
                hjust = 0
              ),

              plot.title = ggplot2::element_text(size = 14, face = "bold"),
              axis.text.x = ggplot2::element_text(
                size = 8,
                angle = 25,
                vjust = 1.0,
                hjust = 1.0
              ),
              axis.text.y = ggplot2::element_text(size = 8)

            ) +
            ggplot2::theme(plot.margin = ggplot2::unit(c(2, 10, 2, 2), "mm")) +
            viridis::scale_color_viridis(
              discrete = TRUE ,
              direction =  -1,
              alpha = 0.6
            ) +
            ggplot2::scale_x_datetime(
              labels = scales::date_format("%b %d - %H:%M"),
              breaks = scales::date_breaks("5 hour")
            ) +


            ggrepel::geom_text_repel(
              data = finaldata %>%

                dplyr::group_by(city, created_correct) %>%
                dplyr::count() %>%
                dplyr::arrange(desc(n)) %>%
                dplyr::filter(created_correct == lubridate::today()) %>%
                dplyr::rename(count = n) %>%
                dplyr::top_n(length(keyword))   ,




              ggplot2::aes(x = created_correct,


                           count , label = factor(city))
              ,
              fontface = 'bold',
              color = 'black',
              box.padding = 1,
              point.padding = 1,
              segment.color = 'black' ,
              size = 4
            ) + ggplot2::guides(color = ggplot2::guide_legend(title = "Place"))



        )













      }
    else  {
      finaldata$created <-
        lubridate::ymd_hms(finaldata$created,
                           tz = Sys.timezone(),
                           quiet = TRUE) %>% lubridate::as_date()


      finaldata$created_correct <-
        base::as.POSIXct(base::format(finaldata$created, "%Y-%m-%d"), format =
                           "%Y-%m-%d")


      print(
        finaldata %>%

          dplyr::group_by(city, created_correct) %>% dplyr::count() %>%
          dplyr::arrange() %>%
          dplyr::rename(count = n) %>%




          ggplot2::ggplot() +

          ggplot2::geom_point(
            mapping = ggplot2::aes(x = created_correct, count , color = city),
            size = 3,
            alpha = 0.8
          ) +

          ggplot2::geom_line(
            ggplot2::aes(x = created_correct, count , color = city),
            size = 0.5
          )   +

          ggplot2::scale_y_continuous(
            breaks = scales::pretty_breaks(8),
            labels = scales::number_format(accuracy = 1)
          ) +


          ggplot2::labs(
            title = "Twitter keyword popularity tracking",

            caption = paste(
              "Note: Daily data (UTC time) fetched from",

              format(as.Date(sinceInput[1]), "%A, %d-%b. %Y")  ,

              "until",
              format(as.Date(Sys.Date()), "%A, %d-%b. %Y"),
              ".",
              sep = " "
            ),
            x = "Days",
            y = "Number of tweets posted"
          ) +
          ggplot2::theme_minimal() +

          ggplot2::theme(
            axis.title = ggplot2::element_text(size = 12, face = "bold"),
            plot.caption = ggplot2::element_text(
              size = 10,
              face = "italic",
              hjust = 0
            ),

            plot.title = ggplot2::element_text(size = 14, face = "bold"),
            axis.text.x = ggplot2::element_text(
              size = 8,
              angle = 25,
              vjust = 1.0,
              hjust = 1.0
            ),
            axis.text.y = ggplot2::element_text(size = 8)

          ) +
          ggplot2::theme(plot.margin = ggplot2::unit(c(2, 10, 2, 2), "mm")) +
          viridis::scale_color_viridis(
            discrete = TRUE ,
            direction =  -1,
            alpha = 0.6
          ) +
          ggplot2::scale_x_datetime(
            labels = scales::date_format("%b %d"),
            breaks = scales::date_breaks("5 hour")
          ) +


          ggrepel::geom_text_repel(
            data = finaldata %>%

              dplyr::group_by(city, created_correct) %>%
              dplyr::count() %>%
              dplyr::arrange(desc(n)) %>%
              dplyr::filter(created_correct == lubridate::today()) %>%
              dplyr::rename(count =     n) %>%
              dplyr::top_n(length(keyword))   ,




            ggplot2::aes(x = created_correct,


                         count , label = factor(city))
            ,
            fontface = 'bold',
            color = 'black',
            box.padding = 1,
            point.padding = 1,
            segment.color = 'black' ,
            size = 4
          ) + ggplot2::guides(color = ggplot2::guide_legend(title = "Place"))



      )

      #for longer timeframe we aggregate data daily to smooth the
      #variations of the dataset
      #for short timeframes (less or equal than 2 weeks) we aggregate data
      #hourly for better representation of the short term variations




    }






    #return dataframe results as well
    return(finaldata)


  }


}

