test_that("valid url generates right output", {
  ons_url <- paste0(
    "https://www.ons.gov.uk/peoplepopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata"
  )

  element_info <- "h1.page-intro__title"

  df <- get_html_text(ons_url, element_info)

  result <- "Dataset Coronavirus (COVID-19) Infection Survey: England"

  expect_equal(df, result)
})

test_that("broken url generates error", {
  ons_url <- paste0(
    "https://ww.ons.gov.uk/peoplpopulationandcommunity/",
    "healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19",
    "infectionsurveydata"
  )

  element_info <- "h1.page-intro__title"

  df <- get_html_text(ons_url, element_info)

  result <- "Invalid URL"

  expect_equal(df, result)
})

test_that("number parsed as ons_url generates error", {
  ons_url <- 999

  element_info <- "h1.page-intro__title"

  df <- get_html_text(ons_url, element_info)

  result <- "Invalid URL"

  expect_equal(df, result)
})

#test if html element input is invalid
