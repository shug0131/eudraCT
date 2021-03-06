#create output file using eudract_convert () 
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
library(xslt)
eudract_convert(input="simple_test.xml", output="table_eudract_test.xml")

#validate output file against a fresh download of xsd schema from https://eudract.ema.europa.eu/docs/technical/schemas/clinicaltrial/results/adverseEvents.xsd
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
library(xslt)
output <- read_xml("table_eudract_test.xml")
eudractschema <- read_xml(system.file("extdata", "adverseEvents.xsd", package = "eudract"))
xml_validate(output, eudractschema)