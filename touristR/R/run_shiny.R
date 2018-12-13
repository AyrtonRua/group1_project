#' @title run_shiny
#'
#' @description Provide an interactive Shiny app, representing a tourist
#' friendly map, that the user can query to obtain useful travel information
#' (e.g. places to visit).
#'
#' @param city City of interest
#' @param relative_sentiment If checked, select the relative sentiment
#' (in comparison to the fetched places), otherwise the default behaviour
#' is to provide an absolute measure of the sentiments (based on a scale of
#' -5 to 5; values under or equal to 3 labelled as bad sentiment
#' colored in red, above or equal to 3 as good sentiment colored in green,
#' and in between as mid colored in green)
#'
#' @return An interactive map displaying the information requested by the user,
#' enhanced by Twitter inputs (e.g. through sentiment analysis of the place).
#'
#' @author Ayrton Rua: \email{ayrton.gomesmartinsrua@unil.ch}
#' @author Maurizio Griffo: \email{maurizio.griffo@unil.ch}
#' @author Ali Karray: \email{mohamedali.karray@unil.ch}
#' @author Mohit Mehrotra: \email{mohit.mehrotra@unil.ch}
#' @author Youness Zarhloul: \email{youness.zarhloul@unil.ch}
#'
#' @references Orso, S., Molinari, R., Lee, J., Guerrier, S., & Beckman, M. (2018).
#' An Introduction to Statistical Programming Methods with R.
#' Retrieved from \url{https://smac-group.github.io/ds/}
#'
#' @seealso \code{\link{touristR} & \link{track_keyword}}
#'
#' @examples \dontrun{
#' city = London,
#' relative_sentiment? (unchecked)
#' }
#'
#' @details The function obtains automatically the longitude and latitude of
#' the requested city and places, fectches the top spots accordingly from
#' Tripadvisor, and runs a Twitter count and sentiment analysis, to return
#' an interactive plot, illustrating the most sought after places
#' by Twitter users (i.e. by count and most liked places). \cr
#' The final aim is to display an interactive map of
#' the top-spots to visits in any given city.
#'
#' @export
run_shiny <- function() {
  appDir <- system.file("shinyApp", package = "touristR")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing touristR",
         call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal", launch.browser = TRUE)

}
