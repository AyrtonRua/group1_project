


#add namespace and remove packages to be done!!!!!
library("shiny")
library("magrittr")
library("leaflet")

library("tidyverse")


shinyServer(function(input, output, session) {

  twitterdata <- shiny::reactive({


    twitterfetch <-  touristR::getTopNAttractions(  as.character(input$choosecity), 10)


    #correcting the levels and format of the  fetched data
    twitterfetch <-  data.frame(lapply(twitterfetch, function(x) unlist(x)))

    twitterfetch$lat <-     as.numeric(levels(twitterfetch$lat))[twitterfetch$lat]

    twitterfetch$lng <-     as.numeric(levels(twitterfetch$lng))[twitterfetch$lng]

    twitterfetch$name <-     as.character(levels(twitterfetch$name))[twitterfetch$name]

    twitterfetch$hashtag <-     as.character(levels(twitterfetch$hashtag))[twitterfetch$hashtag]

    twitterfetch <- twitterfetch %>% mutate("sentimentcolor" =

                     ifelse(sentiment == 1, "green", ifelse(sentiment == 0, "orange","red"))
                  )

    twitterfetch <-twitterfetch %>% mutate("radius" =
                      ifelse(popularity == 1, 40, ifelse(popularity == 0, 25, 10))
    )


#
# #############################TO BE CORRECTED
#     twitterfetch <- twitterfetch %>% mutate("type" =
#
#
# ifelse( contains(vars = name,match = "museum") , "museum",
#
#
# ifelse(  contains(vars = name,match = "monument")  ,"monuments"  , "attractions"   )
#
#
#
#         )
#
#                                              )
#
# #######filter based on user's request e.g. monument
#     twitterfetch <- twitterfetch %>% filter(type == input$place)

    #############################TO BE CORRECTED







    return(twitterfetch)

#str(twitterfetch)

  })





  geotag <- shiny::reactive({
     geotag <- ggmap::geocode(location =
                               as.character(input$choosecity),
                              source = "dsk") %>% as.data.frame()


   })





  output$mymap <- leaflet::renderLeaflet({



 m <-    leaflet::leaflet() %>%
   addTiles()  %>%  addMiniMap(zoomLevelFixed = 5, height=100, toggleDisplay=TRUE,minimized=FALSE ) %>%


   addEasyButton(easyButton(
     icon="fa-crosshairs", title="Locate Me",
     onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%



      #focus the geotag on the city as a whole

  leaflet::setView(lng = geotag()$lon[1]  ,   lat =  geotag()$lat[1] ,    zoom = 13) %>%



 #https://rstudio.github.io/leaflet/markers.html


 #
 #

 #
 #
    addAwesomeMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,

                      icon=awesomeIcons(
                        icon = 'glyphicon glyphicon-map-marker',
                        iconColor = 'black',
                        library = 'glyphicon',
                        markerColor = twitterdata()$sentimentcolor
                      ),

                      popup = paste("Name:", twitterdata()$name),
 #                             "Type:", twitterdata$type),
                  label= paste("Name:", twitterdata()$name ) ,
 #                             "Type:", twitterdata$type),
                  clusterOptions = markerClusterOptions(

                    iconCreateFunction =
                      JS("
                                          function(cluster) {
                                             return new L.DivIcon({
                                               html: '<div style=\"background-color:rgba(77,77,77,0.5)\"><span>' + cluster.getChildCount() + '</div><span>',
                                               className: 'marker-cluster'
                                             });
                                           }")








                  ),
                            clusterId = "Places" ) %>%
#here one option is to keep in # markerClusterOptions and  clusterId
 #and use for size circle



 #https://rstudio.github.io/leaflet/markers.html

  addCircleMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,
                   color =  twitterdata()$sentimentcolor,
 #
 #
 #
                   radius =  twitterdata()$radius       )


 #if it works copy the function add legend to make it also for the count of Twitter
# addLegend(position = "bottomleft", colors = c("green","orange","red"),
#
#           values = c("high", "mid", "low"),opacity = 1,
#           title = "Sentiment analysis"
#
#           )


 m


  })





})
