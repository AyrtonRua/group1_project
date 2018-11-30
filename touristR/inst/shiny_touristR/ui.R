ui <- fixedPage(


  fixedRow(titlePanel("Welcome to touristR!")),

  fixedRow(title="touristR Shiny Output",
           column(8,
                  leaflet::leafletOutput("mymap",height = 700)

           ),



           column(4,


                  shiny::helpText( "Create an interactive tourist friendly city hot-spot guide using Twitter data.")  ,

                  shiny::textInput(inputId= "choosecity", label="Choose a city",placeholder="London maybe?!"),





                  # Input: Selector for choosing dataset ----
                  selectInput(inputId = "place",
                              label = "Choose a place:",
                              choices = c("Monument", "Museum", "Nightlife","Parcs"))



           )










  )
)
