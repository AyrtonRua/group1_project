


library(twitteR)

consumer_key <- 'ugjqg8RGNvuTAL1fEiNtw'
consumer_secret <- '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I'
access_token <- '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL'
access_secret <- 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

tweets_g <- searchTwitter("#google", n=10,lang = "en")
