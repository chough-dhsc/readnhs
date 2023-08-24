# functions to extract relevant metadata - title, release date, next updated, about this dataset, editions available

# generic function for retrieving html text
#' Retrieves html text
#'
#' @param nhs_url The NHS URL from which you want to read text.
#' @param element_info The html element you want to read.
#'
#' @return html_text_script The text from the element you have specified.
#'
#' @importFrom rvest read_html
#' @importFrom rvest html_elements
#' @importFrom rvest html_text2
#' @importFrom RCurl url.exists
#' @export
#'
#' @examples
#' nhs_url <- paste("https://digital.nhs.uk/data-and-information/publications/",
#' "statistical/appointments-in-general-practice/june-2023", sep="")
#'
#' element_info <- "dt.nhsd-o-hero__meta-data-item-title"
#'
#' get_html_text(nhs_url, element_info)

get_html_text <- function(nhs_url, element_info){

  # Tests nhs_url is a character object, if not stops
  if(!is.character(nhs_url)) {
    stop("Invalid input")
  }

  # URL validation test
  if(!url.exists(nhs_url)) {
    stop("Invalid URL")
  }

  # Tests element_info is a single character string, if not stops
  if(!is.character(element_info) | length(element_info) != 1) {
    stop("Invalid element information input")
  }

  html_text_script <- read_html(nhs_url) %>%
    html_elements(element_info) %>%
    html_text2()
  return(html_text_script)
}

# use generic function for retrieving html text within other get metadata functions
#' Retrieves metadata from NHS webpage
#'
#' @param nhs_url The NHS URL which contains the embedded dataset link.
#'
#' @return metadata A table containing the publication title, publication date, geographic coverage and granularity and date range.
#' @importFrom
#' @export
#'
#' @examples
#' nhs_url <- paste("https://digital.nhs.uk/data-and-information/publications/",
#' "statistical/appointments-in-general-practice/june-2023", sep="")
#'
#' get_metadata(nhs_url)
#'

get_metadata <- function(nhs_url){

  metadata_headings <- c("Dataset Title",
                         get_html_text(nhs_url,"dt.nhsd-o-hero__meta-data-item-title"))

  metadata_content <- c(get_html_text(nhs_url,"h1.nhsd-t-heading-xxl"),
                        get_html_text(nhs_url,"dd.nhsd-o-hero__meta-data-item-description"))

  metadata <- bind_cols(metadata_headings, metadata_content)

  return(metadata)
}

