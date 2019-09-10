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




