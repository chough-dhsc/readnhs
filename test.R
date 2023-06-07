
devtools::load_all()

ons_url <- "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/coronaviruscovid19infectionsurveydata"

#retrieve metadata
get_metadata(ons_url)
get_available_editions(ons_url)
