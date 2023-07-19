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

test_that("broken url generates error", {
  ons_url <- paste0(
    "https://ww.ons.gov.uk/peoplpopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata"
  )
  df <- get_latest_ons_data_url(ons_url)

  result <- "Invalid URL"

  expect_equal(df, result)
})

test_that("url with no links to data generates error", {
  ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity"

  df <- get_latest_ons_data_url(ons_url)

  result <- "No data links available"

  expect_equal(df, result)
})

test_that("number parsed as ons_url generates error", {
  ons_url <- 999

  df <- get_latest_ons_data_url(ons_url)

  result <- "Invalid URL"

  expect_equal(df, result)
})

test_that("data is downloaded if valid destination inputted", {
  ons_url <- paste0(
    "https://www.ons.gov.uk/peoplepopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata"
  )
  destfile <- "data/cisdata.xlsx"

  df <- download_latest_ons_data(ons_url, destfile)

  result <- "data/cisdata.xlsx"

  expect_equal(df, result)
})

#unsure about this one as destfile is inputted and outputted

test_that("invalid destination generates error", {
  ons_url <- paste0(
    "https://www.ons.gov.uk/peoplepopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata"
  )
  destfile <- "datafoldertest/cisdata.xlsx"

  df <- download_latest_ons_data(ons_url, destfile)

  result <- "datafoldertest/cisdata.xlsx"

  expect_equal(df,result)
})

