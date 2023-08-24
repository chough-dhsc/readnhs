
<!-- README.md is generated from README.Rmd. Please edit that file -->

# readnhs

<!-- badges: start -->
<!-- badges: end -->

readnhs aims to facilitate webscraping of datasets from the National
Health Service Digital website. It’s goal is to remove the manual steps
involved (and time taken) in navigating to an NHS-D webpage, searching
for the dataset of interest and downloading a local copy. It will be
particularly useful for incorporating into routine analysis that needs
to be regularly updated based on the latest NHS data.

## Installation

You can install the readnhs package as follows:

``` r
if (!requireNamespace("librarian")) install.packages("librarian")
librarian::shelf(DataS-DHSC/readnhs)
```

## Usage and Example

To use this package you will need the URL for the NHS webpage that
contains the embedded data you are trying to download and will need to
specify an end destination for where you would like to save the
downloaded data.

``` r
# Assign the URL of the NHS webpage that contains required data to nhs_url

nhs_url <- "https://digital.nhs.uk/data-and-information/publications/statistical/appointments-in-general-practice/june-2023"

# Assign the destination you would like to save the downloaded data into as destfilepath. Note that the file format must match the format of the file you are downloading and any new folder directories will be created if they do not already exist.

destfilepath <- "data.csv"

# Check order position of dataset of interest within the list of datasets available

get_all_nhs_data_urls(nhs_url)

# Assign the order position to item_number

item_number <- 4

# Download specified data to user specified destination

download_nhs_data(nhs_url, item_number, destfilepath)

# Retrieve relevant metadata (publication title, publication date, geographic coverage and granularity and date range)

get_metadata(nhs_url)
```
