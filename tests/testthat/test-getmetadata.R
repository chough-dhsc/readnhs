test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


expect_match(object, regexp, ...) is a shortcut that wraps grepl(pattern = regexp, x = object, ...). It matches a character vector input against a regular expression regexp. The optional all argument controls whether all elements or just one element needs to match. Read the expect_match() documentation to see how additional arguments, like ignore.case = FALSE or fixed = TRUE, can be passed down to grepl().
functions to extract relevant metadata - title, release date, next updated, about this dataset, editions available

expect_contains()

#test ons_url is string and contains http/www
#get_html_text - check it returns a string

#get_dataset_title - dataset_title is string. If remove step str_replace it should contain "Dataset" - just something you put in your code to check it, error message that they are not using standard template

#get_release_date - check it returns a string that looks like a date format?

#get_next_updated - check it returns string, that looks like a date format or 'Discontinued' or

#get_about_this_dataset - returns string, and if remove str_replace returns text including 'About this dataset'

#get_available_editions - returns available_editions (is a vector/list)

#get_latest_edition - test it returns single string and is first row of get_available_editions

#get_metadata - returns list of strings with 5 items

#put a link to onsr in readme for api

#don't need to check it is a string -my particular use case is it should return a string that looks like X. if it doesnt then it will fail, if it fails, should give message to user
#if it reads from a file that's empty, throw an error or return an empty object

#unit testing is just that given set of inputs, you get right outputs, wrong inputs, gives wrong outputs, give something strange behaves how you want it to
