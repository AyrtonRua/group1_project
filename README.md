
\[![Build
status](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)\]
(<https://github.com/AyrtonRua/group1_project>) \[![License: GPL
v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)\]
(<https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html>)

## Overview

touristR is a tourist friendly R package providing useful information to
help fellow travellers find the best locations to visit worldwide.

## Installation

``` r
#Please install the development version from GitHub:
#install.packages("devtools")
#devtools::install_github("AyrtonRua/group1_project")
```

## Usage

Please refer to the documentation of each function *run\_shiny*,
*track\_twitter\_hashtag* and *getTopNAttractions*, for further
information on how to use each function.

Nonetheless, please find bellow an example from each function:

``` r
#run_shiny (interactive Shiny app)
#city = London
#relative_sentiment? (unchecked)

#track_twitter_hashtag
# track_keyword(
# keyword = c("eiffel tower", "san francisco", "london"),
# type="place"
# number = 2,
# sincetype = "weeks",
# provideN = 100
# )

#getTopNAttractions
# getTopNAttractions(
# city = "london",
# n = 10
# )
```

## Getting help

In case of any request including bugs, please open a new issue on the
[GitHub repository of
group 1](https://github.com/AyrtonRua/group1_project).

## References

Orso, S., Molinari, R., Lee, J., Guerrier, S., & Beckman, M. (2018). *An
Introduction to Statistical Programming Methods with R*. Retrieved from
<https://smac-group.github.io/ds/>
