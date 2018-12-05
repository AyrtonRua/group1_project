

#add namespace of each package and remove the libraries to be done!
library("shiny")
library("leaflet")
library("ggmap")


ui <- shinyUI(navbarPage(position="static-top",
  title = "Welcome to touristR!",inverse=TRUE,collapsible=TRUE,fluid=TRUE,
  id = "nav",

  tabPanel(
    "Interactive map",


    div(class="outer",


        tags$head(
          # Including custom CSS
          includeCSS("../shinyApp/www/styles.css")
        ),



        leafletOutput("mymap", width="100%", height="100%"),


    absolutePanel(
      id = "controls",
      class = "panel panel-default",
      fixed = TRUE,
      draggable = TRUE,
      top = 70,
      left = "auto",
      right = 15,
      bottom = "auto",
      width = 340,
      height = "auto",


      h2("Interactive parameters", align = "center"),


      h6(shiny::helpText(
        em(
          "Create an interactive tourist friendly city hot-spot guide using Twitter data."
        )
      )   ,  align = "left"),

      # Input choose city
      h4(
        shiny::textInput(
          inputId = "choosecity",
          label = "Choose a city",
          placeholder = "London maybe?!"
        )    ,
        align = "center"
      ) ,





      # Input: place
      h4(
        shiny::selectInput(
          inputId = "place",
          label = "Choose a place:",
          choices = c("Monument", "Museum", "Nightlife", "Parcs")
        ) ,
        align = "center"
      )





    )
  )


  ),



  ################################################################################
  tabPanel(
    title = "About",

 h4("Description:") ,

    p("Tourist friendly map based on live-fetched data from Twitter."),
    br(),
    h4("Data Source:"),
    p(a("Twitter API", href =
          "https://twitter.com/")),

    br(),
    h4("Authors Information:"),
    p("Ayrton Rua: ayrton.gomesmartinsrua@unil.ch"),

    p("Maurizio Griffo: maurizio.griffo@unil.ch"),


    p("Ali Karray: mohamedali.karray@unil.ch"),


    p("Mohit Mehrotra: mohit.mehrotra@unil.ch"),


    p("Youness Zarhloul: youness.zarhloul@unil.ch"),
    br(),

    h4("Source Code:"),
    p( icon("github")  , a(
      "https://github.com/AyrtonRua/group1_project"
    )),

    br(),

    h4("Credits:"),


    p(icon("book") ,  a("https://ptds2018.netlify.com")),


    p("Fangzhou Cheng:", a(
      "https://github.com/funjo/NYPD_accidents_shiny"
    )),


    br(),


    br(),
 div(  h4("")  ,   img(src="LogoHECLausanne.PNG",align="right", width=150,height=100 ) ),


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
