
#' @export



touristr_gui <- function() {

  shiny::runApp(
    appDir = "../inst/shiny_touristR",
    display.mode = "normal",
    launch.browser = TRUE,
    quiet = FALSE
  )

}

