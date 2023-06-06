#specify dependency packages
#' @import dplyr
#' @import magrittr
#' @import rvest

install.packages("magrittr")

# source metadata functions
source("R/metadata.R")

ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"

#retrieve metadata
get_metadata(ons_url)
get_available_editions(ons_url)

# function to extract url of latest xlsx file on that webpage
# Searches the ons_url for any xlsx links, turns relative links to absolute,
# then filters to the first (assuming most recent) link

#' Finds the first (assuming most recent) data (xlsx) URL on an ONS webpage
#'
#' @param ons_url The URL for the ONS webpage which contains embedded dataset link/s.
#'
#' @return data_url - the first, assuming most recent, data URL on the webpage
#' @export get_latest_ons_data_url
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_latest_ons_data_url(ons_url)
#'
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

#' Downloads first (assuming most recent) dataset link embedded on ONS webpage
#'
#' @param ons_url The URL for the ONS webpage which contains embedded dataset link/s.
#' @param destfile The destination location where you want to save the file.
#'
#' @return The destination file path
#' @export download_latest_ons_data
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' destfile <- "data/cisdata.xlsx"
#'
#' download_latest_ons_data(ons_url, destfile)
#'
download_latest_ons_data <- function(ons_url, destfile) {
  data_url <- get_latest_ons_data_url(ons_url)
  download.file(data_url, destfile, mode="wb")
  return(destfile)
}

