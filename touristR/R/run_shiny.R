
#' @export



touristr_gui <- function() {
  appDir <- system.file("shiny_touristR", package = "touristR",mustWork=FALSE)
  if (appDir == "") {
    stop("Could not find shiny directory. Try re-installing package `touristR`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}

