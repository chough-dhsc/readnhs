# functions to extract relevant metadata - title, release date, next updated, about this dataset, editions available

#generic function for retrieving html text
#' Retrieves html text
#'
#' @param ons_url The ONS URL from which you want to read text.
#' @param element_info The html element you want to read.
#'
#' @return html_text_script The text from the element you have specified.
#' @export get_html_text
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' element_info <- "h1.page-intro__title"
#'
#' get_html_text(ons_url, element_info)

get_html_text <- function(ons_url, element_info){
  html_text_script <- read_html(ons_url) %>%
    html_elements(element_info) %>%
    html_text2()
  return(html_text_script)
}

#use generic function for retrieving html text within other get metadata functions
#' Retrieves dataset title from ONS webpage
#'
#' @param ons_url The ONS URL which contains the embedded dataset link.
#'
#' @return dataset_title The title of the dataset.
#' @export get_dataset_title
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_dataset_title(ons_url)
#'
get_dataset_title <-function(ons_url){
  dataset_title <- get_html_text(ons_url,"h1.page-intro__title") %>%
    str_replace("Dataset ","")
  return(dataset_title)
}

#' Retrieves the release date of the latest dataset available
#'
#' @param ons_url The ONS URL which contains the embedded dataset link.
#'
#' @return release_date The release date of the latest dataset available.
#' @export get_release_date
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_release_date(ons_url)

get_release_date <- function(ons_url) {
  release_date <- get_html_text(ons_url,".meta__item:nth-child(2) .meta__term+ div")
  return(release_date)
}

#' Retrieves the date the next version of the dataset will be made available
#'
#' @param ons_url The ONS URL which contains the embedded dataset link.
#'
#' @return next_update The date the next version of the dataset will be made available
#' @export get_next_updated
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_next_updated(ons_url)

get_next_updated <- function(ons_url) {
  next_update <- get_html_text(ons_url,".meta__item~ .meta__item+ .meta__item .meta__term+ div")
  return(next_update)
}

#' Retrieves additional information about this dataset
#'
#' @param ons_url The ONS URL which contains the embedded dataset link.
#'
#' @return about_this dataset Additional information provided by ONS about this dataset.
#' @export get_about_this_dataset
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_about_this_dataset(ons_url)

get_about_this_dataset <- function(ons_url){
  about_this_dataset <- get_html_text(ons_url, "#main section:nth-child(1)") %>%
    str_replace("(.*?)\n","")
  return(about_this_dataset)
}

#' Retrieves a list of all available editions of the dataset
#'
#' @param ons_url The ONS URL which contains the embedded dataset link.
#'
#' @return available_editions A list of all available editions of the dataset.
#' @export get_available_editions
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_available_editions(ons_url)

get_available_editions <- function(ons_url){
  available_editions <- get_html_text(ons_url, "h3") %>%
    str_subset("edition")
  return(available_editions)
}

#' Retrieves the latest(first listed) edition name of the dataset
#'
#' @param ons_url The ONS URL which contains the embedded dataset link.
#'
#' @return latest_edition The latest edition name of the dataset
#' @export get_latest_edition
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_latest_edition(ons_url)

get_latest_edition <- function(ons_url){
  latest_edition <- get_available_editions(ons_url) %>%
    first()
  return(latest_edition)
}

# Higher level function that runs all functions above to get relevant metadata and return metadata as list with each element named properly
#' Higher level function that retrieves relevant metadata for ONS datasets
#'
#' @param ons_url The ONS URL which contains the embedded dataset link.
#'
#' @return metadata A list containing the dataset title, latest edition, release date, when it will next be updated and additional information about the dataset.
#' @export get_metadata
#'
#' @examples
#' ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"
#'
#' get_metadata(ons_url)

get_metadata <- function(ons_url){

  metadata <- list(
    dataset_title = get_dataset_title(ons_url),
    about_this_dataset = get_about_this_dataset(ons_url),
    latest_edition = get_latest_edition(ons_url),
    release_date = get_release_date(ons_url),
    next_updated = get_next_updated(ons_url)
  )

  return(metadata)
}

