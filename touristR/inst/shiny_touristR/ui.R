
ui <- shinyUI(navbarPage( title= "Welcome to touristR!", id="nav",

                        tabPanel("Interactive map",

                        leaflet::leafletOutput("mymap",height = 700),


                                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                               draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                               width = 330, height = "auto",


                                               h2("Interactive parameters"),


                                               shiny::helpText( "Create an interactive tourist friendly city hot-spot guide using Twitter data.")  ,

                                               # Input choose city
                                               shiny::textInput(inputId= "choosecity", label="Choose a city",placeholder="London maybe?!"),





                                               # Input: place
                                               shiny::selectInput(inputId = "place",
                                                                  label = "Choose a place:",
                                                                  choices = c("Monument", "Museum", "Nightlife","Parcs"))

                                                )),



####################
                    tabPanel("About",
                             h4("User Manual: ", a("Click Here", href=
                                                     "http://nbviewer.ipython.org/github/funjo/NYPD_accidents_shiny/blob/master/User%20Manual.pdf")),
                             br(),
                             h4("Data Source"),
                             p("Source: ",a("NYPD Motor Vehicle Collisions | NYC Open Data.",href=
                                              "https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95")),
                             p("Description: ","Data Details of Motor Vehicle Collisions in
                              New York City provided by the Police Department (NYPD)."),
                             p("Usage: ","Original dataset was downloaded on 07/07/2015,
                              containing 618,358 accident records from 07/01/2012 to 07/05/2015.
                              Because of the loading speed concern, this app uses only 10,000 random records
                              from the original dataset."),
                             br(),
                             h4("Author Information"),
                             p("Fangzhou Cheng"),
                             p("Email: fc982@nyu.edu"),
                             p("Website:", a("http://www.fangzhoucheng.com",href="http://www.fangzhoucheng.com")),
                             p("Github:", a("http://www.github.com/funjo",href="http://www.github.com/funjo")),
                             p("LinkedIn:", a("http://www.linkedin.com/in/fangzhoucheng",href="http://www.linkedin.com/in/fangzhoucheng")),
                             br(),
                             br(),
                             p("Fangzhou Cheng - Copyright @ 2015, All Rights Reserved")
                    )
####################













))


#
#
#
#
#
#
# shiny::fixedPage(
#
# #title in first row
#   shiny::fixedRow(shiny::titlePanel("Welcome to touristR!")),
#
#
#   #2nd row with 1 column on the left with the map
#   #and 1 column on the right for the interactive aspects (inputs)
#   shiny::fixedRow(title="touristR Shiny Output",
#                   shiny::column(10,
#                   leaflet::leafletOutput("mymap",height = 700)
#
#            ),
#
#
#
#            shiny::column(2,
#
#
#                   shiny::helpText( "Create an interactive tourist friendly city hot-spot guide using Twitter data.")  ,
#
#                   # Input choose city
#                   shiny::textInput(inputId= "choosecity", label="Choose a city",placeholder="London maybe?!"),
#
#
#
#
#
#                   # Input: place
#                   shiny::selectInput(inputId = "place",
#                               label = "Choose a place:",
#                               choices = c("Monument", "Museum", "Nightlife","Parcs"))
#
#
#
#            )
#
#
#
#
#
#
#
#
#
#
#   )
# )
