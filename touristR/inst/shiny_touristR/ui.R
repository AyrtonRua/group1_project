
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



################################################################################
                    tabPanel(title="About",
                             br(),
                             h4("Description:"),
                             p("Tourist friendly map based on live-fetched data from Twitter."),
                             br(),
                             h4("Data Source:"),
                             p(a("Twitter API",href=
                                              "https://twitter.com/")),

                             br(),
                             h4("Authors Information:"),
                             p("Ayrton Rua: ayrton.gomesmartinsrua@unil.ch"),

                             p("Maurizio Griffo: maurizio.griffo@unil.ch"),


                             p("Ali Karray: mohamedali.karray@unil.ch"),


                             p("Mohit Mehrotra: mohit.mehrotra@unil.ch"),


                             p("Youness Zarhloul: youness.zarhloul@unil.ch"),
                             br(),

                             h4("Links:"),


                             p("Github:", a("https://github.com/AyrtonRua/group1_project")),

                              p("Course website:", a("https://ptds2018.netlify.com")),

                             br(),
                             br(),
                             p("HEC Lausanne, 2018"),
                             p("Programming tools in data science"),
                             p("Licence: GNU Licence")


                    )
####################################################################################################













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
