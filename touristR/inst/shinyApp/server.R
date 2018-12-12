


#add namespace and remove packages to be done!!!!!
library("shiny")
library("magrittr")
library("leaflet")

library("tidyverse")


library("shinyWidgets")


library("DT")

library("touristR")


shinyServer(function(input, output, session) {

  twitterdata <- shiny::reactive({


  twitterfetch <-  touristR::getTopNAttractions(  as.character(input$choosecity), 2)



    #correcting the levels and format of the  fetched data
    twitterfetch <-  data.frame(lapply(twitterfetch, function(x) unlist(x)))

    twitterfetch$lat <-     as.numeric(levels(twitterfetch$lat))[twitterfetch$lat]

    twitterfetch$lng <-     as.numeric(levels(twitterfetch$lng))[twitterfetch$lng]

    twitterfetch$name <-     as.character(levels(twitterfetch$name))[twitterfetch$name]

    twitterfetch$hashtag <-     as.character(levels(twitterfetch$hashtag))[twitterfetch$hashtag]



  twitterfetch <- twitterfetch %>% mutate("sentimentcolorabsolute" =

                 ifelse(sentimentAbsolute == 1, "green", ifelse(sentimentAbsolute == 0, "orange","red"))
  )


  twitterfetch <- twitterfetch %>% mutate("sentimentcolorrelative" =

                  ifelse(sentimentRelative == 1, "green", ifelse(sentimentRelative == 0, "orange","red")))





     #############################TO BE CORRECTED



    twitterfetch <-twitterfetch %>% mutate("radius" =
                      ifelse(popularity == 1, 40, ifelse(popularity == 0, 25, 10))



    )



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








    return(twitterfetch)

#str(twitterfetch)

  })












  geotag <- shiny::reactive({
     geotag <- ggmap::geocode(location =
                               as.character(input$choosecity),
                              source = "dsk") %>% as.data.frame()


   })





  output$mymap <- leaflet::renderLeaflet({

    if(input$checkbox==FALSE) {

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
                        markerColor = twitterdata()$sentimentcolorabsolute
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


  addCircleMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,
                   color =  twitterdata()$sentimentcolorabsolute,
 #
 #
 #
                   radius =  twitterdata()$radius       )



 m

} else   if(input$checkbox==TRUE) {

      m <-    leaflet::leaflet() %>%
        addTiles()  %>%  addMiniMap(zoomLevelFixed = 5, height=100, toggleDisplay=TRUE,minimized=FALSE ) %>%


        addEasyButton(easyButton(
          icon="fa-crosshairs", title="Locate Me",
          onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%



        #focus the geotag on the city as a whole

        leaflet::setView(lng = geotag()$lon[1]  ,   lat =  geotag()$lat[1] ,    zoom = 13) %>%



        #add the marker
      addAwesomeMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,

                        icon=awesomeIcons(
                          icon = 'glyphicon glyphicon-map-marker',
                          iconColor = 'black',
                          library = 'glyphicon',
                          markerColor = twitterdata()$sentimentcolorrelative
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


        addCircleMarkers(lng = twitterdata()$lng,lat = twitterdata()$lat,
                         color =  twitterdata()$sentimentcolorrelative,
                         #
                         #
                         #
                         radius =  twitterdata()$radius       )



      m

    }












  })






  ################################## add dataframe of twitter



  twitter_comment <- reactive({
#
    twitter_comment <- touristR::track_keyword(keyword = input$choosecity, number = 2,sincetype = "weeks",provideN = 100)
#

    twitter_comment <- touristR::track_keyword(keyword = "paris", number = 2,sincetype = "weeks",provideN = 100)


   })
#
#
#
#
#
   output$twitterdatatable <- DT::renderDataTable({
     datatable(twitterdata(),rownames = FALSE,
                                  autoHideNavigation = TRUE,
                                 class = 'cell-border stripe',
                                 options = list(pageLength = 10),
#
                         caption = tags$em(paste("Twitter data results for city:", input$choosecity)) )
#
#
 })





  ##################################


})
