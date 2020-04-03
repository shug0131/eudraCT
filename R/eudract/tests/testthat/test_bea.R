#setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "R", "eudract", "tests", "testthat"))
#getwd()

library(testthat)
library(eudract)
library(stringr)
context("Bea's testing")

if( is_testing()){path <- tempdir()} else{ path <- "tests/testthat"}
oldop <- options(stringsAsFactors = FALSE)
test_that("presence of the minimal set of variables in the events.csv file", {
  test_eventsdata <- read.csv(file=file.path(path,"events.csv"))
  expect_named(test_eventsdata, c("subjid", "term","soc","serious","related","fatal","group"), ignore.order = TRUE)})

test_that("presence of the set of variables in the GROUP.csv file", {
  test_eventsdata <- read.csv(file=file.path(path,"GROUP.csv"))
  expect_named(test_eventsdata, c("title","deathsResultingFromAdverseEvents", "subjectsAffectedBySeriousAdverseEvents","subjectsAffectedByNonSeriousAdverseEvents","subjectsExposed","deathsAllCauses"), ignore.order = TRUE)})

test_that("presence of the minimal set of variables in the SERIOUS.csv file", {
  test_eventsdata <- read.csv(file=file.path(path,"SERIOUS.csv"))
  expect_named(test_eventsdata, c("groupTitle","subjectsAffected", "occurrences","term",#"eutctId",
                                  "soc",
                                  "occurrencesCausallyRelatedToTreatment","deaths","deathsCausallyRelatedToTreatment"), ignore.order = TRUE)})

test_that("presence of the minimal set of variables in the NONSERIOUS.csv file", {
  test_eventsdata <- read.csv(file=file.path(path,"NONSERIOUS.csv"))
  expect_named(test_eventsdata, c("groupTitle","subjectsAffected","occurrences", "term",#"eutctId"
                                  "soc"), ignore.order = TRUE)})

test_that("Check the variable title in the GROUP file is a string >=4 digits long", {
  test_groupdata <- read.csv(file=file.path(path,"GROUP.csv"))
  group_title<-min(nchar(as.character(test_groupdata$title)))
  expect_gte(group_title, 4)
})

options(oldop)
rm(oldop)
