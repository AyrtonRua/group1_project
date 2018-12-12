ui <- shiny::shinyUI(# add class navbar to be used to specify the css styling
  shiny::div(
    class = "navbar",

    #create a navigation bar page
    shiny::navbarPage(
      position = "static-top",
      #title
      title = "Welcome to touristR!",
      inverse = TRUE,
      collapsible = TRUE,
      fluid = TRUE,
      id = "nav",
      #create a tab panel: Interactive map
      shiny::tabPanel(
        "Interactive map",

        shiny::div(
          class = "outer",

          tags$head(# Including custom CSS styling
            shiny::includeCSS("../shinyApp/www/styles.css")),

          #display interactive map
          leaflet::leafletOutput("mymap", width = "100%", height = "100%"),
          #add panel on the left with the input parameters
          shiny::absolutePanel(
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

            #print text (h2 level)
            shiny::h2("Interactive parameters", align = "center"),
            #print text (h6 level) providing information about the Shiny app
            shiny::h6(shiny::helpText(
              shiny::em(
                "Create an interactive tourist friendly city
                hot-spot guide using Twitter data."
              )
            )   ,  align = "left"),

            #input choose city
            shiny::h4(
              shiny::textInput(
                inputId = "choosecity",
                label = "Choose a city",
                placeholder = "London maybe?!"
              )    ,
              align = "center"
            ) ,

            shiny::br(),
            #input select or not relative sentiment (in comparison to the
            #other places obtained within the same city)
            shiny::h4(
              shinyWidgets::materialSwitch(
                inputId = "checkbox",
                label = "Relative sentiment?",
                value = FALSE,
                right = TRUE,
                width = '100%'

              ),

              align = "left"
            )

          )
        )

      ),
      #create a sub navigation bar
      #to get 1 tab with the city data table
      #and 1 tab with the landmark data table
      shiny::navbarMenu(
        "Tweets",
        shiny::tabPanel(
          title = "City data",
          value = "cityinput",
          #print datatable (from Twitter) for the city chosen
          DT::dataTableOutput(outputId = "city_twitterdatatable", height = 10)
        ),


        shiny::tabPanel(
          title = "Place data",
          value = "placeinput",
          #provide a reactive selectInput (choices based on the fetched
          #places names)
          shiny::column(width = 4,    shiny::uiOutput("place_query")),

          shiny::column(
            width = 12,
            #print datatable (from Twitter) of the place chosen
            DT::dataTableOutput(outputId = "place_twitterdatatable",
                                height = 10)
          )

        )

      ),
      #add a tab panel (About) with information regarding the Shiny app
      shiny::tabPanel(
        title = "About",

        shiny::h4("Description:") ,

        shiny::p("Tourist friendly map based on live-fetched
                 data from Twitter."),
        shiny::br(),
        #data source
        shiny::h4("Data Source:"),
        shiny::p(
          icon("twitter"),
          shiny::a("Twitter", href =
                     "https://twitter.com/")
        ),

        #information about the authors
        shiny::br(),
        shiny::h4("Authors Information:"),
        shiny::p("Ayrton Rua: ayrton.gomesmartinsrua@unil.ch"),

        shiny::p("Maurizio Griffo: maurizio.griffo@unil.ch"),

        shiny::p("Ali Karray: mohamedali.karray@unil.ch"),

        shiny::p("Mohit Mehrotra: mohit.mehrotra@unil.ch"),

        shiny::p("Youness Zarhloul: youness.zarhloul@unil.ch"),
        shiny::br(),
        #information about source code
        shiny::h4("Source Code:"),
        shiny::p(
          shiny::icon("github")  ,
          shiny::a("Group1 project",
                   href = "https://github.com/AyrtonRua/group1_project")
        ),

        shiny::br(),
        #credits
        shiny::h4("Credits:"),

        shiny::p(
          shiny::icon("book") ,
          shiny::a("Programming tools in data science, Fall 2018",
                   href = "https://ptds2018.netlify.com")
        ),

        shiny::p(
          shiny::icon("github"),
          #credits to Fangzhou Cheng for some parts of the Shiny app
          #specifically regarding the styling of the app
          shiny::a("Fangzhou Cheng",
                   href = "https://github.com/funjo/NYPD_accidents_shiny")
        ),

        shiny::br(),

        shiny::br(),
        shiny::div(
          h4("")  ,
          #displays image (Logo HEC Lausanne, University of Lausanne)
          shiny::img(
            src = "LogoHECLausanne.PNG",
            align = "right",
            width = 150,
            height = 100
          )
        ),

        shiny::p("HEC Lausanne, 2018"),
        shiny::p("Programming tools in data science, Fall 2018"),
        shiny::p("Licence: GPL-2")

      )

    )

  ))
