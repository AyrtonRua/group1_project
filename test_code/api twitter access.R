


library(twitteR)

consumer_key <- 'L5OKQvggKlNEHlRmTJX6pW7iK'
consumer_secret <- 'TLrIDRv3MbA8BETX2bF0qbOcQzh8OpRZPDAQCmBdMtJ3aUOZef'
access_token <- '1062258817499652096-egjP6aqFRnwbIl0sVDzjvWJTeI1SKQ'
access_secret <- 'dI3k2NmkfNu7gWaiVODEgVOwlnYFhC4KSGyTgSchsG92P'
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

tweets_g <- searchTwitter("#google", n=10,lang = "en")
tweets_g
