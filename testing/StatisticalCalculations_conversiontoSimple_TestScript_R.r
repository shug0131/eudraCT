#Create a safety summary set with known values using Soc_term
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
test_eventsdata <- read.csv(file="events.csv",  stringsAsFactors = FALSE)
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="soc_term")
print(safety_counts)

#Create a safety summary set with known values using meddra
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
library(dplyr)
test_eventsdata <- read.csv(file="events.csv",  stringsAsFactors = FALSE)
events <- left_join(test_eventsdata, soc_code, by=c("soc"="soc_term"))
index <- names(events)=="soc"
names(events)[index]<-"soc_term"
index <- names(events) =="meddra"
names(events)[index]<-"soc"
events<-events[names(events)!="eutctId"]
safety_counts <- safety_summary(test_eventsdata, exposed=c(20,22,18), soc_index="meddra")
print(safety_counts)

#Export the 3 .csv files separately
write.csv(safety_counts$GROUP, file = "GROUP_test.csv")
write.csv(safety_counts$SERIOUS, file = "SERIOUS_test.csv")
write.csv(safety_counts$NON_SERIOUS, file = "NON_SERIOUS_test.csv")

#Check the GROUP file contains exactely the following variables: title, deathsResultingFromAdverseEvents, subjectsAffectedBySeriousAdverseEvents, subjectsAffectedByNonSeriousAdverseEvents, subjectsExposed, deathsAllCauses
test_groupdata <- read.csv(file="GROUP_test.csv")
any(colnames(test_groupdata) == "title")
any(colnames(test_groupdata) == "deathsResultingFromAdverseEvents")
any(colnames(test_groupdata) == "subjectsAffectedBySeriousAdverseEvents")
any(colnames(test_groupdata) == "subjectsAffectedByNonSeriousAdverseEvents")
any(colnames(test_groupdata) == "subjectsExposed")
any(colnames(test_groupdata) == "deathsAllCauses")

#Check the variable title in the GROUP file is a string >=4 digits long
test_groupdata <- read.csv(file="GROUP_test.csv")
group_title<-test_groupdata$title
library(stringi)

for (value in group_title){
	if(stri_length(value)>3) {
		print("Value is longer than 3 digits")
	} else {
		print(value)
	}
}

#Check the NONSERIOUS file contains exactely the following variables: groupTitle, subjectsAffected, occurrences, term, eutctId
test_nonseriousdata <- read.csv(file="NON_SERIOUS_test.csv")
any(colnames(test_nonseriousdata) == "groupTitle")
any(colnames(test_nonseriousdata) == "subjectsAffected")
any(colnames(test_nonseriousdata) == "occurrences")
any(colnames(test_nonseriousdata) == "term")
any(colnames(test_nonseriousdata) == "eutctId")

#Check the SERIOUS file contains exactely the following variables: groupTitle, subjectsAffected, occurrences, term, eutctId, occurrencesCausallyRelatedToTreatment, deaths, deathsCausallyRelatedToTreatment
test_seriousdata <- read.csv(file="SERIOUS_test.csv")
any(colnames(test_seriousdata) == "groupTitle")
any(colnames(test_seriousdata) == "subjectsAffected")
any(colnames(test_seriousdata) == "occurrences")
any(colnames(test_seriousdata) == "term")
any(colnames(test_seriousdata) == "eutctId")
any(colnames(test_seriousdata) == "occurrencesCausallyRelatedToTreatment")
any(colnames(test_seriousdata) == "deaths")
any(colnames(test_seriousdata) == "deathsCausallyRelatedToTreatment")

#Check all terms in the serious file are contained in the valid soc term list
test_validsoc <- read.csv(file="all_soc.csv")
test_seriousdata <- read.csv(file="SERIOUS_test.csv")
serious_term<-test_seriousdata$term
termlist<- test_validsoc$term
serious_term %in% termlist

#Export the statistical calculation in simple XML format file after conversion
simple_safety_xml(safety_counts, "simple_test.xml")

#Compare safety summary created to input files: subjectsAffectedBySeriousAdverseEvents
library(dplyr)
test_groupdata <- read.csv(file="GROUP_test.csv")
serious_group<-test_groupdata %>% select(title, subjectsAffectedBySeriousAdverseEvents)
test_eventsdata <- read.csv(file="events.csv")
test_serious <- test_eventsdata %>% filter (serious==1) %>% group_by(group) %>% summarise(subjectsAffectedBySeriousAdverseEvents=n_distinct(subjid))
colnames(test_serious)[colnames(test_serious)=="group"] <- "title"
all_equal(test_serious, serious_group)

#Compare safety summary created to input files: subjectsAffectedByNonSeriousAdverseEvents
library(dplyr)
test_groupdata <- read.csv(file="GROUP_test.csv")
nonserious_group<-test_groupdata %>% select(title, subjectsAffectedByNonSeriousAdverseEvents)
test_eventsdata <- read.csv(file="events.csv")
test_nonserious <- test_eventsdata %>% filter (serious==0) %>% group_by(group) %>% summarise(subjectsAffectedByNonSeriousAdverseEvents=n_distinct(subjid))
colnames(test_nonserious)[colnames(test_nonserious)=="group"] <- "title"
all_equal(test_nonserious, nonserious_group)

#Compare safety summary created to input files: deathsResultingFromAdverseEvents
library(dplyr)
test_groupdata <- read.csv(file="GROUP_test.csv")
deaths_group<-test_groupdata %>% select(title, deathsResultingFromAdverseEvents)
test_eventsdata <- read.csv(file="events.csv")
test_death <- test_eventsdata %>% filter (fatal==1) %>% group_by(group) %>% summarise(deathsResultingFromAdverseEvents=n_distinct(subjid))
colnames(test_death)[colnames(test_death)=="group"] <- "title"
all_equal(test_death, deaths_group)

#Check the output is created "simple.xml"
input.good="V:/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/testing/data/simple_test.xml"
input.bad="V:/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/testing/data/"
file_test("-f", input.good)
file_test("-f", input.bad)

#Same PT different SOC
test_seriousdata <- read.csv(file="SERIOUS_test.csv")
test_ptVSsoc<- test_seriousdata %>% group_by(term,eutctId) %>% summarise(test=n_distinct(term))                                                                               
print(test_ptVSsoc)


#0 %in% simple.xml
library(xml2)
simple <- read_xml("simple_test.xml")
xml_structure(simple)
xml_attr(simple)


#validate simple.xml against an xsd schema
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data"))
getwd()
library(eudract)
library(xslt)
simple <- read_xml("simple_test.xml")
schema <- read_xml( system.file("extdata", "simple.xsd", package = "eudract") )
xml_validate(simple, schema)