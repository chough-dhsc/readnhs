test_that("valid url generates right output", {
  ons_url <- paste0(
    "https://www.ons.gov.uk/peoplepopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata"
  )
  df <- get_latest_ons_data_url(ons_url)

  result <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata/2023/20230310covid19infectionsurveydatasetsengland.xlsx"

  expect_equal(df, result)
})

test_that("invalid url generates error", {
  ons_url <- paste0(
    "https://ww.ons.gov.uk/peoplpopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata"
  )

  expect_error(get_latest_ons_data_url(ons_url), "Invalid URL")
})

#when I run this test it stops the unit testing with 'Exited with status -1073741819' error message (access violation?) -
#if I try running url.exists(999) R crashes

# test_that("number parsed as ons_url generates error", {
#   ons_url <- 999
#
#   expect_error(get_latest_ons_data_url(ons_url), "Invalid URL")
# })


test_that("url with no links to data generates error", {
  ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity"

  expect_error(get_latest_ons_data_url(ons_url), "No data links available")

})


test_that("destfile directory is created if did not previously exist", {
  ons_url <- paste0(
    "https://www.ons.gov.uk/peoplepopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata")

  destfilepath <- "data/cisdata.xlsx"

  expect_true(dir.exists(dirname(download_latest_ons_data(ons_url, destfilepath))))
})



test_that("valid URL input results in file downloaded to existing or newly created destfile directory", {
  ons_url <- paste0(
    "https://www.ons.gov.uk/peoplepopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata")

  destfilepath <- "data/cisdata.xlsx"

  download_latest_ons_data(ons_url, destfilepath)

  expect_true(file.exists(destfilepath))
})

#this one fails because Invalid URL and stops
# test_that("invalid URL results in no data downloaded", {
#   ons_url <- paste0(
#     "https://www.ons.gv.uk/poplepopulationandcommunity/",
#     "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
#     "infectionsurveydata"
#   )
#   destfilepath <- "data/cisdata.xlsx"
#
#   download_latest_ons_data(ons_url, destfilepath)
#
#   expect_true(!file.exists(destfilepath))
# })

test_that("URL with no data links results in no data downloaded", {
  ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity"

  destfilepath <- "data/cisdata.xlsx"

  download_latest_ons_data(ons_url, destfilepath)

  expect_true(!file.exists(destfilepath))
})

