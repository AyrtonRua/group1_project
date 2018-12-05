

library("shiny")
library("touristR")
library("magrittr")
library("leaflet")

library(htmltools)
library(htmlwidgets)



shinyServer(function(input, output, session) {
  df <- shiny::reactive({
                          geotag <- ggmap::geocode(location =
                             input$choosecity,
                             source = "dsk") %>% as.data.frame()

 # twitterdata <- function( input$choosecity)

  })




  output$mymap <- leaflet::renderLeaflet({
    geotag <- df()
    #    twitterdata <- df()


 m <-    leaflet::leaflet(data = df()) %>%
   addTiles()  %>%  addMiniMap(zoomLevelFixed = 5, height=100, toggleDisplay=TRUE,minimized=FALSE ) %>%


   addEasyButton(easyButton(
     icon="fa-crosshairs", title="Locate Me",
     onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%



      #focus the geotag on the city as a whole

      leaflet::setView(lng = geotag[,1],   lat = geotag[,2],    zoom = 12)       # %>%


#NOT RUN BELLOW
     # addMarkers(data=twitterdata, lng = ~long ,    lat = ~lat ,
     #            popup = paste("Name", name, "<br>",
     #                          "Type:", type),
        #             label= paste("Name", name, "<br>",
 #                          "Type:", type),
     #          clusterOptions = markerClusterOptions(),
     #          clusterId = "Places")
 #NOT RUN ABOVE

 #https://rstudio.github.io/leaflet/markers.html

 # getColor <- function(twitterdata=twitterdata) {
 #   sapply(twitterdata$sentiment, function(sentiment) {
 #     if(sentiment == "high") {
 #       "green"
 #     } else if(sentiment == "mid") {
 #       "orange"
 #     } else {
 #       "red"
 #     } })
 # }
 #
 #
 # icons <- awesomeIcons(
 #   icon = 'glyphicon glyphicon-map-marker',
 #   iconColor = 'black',
 #   library = 'glyphicon',
 #   markerColor = getColor(twitterdata)
 # )
 #
 #
 #   addAwesomeMarkers(~twitterdata$long, ~twitterdata$lat,icon=icons,
 #
 #                     popup = paste("Name", twitterdata$name, "<br>",
 #                             "Type:", twitterdata$type),
 #                 label= paste("Name", twitterdata$name, "<br>",
 #                             "Type:", twitterdata$type),
 #                 clusterOptions = markerClusterOptions(),
 #                           clusterId = "Places" )  %>%
#here one option is to keep in # markerClusterOptions and  clusterId
 #and use for size circle
 #


 # getradius <- function(twitterdata=twitterdata) {
 #   sapply(twitterdata$count, function(count) {
 #     if(count == "high") {
 #           3
 #     } else if(count == "mid") {
 #       2
 #     } else {
 #       1
 #     } })
 # }
 #


 #https://rstudio.github.io/leaflet/markers.html

 # addCircleMarkers(data = Jun, lat = ~twitterdata$lat , lng = ~twitterdata$long ,
 #                  color = ~getColor(twitterdata),
 #
 #                  popup = paste("Name", twitterdata$name, "<br>",
 #                                "Type:", twitterdata$type),
 #
 #
 #                  radius = ~getradius(twitterdata)        )


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
