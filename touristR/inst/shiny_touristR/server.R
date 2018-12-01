
library("shiny")
library("ptds2018hw4g1")
library("magrittr")
library("leaflet")



  shinyServer(

  function(input,output, session){



  data <- reactive({
    df <- ggmap::geocode(location =


                    #goal here would be user inputs the city
                    #then we run a search to obtain the latitude and longitude
                    #make it a datraframe df like bellow which is used to make the map


                    #uses the city inputted by the user as input to obtain latitude and longitude to obtain map
                    input$choosecity ,

                  source = "dsk") %>% as.data.frame() %>% dplyr::rename("long" =lon)

  })









  output$mymap <- leaflet::renderLeaflet({
    df <- data()


    m <- leaflet::leaflet(data = df) %>%


      setView(lng = df$long, lat = df$lat, zoom = 12)  %>%

    #  addProviderTiles(provider=) %>%   choose one provide so map looks nice
      #check https://stackoverflow.com/questions/37996143/r-leaflet-zoom-control-level those styles


      addTiles() %>%
      addMarkers(lng = ~long,
                 lat = ~lat,
                 popup = paste("Name", df$name, "<br>",
                               "Language:", df$language))

     m
  })





}

)

#keep the #'
#devtools::document()



