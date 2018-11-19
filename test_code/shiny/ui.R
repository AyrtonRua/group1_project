


ui <- fluidPage(
  
  actionButton("go!", "Go!"),
  textInput(inputId= "choosecity", label="Choose a city",placeholder="London maybe?!"),
            
          
  leafletOutput("mymap",height = 1000)
)