setwd("V:/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/testing")
.libPaths("C:/Program Files/R/R-3.5.3/library")
events <- read.csv(file="data/events.csv", stringsAsFactors = FALSE)
summary(events)
devtools::install_github("shug0131/eudraCT/R/eudract", upgrade="never")
library(eudract)
?safety_summary
safety_counts <- safety_summary(events, exposed=c(20,22,18), soc_index="soc_term")
print(safety_counts)
simple_safety_xml(safety_counts, "simple_sjb.xml")
eudract_convert(input="simple_sjb.xml", output="table_eudract_sjb.xml")

#This uploads successfully to eudract training environment