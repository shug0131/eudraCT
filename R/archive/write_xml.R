setwd("V:\\STATISTICS\\NON STUDY FOLDER\\Academic Research\\Eudract Tool")
group <- read.csv(file="xslt material/group.csv", stringsAsFactors = FALSE)
serious <- read.csv(file="xslt material/serious.csv", stringsAsFactors = FALSE)
non_serious <- read.csv(file="xslt material/non_serious.csv", stringsAsFactors = FALSE)


  
library(dplyr)
library(magrittr)
library(xml2)

non_serious %<>% select( group, subjectsAffected, occurrences, term, eutctId ) %>%
  rename( groupTitle=group)

serious %<>% select(group, subjectsAffected, occurrences, term, eutctId,
                              occurrencesCausallyRelatedToTreatment, deaths,
                              deathsCausallyRelatedToTreatment) %>%
  rename( groupTitle=group)



  

append_xml <- function(data, file_connection){
  data_name <- deparse(substitute(data))
  var_names <- names(data)
  for(row in 1:nrow(data)){
    writeChar(paste0("\n<",data_name,">\n"), con=file_connection, eos=NULL)
    for( var in var_names){
      x <- as.character(data[row,var])
      if(is.na(x)){
        writeChar(paste0("\t<",var,"/>\n"), con=file_connection, eos=NULL)
      } else{
        writeChar(paste0("\t<",var,">"), con=file_connection, eos=NULL)
        writeChar( x, con=file_connection,   eos=NULL)
        writeChar(paste0("</",var,">\n"), con=file_connection, eos=NULL)
      }
    }
    writeChar(paste0("</",data_name,">"), con=file_connection, eos=NULL)
  }
  
}




eudract_input <- function(x, file){
  GROUP <- x$GROUP
  NON_SERIOUS <- x$NON_SERIOUS
  SERIOUS <- x$SERIOUS
  file_connection <- file(file, open="w")
  writeChar('<?xml version="1.0" encoding="UTF-8"?>',con=file_connection, eos=NULL)
  writeChar('\n<TABLE>',con=file_connection, eos=NULL)
  append_xml(GROUP, file_connection)
  append_xml(NON_SERIOUS, file_connection)
  append_xml(SERIOUS, file_connection)
  writeChar('\n</TABLE>',con=file_connection, eos=NULL)
  close(file_connection)
}


eudract_input(group, non_serious, serious, "R/table.xml")

data <- read_xml("R/table.xml")
xml_find_all(data,"/TABLE/SERIOUS/deaths")
