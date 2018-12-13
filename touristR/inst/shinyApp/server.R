library("magrittr")

shiny::shinyServer(function(input, output, session) {
  twitterdata <- shiny::reactive({
    #obtain the dataframe containing the top places for the requested city
    twitterfetch <-
      touristR::getTopNAttractions(as.character(input$choosecity), 2)
    #correcting the levels and format of the  fetched data
    twitterfetch <-
      data.frame(lapply(twitterfetch, function(x)
        unlist(x)))
    twitterfetch$lat <-
      as.numeric(levels(twitterfetch$lat))[twitterfetch$lat]
    twitterfetch$lng <-
      as.numeric(levels(twitterfetch$lng))[twitterfetch$lng]
    twitterfetch$name <-
      as.character(levels(twitterfetch$name))[twitterfetch$name]
    twitterfetch$hashtag <-
      as.character(levels(twitterfetch$hashtag))[twitterfetch$hashtag]
    #set the color depending on the sentiment level (value)
    #sentiment absolute setting colors
    twitterfetch <-
      twitterfetch %>% dplyr::mutate("sentimentcolorabsolute" =

                                       ifelse(
                                         sentimentAbsolute == 1,
                                         "green",
                                         ifelse(sentimentAbsolute == 0,
                                                "orange",
                                                "red")
                                       ))
    #sentiment relative setting colors
    twitterfetch <-
      twitterfetch %>% dplyr::mutate("sentimentcolorrelative" =

                                       ifelse(
                                         sentimentRelative == 1,
                                         "green",
                                         ifelse(sentimentRelative == 0,
                                                "orange",
                                                "red")
                                       ))

    twitterfetch <- twitterfetch %>% dplyr::mutate("radius" =
                                                     ifelse(popularity == 1,
                                                            40,
                                                            ifelse(
                                                              popularity == 0,
                                                                   25,
                                                                   10)))

    return(twitterfetch)

  })
  #obtaining the latitude and longitude of the requested city
  geotag <- shiny::reactive({
    geotag <- ggmap::geocode(location =
                               as.character(input$choosecity),
                             source = "dsk") %>% as.data.frame()
  })
  #rendering the map, depending on the checkbox selection (if checked
  #displays relative sentiment analysis/colors, if unchecked, the default
  #behaviour displays absolute sentiment analysis/colors)
  output$mymap <- leaflet::renderLeaflet({
    if (input$checkbox == FALSE) {
      plot_checkboxFALSE <-    leaflet::leaflet() %>%
        leaflet::addTiles()  %>%
        #add a minimap (on the bottom right)
        leaflet::addMiniMap(
          zoomLevelFixed = 5,
          height = 100,
          toggleDisplay = TRUE,
          minimized = FALSE
        ) %>%
        #add a button to locate the user(needed permission of the user and
        #opening the app in an external browser such as Google Chrome)
        leaflet::addEasyButton(
          leaflet::easyButton(
            icon = "fa-crosshairs",
            title = "Locate Me",
            onClick = htmlwidgets::JS("function(btn, map){
                                      map.locate({setView: true}); }")
          )
        ) %>%
        #focus the geotag on the selected city as a whole
        leaflet::setView(lng = geotag()$lon[1]  ,
                         lat =  geotag()$lat[1] ,
                         zoom = 13) %>%
        #add markers in the map (colored based on the sentiment analysis)
        #(size of the circles based on the tweet counts)
        leaflet::addAwesomeMarkers(
          lng = twitterdata()$lng,
          lat = twitterdata()$lat,
          #add custom map marker icons
          icon = leaflet::awesomeIcons(
            icon = 'glyphicon glyphicon-map-marker',
            iconColor = 'black',
            library = 'glyphicon',
            markerColor = twitterdata()$sentimentcolorabsolute
          ),
          #displays a popup with the name of the place
          popup =  twitterdata()$name,
          #displays a label with the name of the place (on hover)
          label =  twitterdata()$name,
          #cluster results in the map for better readability
          clusterOptions = leaflet::markerClusterOptions(
            #specify custom style for the clustering circles (e.g. color)
            iconCreateFunction =
              htmlwidgets::JS(
                "
                function(cluster) {
                return new L.DivIcon({
                html: '<div style=\"background-color:
                rgba(77,77,77,0.5)\"><span>' +
                cluster.getChildCount() +
                '</div><span>',
                className: 'marker-cluster'
                });
                }"
              )
          ),
          #id of the cluster elements
          clusterId = "Places"
        ) %>%

        #add circle markers
        #radius defined based on the popularity (count of tweets for that place)
        leaflet::addCircleMarkers(
          #longitude specification
          lng = twitterdata()$lng,
          #latitude specification
          lat = twitterdata()$lat,
          #color of the cicles (based on absolute sentiment)
          color =  twitterdata()$sentimentcolorabsolute,
          #radius of the circle, defined based on the tweets counts
          #provides a measure of popularitiy of a place
          radius =  twitterdata()$radius
        )
      plot_checkboxFALSE
      #if checkbox (Sentiment relative?) is checked
    } else if (input$checkbox == TRUE) {
      plot_checkboxTRUE <-    leaflet::leaflet() %>%
        #add a minimap (on the bottom right)
        leaflet::addTiles()  %>%  leaflet::addMiniMap(
          zoomLevelFixed = 5,
          height = 100,
          toggleDisplay = TRUE,
          minimized = FALSE
        ) %>%
        #add a button to locate the user(needed permission of the user and
        #opening the app in an external browser such as Google Chrome)
        leaflet::addEasyButton(
          leaflet::easyButton(
            icon = "fa-crosshairs",
            title = "Locate Me",
            onClick = htmlwidgets::JS("function(btn, map){
                                    map.locate({setView: true}); }")
          )
        ) %>%
        #focus the geotag on the selected city as a whole
        leaflet::setView(lng = geotag()$lon[1]  ,
                         lat =  geotag()$lat[1] ,
                         zoom = 13) %>%
        #add markers in the map (colored based on the sentiment analysis)
        #(size of the circles based on the tweet counts)
        leaflet::addAwesomeMarkers(
          lng = twitterdata()$lng,
          lat = twitterdata()$lat,
          #add custom map marker icons
          icon = leaflet::awesomeIcons(
            icon = 'glyphicon glyphicon-map-marker',
            iconColor = 'black',
            library = 'glyphicon',
            markerColor = twitterdata()$sentimentcolorrelative
          ),
          #displays a popup with the name of the place
          popup = twitterdata()$name,
          #displays a label with the name of the place (on hover)
          label = twitterdata()$name,
          #cluster results in the map for better readability
          clusterOptions = leaflet::markerClusterOptions(
            #specify custom style for the clustering circles (e.g. color)
            iconCreateFunction =
              htmlwidgets::JS(
                "
              function(cluster) {
              return new L.DivIcon({
              html: '<div style=\"background-color:
              rgba(77,77,77,0.5)\"><span>' +
              cluster.getChildCount() +
              '</div><span>',
              className: 'marker-cluster'
              });
              }"
              )

          ),
          #id of the cluster elements
          clusterId = "Places"
        ) %>%
        #add circle markers
        #radius defined based on the popularity (count of tweets for that place)
        leaflet::addCircleMarkers(
          #longitude specification
          lng = twitterdata()$lng,
          #latitude specification
          lat = twitterdata()$lat,
          #color of the cicles (based on absolute sentiment)
          color =  twitterdata()$sentimentcolorrelative,
          #radius of the circle, defined based on the tweets counts
          #provides a measure of popularitiy of a place
          radius =  twitterdata()$radius
        )

      plot_checkboxTRUE

    }

  })

  #Authenticate to twitter
  authentication <-
    vosonSML::Authenticate(
      "twitter",
      apiKey = 'ugjqg8RGNvuTAL1fEiNtw',
      apiSecret = '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I',
      accessToken =  '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL',
      accessTokenSecret = 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
    )
  #query Twitter for the selected city (in #) to obtain
  #the dataframe containing the requested city tweets
  twitter_comment_city <- shiny::reactive({
    twitter_comment_city <-   twitteR::searchTwitter(
      #paste the city as e.g. #london
      searchString = paste("#",  input$choosecity , sep = "") ,
      #obtain only tweets in English
      lang = "en",
      #100 tweets requested for the input city
      n = 100,
      #obtain a mix of popular and new tweets over the requested timeframe
      resultType = "mixed",
      #specify the timeframe
      #since past 2 weeks
      since =  (
        lubridate::today(tzone = Sys.timezone()) %>%
          lubridate::ymd() - 14
      )     %>% as.character()    ,
      #until today
      until = lubridate::today(tzone = Sys.timezone()) %>%
        lubridate::ymd() %>% as.character()  ,
      #specifying the geocode to be sure we only obtain e.g. indeed
      #the results published from Paris for search query Paris (tweet should
      #be made within a radius of 80 miles from Paris maximum)
      geocode = paste(geotag()$lat[1], geotag()$lon[1], "80mi", sep = ",")
    )
    #put the results (from Twitter) in a dataframe
    twitter_comment_city <-
      twitter_comment_city %>% unlist()  %>% twitteR::twListToDF()
    #rename column value to tweet (tweet texts obtained)
    twitter_comment_city <-
      twitter_comment_city$text %>% tibble::as.tibble() %>%
      dplyr::rename("tweet" = value)

  })

  #rendering the table of tweets
  output$city_twitterdatatable <- DT::renderDataTable({
    DT::datatable(
      twitter_comment_city(),
      rownames = FALSE,
      colnames = "Sample of tweets from the last 2 weeks",
      autoHideNavigation = TRUE,
      #adding aesthetic to highlight a selected cell
      class = 'cell-border stripe',
      options = list(pageLength = 10,  scrollX =
                       '1000px'),
      #add a subtitle
      caption = tags$em(paste(
        "Twitter data results for city:",
        #paste name of the city in the format e.g. London
        #first letter capitalized and the rest in small case letters
        paste(
          toupper(substr(input$choosecity, 1, 1)),
          substr(input$choosecity, 2, nchar(input$choosecity)) ,
          sep = ""
        ),

        sep = " "
      ))

    )

  })

  output$place_query <- shiny::renderUI({
    #add a select input (among the available places found in the map)
    shiny::selectInput(
      inputId = "place_query_choice",
      label = "Choose a place!",
      #provide a vector with the names of all the available
      #places
      choices =  dput(as.character(twitterdata()$name)),
      selected = as.character(twitterdata()$name)[1],
      multiple = FALSE,
      selectize = TRUE

    )

  })
  #sets a reactive compoent (name of the selected place from
  #previously)
  input_search_twitterplace <- shiny::reactive({
    input_search_twitterplace <- input$place_query_choice

  })

  twitter_comment_place <- shiny::reactive({
    #query Twitter for tweets regarding the selected place
    twitter_comment_place <-   twitteR::searchTwitter(
      #paste the place as hashtag
      searchString = paste("#",  input_search_twitterplace() , sep = ""),
      #request english language
      lang = "en",
      #number of tweets to obtain
      n = 100,
      #obtain a mix of popular and most recent tweets for the
      #selected timeframe
      resultType = "mixed",
      since =  (
        #select data from the past 2 weeks
        lubridate::today(tzone = Sys.timezone()) %>%
          lubridate::ymd() - 14
      )     %>% as.character()    ,
      #get tweets up until today
      until = lubridate::today(tzone = Sys.timezone()) %>%
        lubridate::ymd() %>% as.character()  ,
      #specifying the geocode to be sure we only obtain e.g. indeed
      #the results published from Paris for search query Paris (tweet should
      #be made within a radius of 80 miles from Paris maximum)
      geocode = paste(geotag()$lat[1], geotag()$lon[1], "80mi", sep = ",")
    )
    #collect the results in a dataframe
    twitter_comment_place <-
      twitter_comment_place %>% unlist()  %>% twitteR::twListToDF()
    #obtain the tweets (texts) and set them as tibbl with column name = tweet
    twitter_comment_place <-
      twitter_comment_place$text %>% tibble::as.tibble() %>%
      dplyr::rename("tweet" = value)

  })
  #render the results (tweets) in a reactive datatable
  output$place_twitterdatatable <- DT::renderDataTable({
    DT::datatable(
      twitter_comment_place(),
      rownames = FALSE,
      colnames = "Sample of tweets from the last 2 weeks",
      autoHideNavigation = TRUE,
      #adding aesthetic to highlight a selected cell
      class = 'cell-border stripe',
      options = list(pageLength = 10,  scrollX = '1000px'),
      caption = tags$em(paste(
        "Twitter data results for place:",
        #paste name of the city in the format e.g. London
        #first letter capitalized and the rest in small case letters
        paste(
          toupper(substr(input$place_query_choice, 1, 1)),
          substr(
            input$place_query_choice,
            2,
            nchar(input$place_query_choice)
          ) ,
          sep = ""
        ),

        sep = " "
      ))

    )

  })

})
