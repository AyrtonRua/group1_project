


library("xml2") # package to read the page 

real_estate <- read_html(
  "https://www.tripadvisor.co.uk/Attractions-g186338-Activities-London_England.html#ATTRACTION_SORT_WRAPPER"
)   # read the xml page and parse it. 

 


# we wanna extract information, use the rvest package. 

library(rvest)
library(magrittr)

#to get nodes or elements with this identification

nodes <- html_nodes(x = real_estate, css = ".listing_title a") # it's a mess

# Create a function, nodes and extract a text 

html_text(x = html_nodes(x = real_estate, css = ".listing_title a") )


# Use pipe operator %>%

real_estate %>%
  html_nodes(".listing_title a") %>%
  html_text()

attractions <- as_data_frame(real_estate %>%
                html_nodes(".listing_title a") %>%
                html_text())


################################### Hotels ##############################

library("xml2") # package to read the page 

hotels <- read_html(
  "https://www.tripadvisor.com/Hotels-g186338-London_England-Hotels.htmlR"
)   # read the xml page and parse it. 



.prominent


#to get nodes or elements with this identification

nodes1 <- html_nodes(x = hotels, css = ".prominent") # it's a mess

# Create a function, nodes and extract a text 

html_text(x = html_nodes(x = hotels, css = ".prominent") 


hotels_london <- as_data_frame(hotels %>%
html_nodes(".prominent") %>%
html_text())
          
          
          
          
          
          
################################### Restaurants ##############################
          
          
          library("xml2") # package to read the page 
          
          restaurants <- read_html(
            "https://www.tripadvisor.com/Restaurants-g186338-London_England.html"
          )   # read the xml page and parse it. 
          
          
          
          .property_title
          
          
          #to get nodes or elements with this identification
          
          nodes3 <- html_nodes(x = restaurants, css = ".property_title") # it's a mess
          
          # Create a function, nodes and extract a text 
          
          html_text(x = html_nodes(x = restaurants, css = ".property_title") 

restaurants_london <- as_data_frame(restaurants %>% html_nodes(".property_title") %>%
html_text())




                    