# function to extract url of latest ods/xls/csv/xlsx/zip file on that webpage
# Checks URL is valid, then searches the nhs_url for any potential data links, turns relative links to absolute

#' Finds all embedded data links on an NHS webpage
#'
#' @param nhs_url The URL for the NHS webpage which contains embedded dataset link/s.
#'
#' @return data_urls - all data URLs on the webpage
#'
#' @importFrom RCurl url.exists
#' @importFrom rvest read_html
#' @importFrom rvest html_element
#' @importFrom rvest html_attr
#' @importFrom stringr str_subset
#' @importFrom xml2 url_absolute
#'
#' @export
#'
#' @examples
#' nhs_url <- paste("https://digital.nhs.uk/data-and-information/publications/",
#' "statistical/appointments-in-general-practice/june-2023", sep="")

#' get_all_nhs_data_urls(nhs_url)
#'

get_all_nhs_data_urls <- function(nhs_url) {

  # Tests it is a character string, if not stops
  if(!is.character(nhs_url)) {
    stop("Invalid input")
  }

  # Tests if URL exists, if not stops
  if(!url.exists(nhs_url)) {
    stop("Invalid URL")
  }

  data_urls <- read_html(nhs_url) %>%
    html_elements("a") %>%
    html_attr("href") %>%
    str_subset("\\.ods$|\\.xls$|\\.csv$|\\.xlsx$|\\.zip$") %>%
    url_absolute(nhs_url)

  # test that data links are available, if not stops
  if(length(data_urls) == 0) {
    stop("No data links available")
  }

  return(data_urls)
}

# function to download latest data to destination location
# (need to specify mode as wb(write binary) otherwise it will try to make the
# file compatible with Windows)

#' Downloads first (assuming most recent) dataset link embedded on ONS webpage
#' and saves in the user specified destination location (and will create new
#' folder directories if required)
#'
#' @param ons_url The URL for the ONS webpage which contains embedded dataset link/s.
#' @param destfilepath The destination location where you want to save the file.
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
#' destfilepath <- "data/cisdata.xlsx"
#'
#' download_latest_ons_data(ons_url, destfilepath)
#'
download_latest_ons_data <- function(ons_url, destfilepath) {

  #checks if destfile directory exists and if not creates it
  absolute_directory <- normalizePath(dirname(destfilepath), mustWork = FALSE)

  if(!dir.exists(absolute_directory)) {
    dir.create(absolute_directory)
    print(paste0("Directory did not exist and has been created: ", absolute_directory))
  }

  data_url <- get_latest_ons_data_url(ons_url)
  download.file(data_url, destfilepath, mode="wb")
  return(normalizePath(destfilepath))
}

