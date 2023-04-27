# load packages
if (!requireNamespace("librarian")) install.packages("librarian")

librarian::shelf(rvest, dplyr, tidyverse, readxl)

# source metadata functions
source("src/get_ons_metadata.r")

#retrieve metadata
get_metadata(ons_url)
get_available_editions(ons_url)

# function to extract url of latest xlsx file on that webpage
# Searches the ons_url for any xlsx links, turns relative links to absolute,
# then filters to the first (assuming most recent) link

get_latest_ons_data_url <- function(ons_url) {
  data_url <- read_html(ons_url) %>%
    html_elements("a") %>%
    html_attr("href") %>%
    str_subset(".xlsx") %>%
    url_absolute(ons_url) %>%
    first()
  return(data_url)
}

# function to download latest data to destination location
# (need to specify mode as wb(write binary) otherwise it will try to make the file compatible with Windows)

download_latest_ons_data <- function(ons_url, destfile) {
  data_url <- get_latest_ons_data_url(ons_url)
  download.file(data_url, destfile, mode="wb")
  return(destfile)
}

