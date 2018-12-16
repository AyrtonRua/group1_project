touristR
================

[![Build
status](https://img.shields.io/badge/build-passing-green.svg)](https://github.com/AyrtonRua/group1_project)
[![GitHub
version](https://img.shields.io/badge/Package%20version-1.0.0-orange.svg)](https://github.com/AyrtonRua/group1_project)
[![License: GPL
v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

<u> Authors:</u> Ayrton Rua, Maurizio Griffo, Ali Karray, Mohit
Mehrotra, Youness Zarhloul (Group 1 Myama)

## Overview :earth\_africa:

touristR is a tourist friendly R package providing useful information to
help fellow travellers find the best locations to visit worldwide.

## Installation :rocket:

``` r
#Please install the development version from GitHub:
#install.packages("devtools")
#devtools::install_github("AyrtonRua/group1_project")
```

## Usage :computer:

Please refer to the documentation of each function run\_shiny,
track\_twitter\_hashtag and getTopNAttractions, for further information
on how to use each function.

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

## Getting help :interrobang:

In case of any request including bugs, please open a new issue on the
[GitHub repository of
group 1](https://github.com/AyrtonRua/group1_project).

## References :books:

Orso, S., Molinari, R., Lee, J., Guerrier, S., & Beckman, M. (2018). *An
Introduction to Statistical Programming Methods with R*. Retrieved from
<https://smac-group.github.io/ds/>

<br><br>

**touristR** (2018), Group 1 Myama. Released under GPL-2 License.
