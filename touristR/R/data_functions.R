library(httr)
library(rlist)
library(jsonlite)
library(plyr)
library(dplyr)
library(vosonSML)
library(tidyverse)
library(tidytext)

 authentication <- Authenticate("twitter", apiKey='L5OKQvggKlNEHlRmTJX6pW7iK',
               apiSecret='TLrIDRv3MbA8BETX2bF0qbOcQzh8OpRZPDAQCmBdMtJ3aUOZef',
               accessToken='1062258817499652096-egjP6aqFRnwbIl0sVDzjvWJTeI1SKQ',
               accessTokenSecret='dI3k2NmkfNu7gWaiVODEgVOwlnYFhC4KSGyTgSchsG92P')



# Function to get hashtag from location names
gethastag <- function(location) {
  paste0("#", tolower(gsub(
    pattern = "[[:punct:]]|[[:space:]]",
    replacement = "", location)))
}

# Function to get data from Tripadvisor
getTripadvisorData <- function(city) {
  tripadvisor_url <-
    paste0("https://www.tripadvisor.com/TypeAheadJson?action=API"
           ,
           "&query=",
           city)
  tripadvisor_url <- gsub(" ", "%20", tripadvisor_url)
  resp <- GET(tripadvisor_url)
  http_type(resp)
  jsonResp <- content(resp, as = "parsed")

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
  resp_data <- fromJSON(data_url , simplifyVector = F)
  resp_df <- ldply (resp_data$attractions, data.frame)
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
getTwitterData <- function(hashtag){
  twitter_data <- tryCatch({
    Collect(credential=authentication,searchTerm=hashtag, numTweets=100,
            writeToFile=FALSE,language="en",verbose=TRUE)
  }, error = function(e) {
  }, finally = {
  })
  if(is.null(twitter_data)){
    return()
  }
  twitter_data$text <- iconv(twitter_data$text,to="utf-8")
  #removing retweets
  twitter_data <- (twitter_data[twitter_data$isRetweet==F,])
  twitter_data
}

# Function to get Sentiment Score
getSentiments<-function(texts){
  len=length(texts)
  print(len)
  twitter_sents=vector("integer",len)
  for (i in 1:len){
    text=texts[i]
    text <- gsub("\\$", "", text)
    tokens <-unnest_tokens(data_frame(text = text),word, text)
    sentiments=inner_join(tokens,get_sentiments("bing"),by="word")
    # pull out only sentiment words
    counts=count(sentiments,sentiment)# count the # of positive & negative words
    spread=spread(counts,sentiment, n, fill = 0)
    # made data wide rather than narrow
    tsentiment=0
    if(dim(spread)[2]>=2) tsentiment = spread$positive - spread$negative
    # of positive words - # of negative owrds
    if(is.null(spread$positive) & !is.null(spread$negative)) tsentiment=
      spread$negative
    if(is.null(spread$negative) & !is.null(spread$positive)) tsentiment=
      spread$positive
    twitter_sents[i]=tsentiment
  }
  twitter_sents
}

getTweetCountAndSentimentScore <- function(hashtag){
  twitter_data <- getTwitterData(hashtag)
  if(is.null(twitter_data)){
    return(0)
  }
  sentiment_score <- mean(getSentiments(twitter_data$text))
  return_list <- list(tweetCount = nrow(twitter_data), sentimentScore =
                        sentiment_score)
  return(return_list)
}

calculateRanking <- function(d){
  q <- quantile(d, c(0.33, 0.67))
  new_vec <- ifelse(d <= q["33%"] , -1, ifelse(d>q["33%"] & d<=q["67%"], 0, 1))
  return(new_vec)
}

# Function to get top N attractions
getTopNAttractions <- function(city, n) {
  top_attractions <- head(getTripadvisorData(city), n)
  # Add sentiments now

  tc <- lapply(top_attractions[["hashtag"]], getTweetCountAndSentimentScore)
  tc_df <- do.call(rbind,tc) %>% as.data.frame()

  top_attractions[["tweetCount"]] <- tc_df$tweetCount
  top_attractions[["popularity"]] <- calculateRanking(unlist(tc_df$tweetCount))
  top_attractions[["sentimentScore"]] <- tc_df$sentimentScore
  top_attractions[["sentiment"]] <- calculateRanking(unlist(tc_df$sentimentScore))

  top_attractions
}


# Example usage:
#getTopNAttractions("paris", 10)


