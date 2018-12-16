#' @title getTopNAttractions
#'
#' @description Provide a dataframe containing the data about the top N
#' attractions for a certain city requested by the user,
#' combining hot spot search from Tripadvisor and obtaining relevant data
#' from Twitter (e.g. sentiments about a certain place).
#'
#' @param city A character \code{vector} of length 1 (city requested; the input
#' should not contain any special punctuation marks, and written in English)
#' @param n A positive \code{integer} number (number of top spots to get for
#' the requested city)
#'
#' @return A dataframe containing all results fetched from Tripadvisor
#' and Twitter regarding the top attractions in the chosen city
#' (e.g. popularity level).
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
#' @seealso \code{\link{touristR}} & \code{\link{run_shiny}}
#'
#' @examples \dontrun{getTopNAttractions(
#' city = "london",
#' n = 10
#' )
#' }
#'
#' @details The function automatically obtains the most relevant places
#' for the selected city  based on a search on Tripdadvisor, then queries
#' Twitter about each hot spot (e.g. monument). \cr
#' Afterwards it runs a sentiment analysis on those selected N top attractions,
#' and also measures the popularity of the place
#' (using the count of the number of tweets mentioning the #place).  \cr  \cr
#' The function returns as a result a dataframe containing all the relevant
#' information about the top spots in that city combining in that sense also
#' live reviews from Twitter users, which can then be plotted interactively on a
#' Shiny map as well \code{\link{run_Shiny}}.
#'
#' @importFrom magrittr %>%
#'
#' @export
getTopNAttractions <- function(city, n) {
  #Authenticate
  authentication <-
    vosonSML::Authenticate(
      "twitter",
      apiKey = "QGkK4T5I6IsOFsM7UokyM1pGC",
      apiSecret = "jnZx2Lg0mNEuEDPX9g4ydi7z5Rt7WothdWYfp5q6vtGXzqdQqO",
      accessToken = "1688753005-kAy1jHIirZkGlIoUlIggzsuwIae2EgyA7XJ8gFQ",
      accessTokenSecret = "y3ZzJun64BaAYekFK7jybZeloGQ3J54iOkdA0aI0vomM7"
    )


  # Function to get hashtag from location names
  gethastag <- function(location) {
    paste0("#", tolower(
      gsub(pattern = "[[:punct:]]|[[:space:]]",
           replacement = "", location)
    ))
  }

  # Function to get data from Tripadvisor
  getTripadvisorData <- function(city) {
    tripadvisor_url <-
      paste0("https://www.tripadvisor.com/TypeAheadJson?action=API"
             ,
             "&query=",
             city)
    tripadvisor_url <- gsub(" ", "%20", tripadvisor_url)
    resp <- httr::GET(tripadvisor_url)
    httr::http_type(resp)
    jsonResp <- httr::content(resp, as = "parsed")

    modJson <- jsonResp$results[[1]]
    city_id <- modJson$document_id

    data_url <-
      paste0(
        "https://www.tripadvisor.co.uk/GMapsLocationController?Actio"
        ,
        "n=update&g=",
        city_id,
        "&mz=10&mw=1400&mh=420&pinSel=v2"
      )
    resp_data <- jsonlite::fromJSON(data_url , simplifyVector = F)
    resp_df <- plyr::ldply (resp_data$attractions, data.frame)
    latlng_df <- resp_df[c("customHover.title", "lat", "lng")]

    latlng_df <-
      data.frame(lapply(latlng_df, function(x) {
        gsub("\\", "", x, fixed = TRUE)
      }))
    latlng_df <-
      data.frame(lapply(latlng_df, function(x) {
        gsub("&amp", "&", x, fixed = TRUE)
      }))

    names(latlng_df) <- c("name", "lat", "lng")
    latlng_df[["hashtag"]] <- gethastag(latlng_df[["name"]])

    latlng_df
  }


  # Function to get Twitter Data
  # example - twitterData <- getTwitterData("#eiffeltower")
  getTwitterData <- function(hashtag) {
    twitter_data <- tryCatch({
      vosonSML::Collect(
        credential = authentication,
        searchTerm = hashtag,
        numTweets = 300,
        writeToFile = FALSE,
        language = "en",
        verbose = TRUE
      )
    }, error = function(e) {

    }, finally = {

    })
    if (is.null(twitter_data)) {
      return()
    }
    twitter_data$text <- iconv(twitter_data$text, to = "utf-8")
    #removing retweets
    twitter_data <- (twitter_data[twitter_data$isRetweet == F,])
    twitter_data
  }

  # Function to get Sentiment Score
  getSentiments <- function(texts) {
    len = length(texts)
    print(len)
    twitter_sents = vector("integer", len)
    for (i in 1:len) {
      text = texts[i]
      text <- gsub("\\$", "", text)
      tokens <-
        tidytext::unnest_tokens(tibble::data_frame(text = text), word, text)
      sentiments = dplyr::inner_join(tokens, tidytext::get_sentiments("bing"),
                                     by = "word")
      # pull out only sentiment words
      counts = dplyr::count(sentiments, sentiment)# count the # of
      #positive & negative words
      spread = tidyr::spread(counts, sentiment, n, fill = 0)
      # made data wide rather than narrow
      tsentiment = 0
      if (dim(spread)[2] >= 2)
        tsentiment = spread$positive - spread$negative
      # of positive words - # of negative owrds
      if (is.null(spread$positive) &
          !is.null(spread$negative))
        tsentiment =
        spread$negative
      if (is.null(spread$negative) &
          !is.null(spread$positive))
        tsentiment =
        spread$positive
      twitter_sents[i] = tsentiment
    }
    twitter_sents
  }

  getTweetCountAndSentimentScore <- function(hashtag) {
    twitter_data <- getTwitterData(hashtag)
    if (is.null(twitter_data)) {
      return(0)
    }
    sentiment_vector <- getSentiments(twitter_data$text)
    sentiment_score <- mean(sentiment_vector[sentiment_vector != 0])

    if (is.nan(sentiment_score))
      sentiment_score <- 0

    return_list <-
      list(tweetCount = nrow(twitter_data),
           sentimentScore =
             sentiment_score)
    return(return_list)
  }

  calculateRelativeRanking <- function(d) {
    q <- quantile(d, c(0.33, 0.67))
    new_vec <-
      ifelse(d <= q["33%"] , -1, ifelse(d > q["33%"] &
                                          d <= q["67%"], 0, 1))
    return(new_vec)
  }

  calculateAbsoluteRanking <- function(d) {
    new_vec <-
      ifelse(d <= -2 , -1, ifelse(d > -2 &
                                    d <= 1.5, 0, 1))
    return(new_vec)
  }

  top_attractions <- head(getTripadvisorData(city), n)
  # Add sentiments now

  tc <-
    lapply(top_attractions[["hashtag"]], getTweetCountAndSentimentScore)
  tc_df <- do.call(rbind, tc) %>% as.data.frame()

  top_attractions[["tweetCount"]] <- tc_df$tweetCount
  top_attractions[["popularity"]] <-
    calculateRelativeRanking(unlist(tc_df$tweetCount))
  top_attractions[["sentimentScore"]] <- tc_df$sentimentScore
  top_attractions[["sentimentRelative"]] <-
    calculateRelativeRanking(unlist(tc_df$sentimentScore))
  top_attractions[["sentimentAbsolute"]] <-
    calculateAbsoluteRanking(unlist(tc_df$sentimentScore))

  top_attractions
}
