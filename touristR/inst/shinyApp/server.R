
library("magrittr")



shiny::shinyServer(function(input, output, session) {

  twitterdata <- shiny::reactive({


  twitterfetch <-  touristR::getTopNAttractions(  as.character(input$choosecity), 2)



    #correcting the levels and format of the  fetched data
    twitterfetch <-  data.frame(lapply(twitterfetch, function(x) unlist(x)))

    twitterfetch$lat <-     as.numeric(levels(twitterfetch$lat))[twitterfetch$lat]

    twitterfetch$lng <-     as.numeric(levels(twitterfetch$lng))[twitterfetch$lng]

    twitterfetch$name <-     as.character(levels(twitterfetch$name))[twitterfetch$name]

    twitterfetch$hashtag <-     as.character(levels(twitterfetch$hashtag))[twitterfetch$hashtag]



  twitterfetch <- twitterfetch %>% dplyr::mutate("sentimentcolorabsolute" =

                 ifelse(sentimentAbsolute == 1, "green", ifelse(sentimentAbsolute == 0, "orange","red"))
  )


  twitterfetch <- twitterfetch %>% dplyr::mutate("sentimentcolorrelative" =

                  ifelse(sentimentRelative == 1, "green", ifelse(sentimentRelative == 0, "orange","red")))




    twitterfetch <-twitterfetch %>% dplyr::mutate("radius" =
                      ifelse(popularity == 1, 40, ifelse(popularity == 0, 25, 10))




    )




    return(twitterfetch)


  })








  geotag <- shiny::reactive({
     geotag <- ggmap::geocode(location =
                               as.character(input$choosecity),
                              source = "dsk") %>% as.data.frame()


   })





  output$mymap <- leaflet::renderLeaflet({

    if(input$checkbox==FALSE) {

 m <-    leaflet::leaflet() %>%
   leaflet::addTiles()  %>%  leaflet::addMiniMap(zoomLevelFixed = 5, height=100, toggleDisplay=TRUE,minimized=FALSE ) %>%


   leaflet::addEasyButton(leaflet::easyButton(
     icon="fa-crosshairs", title="Locate Me",
     onClick=htmlwidgets::JS("function(btn, map){ map.locate({setView: true}); }"))) %>%



      #focus the geotag on the city as a whole

  leaflet::setView(lng = geotag()$lon[1]  ,   lat =  geotag()$lat[1] ,    zoom = 13) %>%


   #add markers in the map

   leaflet::addAwesomeMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,

                      icon=leaflet::awesomeIcons(
                        icon = 'glyphicon glyphicon-map-marker',
                        iconColor = 'black',
                        library = 'glyphicon',
                        markerColor = twitterdata()$sentimentcolorabsolute
                      ),

                      popup =  twitterdata()$name,
 #
                  label=  twitterdata()$name ,
 #                             "Type:", twitterdata$type),
                  clusterOptions = leaflet::markerClusterOptions(

                    iconCreateFunction =
                      htmlwidgets::JS("
                                          function(cluster) {
                                             return new L.DivIcon({
                                               html: '<div style=\"background-color:rgba(77,77,77,0.5)\"><span>' + cluster.getChildCount() + '</div><span>',
                                               className: 'marker-cluster'
                                             });
                                           }")








                  ),
                            clusterId = "Places" ) %>%


   leaflet::addCircleMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,
                   color =  twitterdata()$sentimentcolorabsolute,
 #
 #
 #
                   radius =  twitterdata()$radius       )



 m

} else   if(input$checkbox==TRUE) {

      m <-    leaflet::leaflet() %>%
        leaflet::addTiles()  %>%  leaflet::addMiniMap(zoomLevelFixed = 5, height=100, toggleDisplay=TRUE,minimized=FALSE ) %>%


        leaflet::addEasyButton(leaflet::easyButton(
          icon="fa-crosshairs", title="Locate Me",
          onClick=htmlwidgets::JS("function(btn, map){ map.locate({setView: true}); }"))) %>%



        #focus the geotag on the city as a whole

        leaflet::setView(lng = geotag()$lon[1]  ,   lat =  geotag()$lat[1] ,    zoom = 13) %>%



        #add the marker
        leaflet::addAwesomeMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,

                        icon=leaflet::awesomeIcons(
                          icon = 'glyphicon glyphicon-map-marker',
                          iconColor = 'black',
                          library = 'glyphicon',
                          markerColor = twitterdata()$sentimentcolorrelative
                        ),

                        popup = paste("Name:", twitterdata()$name),
                        #                             "Type:", twitterdata$type),
                        label= paste("Name:", twitterdata()$name ) ,
                        #                             "Type:", twitterdata$type),
                        clusterOptions = leaflet::markerClusterOptions(

                          iconCreateFunction =
                            htmlwidgets::JS("
                                          function(cluster) {
                                             return new L.DivIcon({
                                               html: '<div style=\"background-color:rgba(77,77,77,0.5)\"><span>' + cluster.getChildCount() + '</div><span>',
                                               className: 'marker-cluster'
                                             });
                                           }")








                        ),
                        clusterId = "Places" ) %>%


        leaflet::addCircleMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,
                         color =  twitterdata()$sentimentcolorrelative,
                         #
                         #
                         #
                         radius =  twitterdata()$radius       )



      m

    }



  })


  ###############Authenticate to twitter
  authentication <-
    vosonSML::Authenticate(
      "twitter",
      apiKey = 'ugjqg8RGNvuTAL1fEiNtw',
      apiSecret = '4WjuEbP6QLUN2DwDzyTwmdMES6fgnOsS65fWxpT8I',
      accessToken =  '76887198-JA3xCVO1vvQMqMDiIobWKKGQxYKSB0CV2lI2PZ7GL',
      accessTokenSecret = 'IvzlVOC8KkIaMR5s5K4u2IXbxKQv7EcUSvy2bnaru8gKz'
    )

  ##############


  twitter_comment_city <- shiny::reactive({


    twitter_comment_city <-   twitteR::searchTwitter(
      searchString = paste("#",  input$choosecity , sep="") ,
      lang = "en",

     # searchString = paste("#",  input$choosecity , sep="") ,

      n = 100,
      resultType = "mixed",
      since =  (lubridate::today(tzone = Sys.timezone()) %>%
        lubridate::ymd() - 14 )     %>% as.character()    ,

      until = lubridate::today(tzone = Sys.timezone()) %>%
        lubridate::ymd() %>% as.character()  ,

      #specifying the geocode to be sure we only obtain e.g. indeed
      #the results published from Paris for search query Paris (tweet should
      #be made within a radius of 80 miles from Paris maximum)

      geocode = paste( geotag()$lat[1], geotag()$lon[1], "80mi", sep = ",")  )



    twitter_comment_city <-     twitter_comment_city %>% unlist()  %>% twitteR::twListToDF()

    twitter_comment_city <- twitter_comment_city$text %>% tibble::as.tibble() %>% dplyr::rename("tweet" = value)



   })

#rendering the table of tweets

   output$city_twitterdatatable <- DT::renderDataTable({
     DT::datatable(twitter_comment_city(),rownames = FALSE,colnames = "Sample of tweets from the last 2 weeks",
                                  autoHideNavigation = TRUE,
                                 class = 'cell-border stripe',
                                 options = list(pageLength = 10,  scrollX='1000px'),

           caption = tags$em(paste("Twitter data results for city:",


                                   paste(
                                   toupper(substr( input$choosecity, 1, 1)),

                                   substr( input$choosecity, 2, nchar( input$choosecity)) , sep=""   ),

                                         sep = " ")
                                  )

                            )


 })




   output$place_query <- shiny::renderUI({




     shiny::selectInput( inputId= "place_query_choice",label = "Choose a place!",

                choices =     dput(as.character(twitterdata()$name)),
                selected = as.character(twitterdata()$name)[1],
                multiple = FALSE,selectize = TRUE

   )



   })




   input_search_twitterplace <- shiny::reactive({

     input_search_twitterplace <- input$place_query_choice


   })



   twitter_comment_place <- shiny::reactive({


     twitter_comment_place <-   twitteR::searchTwitter(
       searchString = paste("#",  input_search_twitterplace() , sep="") ,
       lang = "en",

       n = 100,
       resultType = "mixed",
       since =  (lubridate::today(tzone = Sys.timezone()) %>%
                   lubridate::ymd() - 14 )     %>% as.character()    ,

       until = lubridate::today(tzone = Sys.timezone()) %>%
         lubridate::ymd() %>% as.character()  ,

       #specifying the geocode to be sure we only obtain e.g. indeed
       #the results published from Paris for search query Paris (tweet should
       #be made within a radius of 80 miles from Paris maximum)

       geocode = paste( geotag()$lat[1], geotag()$lon[1], "80mi", sep = ",")  )



     twitter_comment_place <-     twitter_comment_place %>% unlist()  %>% twitteR::twListToDF()

     twitter_comment_place <- twitter_comment_place$text %>% tibble::as.tibble() %>% dplyr::rename("tweet" = value)



   })










   output$place_twitterdatatable <- DT::renderDataTable({


     DT::datatable(twitter_comment_place(),rownames = FALSE,colnames = "Sample of tweets from the last 2 weeks",
               autoHideNavigation = TRUE,
               class = 'cell-border stripe',
               options = list(pageLength = 10,  scrollX='1000px'),

               caption = tags$em(paste("Twitter data results for place:",


                                       paste(
                                         toupper(substr( input$place_query_choice, 1, 1)),

                                         substr(input$place_query_choice, 2, nchar( input$place_query_choice)) , sep=""   ),

                                       sep = " ")
               )

     )








   })


})
