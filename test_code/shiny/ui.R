


ui <- fluidPage(
  
  theme = shinytheme("united"), 
  
  titlePanel("Welcome to touristR dear traveller!"),
  
  
  #https://shiny.rstudio.com/articles/layout-guide.html
  sidebarLayout(position = "left",
    
    sidebarPanel(
      
      

    
  actionButton("go!", "Go!"),
  textInput(inputId= "choosecity", label="Choose a city",placeholder="London maybe?!"),
            
  # Copy the line below to make a checkbox
  checkboxInput("checkbox", label = "Restaurant", value = FALSE),
  
  checkboxInput("checkbox", label = "Hotel", value = FALSE),
  
  checkboxInput("checkbox", label = "Nightlife", value = FALSE),
  
  checkboxInput("checkbox", label = "Parcs and attractions", value = FALSE),
  
  checkboxInput("checkbox", label = "Surprise me!", value = FALSE)  ,width = 4
  
            ) ,
 
  
  mainPanel  (  leafletOutput("mymap",height = 720), width = 8  )
  
  )
  
  
  ) 

