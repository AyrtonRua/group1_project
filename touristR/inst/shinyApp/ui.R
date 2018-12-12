

#add namespace of each package and remove the libraries to be done!
library("shiny")
library("leaflet")
library("ggmap")


library("shinyWidgets")


library("DT")




ui <- shinyUI(

  # add class navbar to be used to add css styling
  div(class = "navbar",

  navbarPage(position="static-top",
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


      br(),


              h4(



                materialSwitch(
         inputId = "checkbox", label = "Relative sentiment?",value = FALSE,right = TRUE,width = '100%'

       ),

align= "left" )



    )
  )


  ),


  ################################################################################
navbarMenu("Tweets",
  tabPanel(




    title = "City data",value = "cityinput",

             DT::dataTableOutput(outputId ="city_twitterdatatable",height = 10)  ),



  tabPanel(

    title = "Place data",value="placeinput",


column(width=4,    uiOutput("place_query")  ),


 column(width=12,   DT::dataTableOutput(outputId ="place_twitterdatatable",height = 10)  )


  )


),







  ################################################################################
  tabPanel(
    title = "About",

 h4("Description:") ,

    p("Tourist friendly map based on live-fetched data from Twitter."),
    br(),
    h4("Data Source:"),
    p(icon("twitter"), a("Twitter", href =
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
    p( icon("github")  , a("Group1 project",
      href="https://github.com/AyrtonRua/group1_project"
    )),

    br(),

    h4("Credits:"),


    p(icon("book") ,  a("Programming tools in data science, Fall 2018",href="https://ptds2018.netlify.com")),


    p(  icon("github"), a("Fangzhou Cheng",
      href= "https://github.com/funjo/NYPD_accidents_shiny"
    )),


    br(),


    br(),
 div(  h4("")  ,   img(src="LogoHECLausanne.PNG",align="right", width=150,height=100 ) ),


    p("HEC Lausanne, 2018"),
    p("Programming tools in data science, Fall 2018"),

    p("Licence: GPL-2")



)


  )



))
