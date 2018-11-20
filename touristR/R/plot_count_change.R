


plot_count_change <- function(keyword) {



  # load required libraries/throw an error message if not possible
  # convert arguments to vector
  packages <- c("tidyverse", "twitteR","scales")
  #package "latex2exp" allows to add Latex math symbols to the plot

  # start loop to determine if each package is installed
  for (package in packages) {
    # if package is installed locally, load
    if (package %in% rownames(installed.packages()))
    {
      do.call('library', list(package))

      # if package is not installed locally, throw error message
    } else {
      stop(
        cat("Please make sure that all the following packages are installed: ",
            packages, sep = "\n"))
    }

  }





library(twitteR)
  consumer_key <- 'ugjqg8RGNvuTAL1fEiNtw'
  consumer_secret <- '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I'
  access_token <- '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL'
  access_secret <- 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
  options(httr_oauth_cache=TRUE)

  setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


  hashtag <- paste( "#",keyword , sep="")


 searchTwitter(

   hashtag, n=10,lang = "en",resultType="mixed"),


  since= lubridate::ymd(Sys.Date()),
 #
     until= (lubridate::ymd(Sys.Date()) -30)





}
#needed to specify the geocode to avoid getting irrelevant content
#then input this into the twitter search page



plot_count_change(london)

