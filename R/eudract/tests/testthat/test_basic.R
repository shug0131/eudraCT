context("basic test")
library(eudract)
library(xml2)

safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))

test_that("create stats",{
expect_is(safety_statistics,"safety_summary")
expect_equal(length(safety_statistics),3)
expect_is(safety_statistics[[1]],"data.frame")
}
)

test_that("create simple xml",{
file.remove("simple.xml")
simple_safety_xml(safety_statistics, "simple.xml")
new <- read_xml("simple.xml")
ref <- read_xml("reference/simple.xml")
expect_equal(new,ref)
  }
)

test_that("convert to eudract",{
  file.remove("table_eudract.xml")
  eudract_convert(input="simple.xml", output="table_eudract.xml")
  new <- read_xml("table_eudract.xml")
  ref <- read_xml("reference/table_eudract.xml")
  expect_equal(new,ref)
}
)

