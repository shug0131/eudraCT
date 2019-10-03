library(testthat)
library(eudract)
library(stringi)

test_that("Check the variable title in the GROUP file is a string >=4 digits long",

          {

            test_groupdata <- read.csv(file="GROUP.csv")
            group_title<-test_groupdata$title

            for (value in group_title){
              if(stri_length(value)>3) {
                print("Value is longer than 3 digits")
              } else {
                print(value)
              }
            }



          }
          )
