#Check values for Serious, Related and Fatal in the events file with integer substitution in Serious
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
options(max.print=1000000)
test_eventsdata <- read.csv(file="character_serious.csv")
valid_values <- c(1,0)
serious<- test_eventsdata$serious
serious %in% valid_values
test_eventsdata <- read.csv(file="date_serious.csv")
valid_values <- c(1,0)
serious<- test_eventsdata$serious
serious %in% valid_values
test_eventsdata <- read.csv(file="character_related.csv")
valid_values <- c(1,0)
related<- test_eventsdata$related
related %in% valid_values
test_eventsdata <- read.csv(file="date_related.csv")
valid_values <- c(1,0)
related<- test_eventsdata$related
related %in% valid_values
test_eventsdata <- read.csv(file="character_fatal.csv")
valid_values <- c(1,0)
fatal<- test_eventsdata$fatal
fatal %in% valid_values
test_eventsdata <- read.csv(file="date_fatal.csv")
valid_values <- c(1,0)
fatal<- test_eventsdata$fatal
fatal %in% valid_values

#Create summary statistics from a rectangular file contaning invalid values for serious (character, date)
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
test_eventsdata <- read.csv(file="character_serious.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="date_serious.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="float_serious.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="logical_serious.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")

#Create summary statistics from a rectangular file contaning invalid values for related (character, date)
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
test_eventsdata <- read.csv(file="character_related.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="date_related.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="float_related.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="logical_related.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")

#Create summary statistics from a rectangular file contaning invalid values for fatal (character, date, float)
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
test_eventsdata <- read.csv(file="character_fatal.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="date_fatal.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="float_fatal.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="logical_fatal.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")

#Create summary statistics from a rectangular file with a missing variable
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
test_eventsdata <- read.csv(file="delete_term.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="delete_soc.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
test_eventsdata <- read.csv(file="delete_subjid.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")

#Create summary statistics from a rectangular file using exposed numbers there are smaller than occurrences
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
test_eventsdata <- read.csv(file="events.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(1,2,3), soc_index="soc_term")

#Create summary statistics from a rectangular file using exposed numbers there are smaller than occurrences
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
test_eventsdata <- read.csv(file="events_wrongvariable.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(1,2,3), soc_index="soc_term")

#validate invalid simple.xml against an xsd schema
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
library(xslt)
simple <- read_xml("simple_negtest.xml")
schema <- read_xml( system.file("extdata", "simple.xsd", package = "eudract") )
xml_validate(simple, schema)

#create output file using eudract_convert () form invalid simple.xml
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
library(xslt)
eudract_convert(input="simple_negtest.xml", output="table_eudract_test.xml")

#create output file using eudract_convert () form invalid simple.xml where some zeros are missing
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "bad_data"))
getwd()
library(eudract)
library(xslt)
eudract_convert(input="simple_missingzero.xml", output="table_eudract_test.xml")