#Check the GROUP file contains exactely the following variables: title, deathsResultingFromAdverseEvents, subjectsAffectedBySeriousAdverseEvents, subjectsAffectedByNonSeriousAdverseEvents, subjectsExposed, deathsAllCauses
setwd(file.path("V:", "STATISTICS", "NON STUDY FOLDER", "Academic Research", "Eudract Tool", "testing", "data", "input"))
getwd()

test_groupdata <- read.csv(file="GROUP.csv")
any(colnames(test_groupdata) == "title")
any(colnames(test_groupdata) == "deathsResultingFromAdverseEvents")
any(colnames(test_groupdata) == "subjectsAffectedBySeriousAdverseEvents")
any(colnames(test_groupdata) == "subjectsAffectedByNonSeriousAdverseEvents")
any(colnames(test_groupdata) == "subjectsExposed")
any(colnames(test_groupdata) == "deathsAllCauses")

#Check the variable title in the GROUP file is a string >=4 digits long
test_groupdata <- read.csv(file="GROUP.csv")
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
test_nonseriousdata <- read.csv(file="NONSERIOUS.csv")
any(colnames(test_nonseriousdata) == "groupTitle")
any(colnames(test_nonseriousdata) == "subjectsAffected")
any(colnames(test_nonseriousdata) == "occurrences")
any(colnames(test_nonseriousdata) == "term")
any(colnames(test_nonseriousdata) == "eutctId")


#Check the SERIOUS file contains exactely the following variables: groupTitle, subjectsAffected, occurrences, term, eutctId, occurrencesCausallyRelatedToTreatment, deaths, deathsCausallyRelatedToTreatment
test_seriousdata <- read.csv(file="SERIOUS.csv")
any(colnames(test_seriousdata) == "groupTitle")
any(colnames(test_seriousdata) == "subjectsAffected")
any(colnames(test_seriousdata) == "occurrences")
any(colnames(test_seriousdata) == "term")
any(colnames(test_seriousdata) == "eutctId")
any(colnames(test_seriousdata) == "occurrencesCausallyRelatedToTreatment")
any(colnames(test_seriousdata) == "deaths")
any(colnames(test_seriousdata) == "deathsCausallyRelatedToTreatment")

#Check all soc in the serious file are contained in the valid soc list
test_validsoc <- read.csv(file="all_soc.csv")
test_seriousdata <- read.csv(file="SERIOUS.csv")
serious_soc<-test_seriousdata$soc
soclist<- test_validsoc$soc
serious_soc %in% soclist

#Check all terms in the serious file are contained in the valid soc term list
test_validsoc <- read.csv(file="all_soc.csv")
test_seriousdata <- read.csv(file="SERIOUS.csv")
serious_term<-test_seriousdata$term
termlist<- test_validsoc$term
serious_term %in% termlist

#Check all soc in the nonserious file are contained in the valid soc list
test_validsoc <- read.csv(file="all_soc.csv")
test_nonseriousdata <- read.csv(file="NONSERIOUS.csv")
nonserious_soc<-test_nonseriousdata$soc
soclist<- test_validsoc$soc
nonserious_soc %in% soclist

#Check all terms in the nonserious file are contained in the valid soc term list
test_validsoc <- read.csv(file="all_soc.csv")
test_nonseriousdata <- read.csv(file="NONSERIOUS.csv")
nonserious_term<-test_nonseriousdata$term
termlist<- test_validsoc$term
nonserious_term %in% termlist

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

#Check all soc in the events file are contained in the valid soc list
options(max.print=1000000)
test_eventsdata <- read.csv(file="events.csv")
eventsdata_soc<-test_eventsdata$soc
test_validsoc <- read.csv(file="all_soc.csv")
soclist<- test_validsoc$soc
eventsdata_soc %in% soclist

#Check all terms in the events file are contained in the valid soc list
options(max.print=1000000)
test_eventsdata <- read.csv(file="events.csv")
eventsdata_term<-test_eventsdata$term
test_validterm <- read.csv(file="all_soc.csv")
termlist<- test_validterm$term
eventsdata_term %in% termlist

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