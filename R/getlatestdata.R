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

#' Select the data link of interest from all embedded data links on an NHS webpage
#'
#' @param nhs_url The URL for the NHS webpage which contains embedded dataset link/s.
#' @param item_number The element number (based on element order in data_urls) of the URL of interest
#'
#' @return data_url - the data URL of interest on the webpage
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
#'
#' item_number <- 4

#' select_nhs_data_url(nhs_url, item_number)
#'


select_nhs_data_url <- function(nhs_url, item_number) {

  data_urls <- get_all_nhs_data_urls(nhs_url)

  data_url <- data_urls[item_number]

  return(data_url)

}

# function to download latest data to destination location
# (need to specify mode as wb(write binary) otherwise it will try to make the
# file compatible with Windows)

#' Downloads specified dataset link embedded on NHS webpage
#' and saves in the user specified destination location (and will create new
#' folder directories if required)
#'
#' @param nhs_url The URL for the NHS webpage which contains embedded dataset link/s.
#' @param item_number The element number (based on element order in data_urls) of the URL of interest
#' @param destfilepath The destination location where you want to save the file.
#'
#' @return The destination file path
#' @importFrom RCurl url.exists
#' @importFrom utils download.file
#' @export
#'
#' @examples
#' nhs_url <- paste("https://digital.nhs.uk/data-and-information/publications/",
#' "statistical/appointments-in-general-practice/june-2023", sep="")
#'
#' item_number <- 4
#'
#' destfilepath <- "data.xlsx"
#'
#' download_latest_nhs_data(nhs_url, 4, destfilepath)
#'

download_latest_nhs_data <- function(nhs_url, item_number, destfilepath) {

  #checks if destfile directory exists and if not creates it
  absolute_directory <- normalizePath(dirname(destfilepath), mustWork = FALSE)

  if(!dir.exists(absolute_directory)) {
    dir.create(absolute_directory)
    print(paste0("Directory did not exist and has been created: ", absolute_directory))
  }

  data_url <- select_nhs_data_url(nhs_url, item_number)

  download.file(data_url, destfilepath, mode="wb")

  return(normalizePath(destfilepath))
}

