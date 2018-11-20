




header <- dashboardHeader(title="Welcome to touristR dear traveller!",titleWidth=350)



sidebar <- dashboardSidebar( 
  
  
  helpText("Create an interactive tourist friendly city hot-spot guide."),
  
  actionButton("go!", "Go!"),
  textInput(inputId= "choosecity", label="Choose a city",placeholder="London maybe?!"),
  
  # Copy the line below to make a checkbox
  checkboxInput("Restaurant", label = "Restaurant", value = FALSE),
  
  checkboxInput("Hotel", label = "Hotel", value = FALSE),
  
  checkboxInput("Nightlife", label = "Nightlife", value = FALSE),
  
  checkboxInput("Parcs", label = "Parcs and attractions", value = FALSE),
  
  checkboxInput("Surprise", label = "Surprise me!", value = FALSE)   
  
  
  )





body <- dashboardBody(
  
  
  leafletOutput("mymap",height = 700) 
  
  
)






ui <- dashboardPage(header, sidebar, body)

  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  

