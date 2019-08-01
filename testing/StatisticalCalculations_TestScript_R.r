#Create a safety summary set with known values 
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
group <- read.csv(file="GROUP.csv")
non_serious <- read.csv(file="NONSERIOUS.csv")
serious <- read.csv(file="SERIOUS.csv")
create.safety_summary(group, non_serious, serious)