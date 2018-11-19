


server <- function(input,output, session){
  
  

  
  
  data <- reactive({
    
    df <- geocode(location =
                    #uses the city inputted by the user as input to obtain latitude and longitude to obtain map
                    input$choosecity ,
                  
                  source = "dsk") %>% as.data.frame() %>% rename("long" =lon)
    
    
    
  })
  
  output$mymap <- renderLeaflet({
    df <- data()
    
    m <- leaflet(data = df) %>%
      setView(lng = df$long, lat = df$lat, zoom = 09)  %>%
      
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





