




header <- dashboardHeader(title="Welcome to touristR dear traveller!",titleWidth=350)



sidebar <- dashboardSidebar( 
  
  
  helpText("Create an interactive tourist friendly city hot-spot guide."),
  
  submitButton(text = "Let's go!" ),
  textInput(inputId= "choosecity", label="Choose a city",placeholder="London maybe?!"),
  
  # checkboxes
  checkboxInput(inputId= "Restaurant", label = "Restaurant", value = FALSE),
  
  checkboxInput(inputId= "Hotel", label = "Hotel", value = FALSE),
  
  checkboxInput(inputId= "Nightlife", label = "Nightlife", value = FALSE),
  
  checkboxInput(inputId= "Parcs", label = "Parcs and attractions", value = FALSE),
  
  checkboxInput(inputId= "Surprise", label = "Surprise me!", value = FALSE)   
  
  
  )





body <- dashboardBody(
  
  
  leafletOutput("mymap",height = 700) 
  
  
)






ui <-  shinyUI(
  
  
  dashboardPage(header, sidebar, body,skin="red")

  
)
  
  
  
  
  
  
  
  
  
  

  
  
  
  

