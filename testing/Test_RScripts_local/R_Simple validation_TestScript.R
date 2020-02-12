#validate simple.xml against an xsd schema
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
library(xslt)
simple <- read_xml("simple_test.xml")
schema <- read_xml( system.file("extdata", "simple.xsd", package = "eudract") )
xml_validate(simple, schema)

#Check the tags GROUP, SERIOUS and NOT_SERIOUS are present
library(xml2)
simple_test <- read_xml("simple_test.xml")
xml_children(simple_test)

#Check the structure of the simple.xml and check the root <TABLE> </TABLE>
library(xml2)
simple_test <- read_xml("simple_test.xml")
xml_parent(simple_test)