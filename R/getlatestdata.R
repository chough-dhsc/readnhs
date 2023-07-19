# function to extract url of latest xlsx file on that webpage
# Searches the ons_url for any xlsx links, turns relative links to absolute,
# then filters to the first (assuming most recent) link

#' Finds the first (assuming most recent) data (xlsx) URL on an ONS webpage
#'
#' @param ons_url The URL for the ONS webpage which contains embedded dataset link/s.
#'
#' @return data_url - the first, assuming most recent, data URL on the webpage
#'
#' @importFrom RCurl url.exists
#' @importFrom gdata first
#' @importFrom rvest read_html
#' @importFrom rvest html_element
#' @importFrom rvest html_attr
#' @importFrom stringr str_subset
#' @importFrom xml2 url_absolute
#'
#' @export
#'
#' @examples
#' ons_url <- paste("https://www.ons.gov.uk/peoplepopulationandcommunity/",
#' "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
#' "infectionsurveydata", sep="")
#'
#' get_latest_ons_data_url(ons_url)
#'
get_latest_ons_data_url <- function(ons_url) {
  if(RCurl::url.exists(ons_url)) { #URL validation test
    data_url <- rvest::read_html(ons_url) %>%
    rvest::html_elements("a") %>%
    rvest::html_attr("href") %>%
    stringr::str_subset(".xlsx") %>%
    xml2::url_absolute(ons_url) %>%
    gdata::first()
  return(data_url)
  } else {
  print("Invalid URL")
}
}

# function to download latest data to destination location
# (need to specify mode as wb(write binary) otherwise it will try to make the file compatible with Windows)

#' Downloads first (assuming most recent) dataset link embedded on ONS webpage
#'
#' @param ons_url The URL for the ONS webpage which contains embedded dataset link/s.
#' @param destfile The destination location where you want to save the file.
#'
#' @return The destination file path
#' @importFrom RCurl url.exists
#' @importFrom utils download.file
#' @export
#'
#' @examples
#' ons_url <- paste("https://www.ons.gov.uk/peoplepopulationandcommunity/",
#' "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
#' "infectionsurveydata", sep="")
#'
#'
#' destfile <- "data/cisdata.xlsx"
#'
#' download_latest_ons_data(ons_url, destfile)
#'
download_latest_ons_data <- function(ons_url, destfile) {
  if (!dir.exists(destfile)) {
    dir.create(destfile)}
  if(RCurl::url.exists(ons_url)) { #URL validation test
  data_url <- get_latest_ons_data_url(ons_url)
  utils::download.file(data_url, destfile, mode="wb")
  return(destfile)
  } else {
    print("Invalid URL")
  }
}


