install.packages("devtools")
devtools::install_github("shug0131/eudraCT/R/eudract")
library(eudract)
test_data <- read.csv(file="test.csv")
safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
safety_statistics
simple_safety_xml(safety_statistics, file="simple.xml")
library(xslt)
simple <- read_xml("simple.xml")
schema <- read_xml( system.file("extdata", "simple.xsd", package =
                                  "eudract") )
xml_validate(simple, schema)
eudract_convert(input="simple.xml", output="table_eudract.xml")
