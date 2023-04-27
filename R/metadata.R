library(tidyverse)
library(rvest)

# functions to extract relevant metadata - title, release date, next updated, about this dataset, editions available

#generic function for retrieving html text
get_html_text <- function(ons_url, element_info){
  html_text_script <- read_html(ons_url) %>%
    html_elements(element_info) %>%
    html_text2()
  return(html_text_script)
}

#use generic function for retrieving html text within other get metadata functions
get_dataset_title <-function(ons_url){
  dataset_title <- get_html_text(ons_url,"h1.page-intro__title") %>%
    str_replace("Dataset ","")
  return(dataset_title)
}

get_release_date <- function(ons_url) {
  release_date <- get_html_text(ons_url,".meta__item:nth-child(2) .meta__term+ div")
  return(release_date)
}

get_next_updated <- function(ons_url) {
  next_update <- get_html_text(ons_url,".meta__item~ .meta__item+ .meta__item .meta__term+ div")
  return(next_update)
}

get_about_this_dataset <- function(ons_url){
  about_this_dataset <- get_html_text(ons_url, "#main section:nth-child(1)") %>%
    str_replace("(.*?)\n","")
  return(about_this_dataset)
}

get_available_editions <- function(ons_url){
  available_editions <- get_html_text(ons_url, "h3") %>%
    str_subset("edition")
  return(available_editions)
}

get_latest_edition <- function(ons_url){
  latest_edition <- get_available_editions(ons_url) %>%
    first()
  return(latest_edition)
}

# Higher level function that runs all functions above to get relevant metadata and return metadata as list with each element named properly
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

