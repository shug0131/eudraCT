# Test when the varnames are missing some

# Test when there are extra superfluous variables


# want there to be no group at all for nonserious, and a warning

if( is_testing()){path <- "."} else{ path <- "tests/testthat"}

test_that("no aes",
          {

            no_aes <- read.csv(file.path(path,"data/no_aes.csv"), stringsAsFactors = FALSE)
            expect_warning(output <- safety_summary(no_aes, exposed=10, soc="soc_term"))
            expect_equal( names(output), c("GROUP", "SERIOUS"))
            simple_safety_xml(output, "test_simple.xml")
            expect_true(eudract_convert( "test_simple.xml","test_output.xml") )


          }
            )

test_that("no saes",
          {
            no_saes <- read.csv(file.path(path,"data/no_saes.csv"), stringsAsFactors = FALSE)
            expect_warning(output <- safety_summary(no_saes, exposed=10, soc="soc_term"))
            expect_equal( names(output), c("GROUP", "NON_SERIOUS"))
            simple_safety_xml(output, "test_simple.xml")
            expect_true(eudract_convert( "test_simple.xml","test_output.xml") )

          }
)

# need to write a test when there are no events at all for a group
test_that("empty group",
          {
            no_saes <- read.csv(file.path(path,"data/no_saes.csv"), stringsAsFactors = FALSE)
            expect_error(output <- safety_summary(no_saes, exposed=c(10,10), soc="soc_term"))
            expect_error(
              output <- safety_summary(no_saes,
                                       exposed=c("Experimental"=10,"Control"=10),
                                       soc="soc_term")
            )
            expect_warning(
              output <- safety_summary(no_saes,
                                       exposed=c("Experiment"=10,"Control"=10),
                                       soc="soc_term")
            )
            expect_equal(nrow(output$GROUP),2)
            simple_safety_xml(output, "test_simple.xml")
            expect_true(eudract_convert( "test_simple.xml","test_output.xml") )
            }
)

test_that("missing variable",{
  aes <- read.csv(file.path(path,"data/events.csv"), stringsAsFactors = FALSE)
  expect_is(safety_summary(aes, exposed=c(700,750,730), soc_index = "soc_term"),"safety_summary")
  expect_error(safety_summary(aes[,-2], exposed=c(700,750,730), soc_index = "soc_term"),"your input data are missing the following variables:")
})

test_that("exposed is too short",{
  aes <- read.csv(file.path(path,"data/events.csv"), stringsAsFactors = FALSE)
  expect_is(safety_summary(aes, exposed=c(700,750,730), soc_index = "soc_term"),"safety_summary")
  expect_error(safety_summary(aes, exposed=c(700,750), soc_index = "soc_term"),"the argument 'exposed' has fewer elements than the number of groups")

})
test_that("wrong lenght for excess deaths",{
  aes <- read.csv(file.path(path,"data/events.csv"), stringsAsFactors = FALSE)
  expect_is(safety_summary(aes, exposed=c(700,750,730), soc_index = "soc_term"),"safety_summary")
  expect_error(safety_summary(aes, exposed=c(700,750,730),
                              excess_deaths = c(1,2),
                              soc_index = "soc_term"),
               "the argument 'excess_deaths' needs to be the same length as the number of groups")

})

test_that("wrong class input to simple_safety_xml",
          { expect_error(simple_safety_xml(1:10,"simple.xml"), "is not a safety_summary object")}
          )


test_that("induced errors in the safety_summary output",
          {
            aes <- read.csv(file.path(path,"data/events.csv"), stringsAsFactors = FALSE)
            safety_stats <- safety_summary(aes, exposed=c(700,750,730), soc_index = "soc_term")
            x <- safety_stats$SERIOUS$groupTitle
            x <- ifelse(x=="Group A", "Placebo",x)
            safety_stats$SERIOUS$groupTitle <- x
            expect_warning( simple_safety_xml(safety_stats,"simple.xml") )
            expect_error(eudract_convert("simple.xml","eudract.xml"))
          }
          )
