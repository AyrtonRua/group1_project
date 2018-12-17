touristR
================

[![Build
status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/AyrtonRua/group1_project)
[![GitHub
version](https://img.shields.io/badge/Package%20version-1.0.0-orange.svg)](https://github.com/AyrtonRua/group1_project)
[![License: GPL
v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

## Overview :earth\_africa:

touristR is a tourist friendly R package providing useful information to
help fellow travellers find the best locations to visit worldwide.

## Getting Started :runner:

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes.

### Prerequisites :warning:

In case of package loading failure, please make sure that you have the
required versions and packages needed, the full list of requirement is
available in the
[DESCRIPTION](https://github.com/AyrtonRua/group1_project/blob/master/DESCRIPTION)
file.

*Note*: This package requires `R (>= 3.4.0)`.

### Installation :rocket:

``` r
#Please install the development version from GitHub:
#install.packages("devtools", build_vignettes = TRUE)
#devtools::install_github("AyrtonRua/group1_project")
```

## Usage :computer:

Please refer to the documentation of each function `run_shiny()`,
`track_twitter_hashtag()` and `getTopNAttractions()`, for further
information on how to use each function.

Nonetheless, please find bellow an example from each function:

``` r
#run_shiny (interactive Shiny app)
#city = London
#relative_sentiment? (unchecked)

#track_twitter_hashtag
# track_twitter_hashtag(
#   keyword = c("eiffel tower", "san francisco", "london"),
#   type = "place",
#   number = 2,
#   sincetype = "weeks",
#   provideN = 100
#   )

#getTopNAttractions
# getTopNAttractions(city = "london",
#                    n = 10)
```

## Screencast :tv:

<!-- Video Presentation of the group -->

[![Screencast package
touristR](http://img.youtube.com/vi/p6urWb3U07M/maxresdefault.jpg)](http://www.youtube.com/watch_popup?v=p6urWb3U07M "Screencast package touristR")

## Getting help :interrobang:

In case of any request including bugs, please open a new issue on the
[GitHub repository of
group 1](https://github.com/AyrtonRua/group1_project).

## Authors (Group 1 Myama) :santa:

  - Ayrton Rua
  - Maurizio Griffo
  - Ali Karray
  - Mohit Mehrotra
  - Youness Zarhloul

## References :books:

Orso, S., Molinari, R., Lee, J., Guerrier, S., & Beckman, M. (2018). *An
Introduction to Statistical Programming Methods with R*. Retrieved from
<https://smac-group.github.io/ds/>

## License :scroll:

This project is licensed under the GPL-2 License - see the
[LICENSE](https://github.com/AyrtonRua/group1_project/blob/master/LICENSE)
file for details.

<br><br>

-----

**touristR** (2018), Group 1 Myama. Released under GPL-2 License.
