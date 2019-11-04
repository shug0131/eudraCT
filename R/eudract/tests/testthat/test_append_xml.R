library(testthat)
library(eudract)
if( is_testing()){path <- tempdir()} else{ path <- "tests/testthat"}

test_that("append_xml",{
  safety2 <- safety
  safety2$llt <- NA
  file_path <- paste0(path,"/copy_safety.xml")
  if(file.exists(file_path)){file.remove(file_path)}
  file_con <- file(file_path, open="w")
  append_xml(safety2, file_con)
  close(file_con)
  x <- readLines(file_path)
  expect_equal(x[2], "<safety2>")
  expect_equal(x[11], "\t<llt/>")
  file.remove(file_path)
}
)
