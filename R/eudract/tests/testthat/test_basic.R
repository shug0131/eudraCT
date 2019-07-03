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

library(RSelenium)
#http://support.divio.com/articles/646695-how-to-use-a-directory-outside-c-users-with-docker-toolbox-docker-for-windows
#docker run -d -p 4445:4444 -p 5901:5900 -v $(pwd):/home/statistics selenium/standalone-firefox-debug:2.53.0
remDr <- remoteDriver(
  remoteServerAddr = "192.168.99.100",
  port = 4445L,
  browserName = "firefox"
)
#remDr$close()
remDr$open()
remDr$navigate("https://eudract-training.ema.europa.eu/results-web/login/login.xhtml")
userid <- remDr$findElement(using = "name", value = "username")
userid$sendKeysToElement(list("w6a6w8"))
password <- remDr$findElement(using= "name", value="password")
password$sendKeysToElement(list("London2016",key="enter"))



#login <- remDr$findElement(using="value", value="Login")
#login$clickElement()

#script <- "mojarra.jsfcljs(document.getElementById('cta_form'),{'resultsInEditList:1:editCtaLink':'resultsInEditList:1:editCtaLink','resultToEdit':'0015-002811-13'},'')"
#remDr$executeScript(script, args = list())

edit_first_item <- remDr$findElement(using="id", value="resultsInEditList:1:editCtaLink")
edit_first_item$clickElement()

upload <- remDr$findElement(using="id", value="load_results")
upload$clickElement()

confirm <- remDr$findElement(using="id", value="confirmUpload")
confirm$clickElement()

select_ae <- remDr$findElement(using="xpath", value="//*/option[@value='ADVERSE_EVENTS']")
select_ae$clickElement()

#Can't work out hwo to interact with the file choose menu

add_file2 <-remDr$findElement(using="id", value="fileUploader:add1")
#might work - but still have to link the local files to the docker image...
remDr$getWindowHandles()
remDr$getCurrentWindowHandle()

remDr$sendKeysToAlert(list("boo"))

add_file$sendKeysToElement(list("hello"))

add_file2$clickElement()



remDr$screenshot(display=TRUE)
remDr$getTitle()


shell("docker stop $(docker ps -q)")
