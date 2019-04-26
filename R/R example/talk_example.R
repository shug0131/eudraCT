setwd("~/EudraCT/eudraCT/R/R example")
#install.packages("tidyr")
#install.packages("xslt")

source("eudract_tools.R")
load("safety.rda")
View(safety)
safety_statistics <- ae_stats(safety, exposed=c("Experimental"=60,"Control"=67))
safety_statistics
eudract_input(safety_statistics, "simple.xml")
eudract_convert(input="simple.xml", output="table_eudract.xml",
                xslt="simpleToEudraCT.xslt", schema_output="adverseEvents.xsd"
                )

