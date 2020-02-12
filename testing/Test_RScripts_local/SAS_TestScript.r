#INPUT
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()

#Check the presence of the minimal set of variables: subjid, term, soc, serious, related, fatal, group
test_eventsdata <- read.csv(file="events.csv")
any(colnames(test_eventsdata) == "subjid")
any(colnames(test_eventsdata) == "term")
any(colnames(test_eventsdata) == "soc")
any(colnames(test_eventsdata) == "serious")
any(colnames(test_eventsdata) == "related")
any(colnames(test_eventsdata) == "fatal")
any(colnames(test_eventsdata) == "group")

#Check variable 'term' is not null
test_eventsdata <- read.csv(file="events.csv")
termlist<- test_eventsdata$term
is.null(termlist)

#Check values for Serious, Related and Fatal in the events file
options(max.print=1000000)
test_eventsdata <- read.csv(file="events.csv")
valid_values <- c(1,0)
serious<- test_eventsdata$serious
serious %in% valid_values
related<- test_eventsdata$related
related %in% valid_values
fatal<- test_eventsdata$fatal
fatal %in% valid_values

#OUTPUT
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "SAS", "output"))
getwd()

#Check the output is created "simple.xml"
input.good="V:/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/testing/SAS/output/simple.xml"
input.bad="V:/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/testing/SAS/output/"
file_test("-f", input.good)
file_test("-f", input.bad)

#validate simple.xml against an xsd schema
library(eudract)
library(xslt)
simple <- read_xml("simple.xml")
schema <- read_xml( system.file("extdata", "simple.xsd", package = "eudract") )
xml_validate(simple, schema)

#Check the tags GROUP, SERIOUS and NON_SERIOUS are present
options(max.print=1000000)
library(xml2)
simple_test <- read_xml("simple.xml")
xml_children(simple_test)

#Check the structure of the simple.xml and check the root <TABLE> </TABLE>
options(max.print=1000000)
library(xml2)
simple_test <- read_xml("simple_test.xml")
xml_parent(simple_test)

#validate output file against a fresh download of xsd schema from https://eudract.ema.europa.eu/docs/technical/schemas/clinicaltrial/results/adverseEvents.xsd
library(eudract)
library(xslt)
output <- read_xml("table_eudract.xml")
eudractschema <- read_xml(system.file("extdata", "adverseEvents.xsd", package = "eudract"))
xml_validate(output, eudractschema)
