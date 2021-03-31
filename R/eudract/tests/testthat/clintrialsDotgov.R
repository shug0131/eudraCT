path <- "tests/testthat"
events <- read.csv(file=file.path(path, "data","events.csv"))
n_exposed <- c(20,22,18)
result <- safety_summary(events, n_exposed, soc_index="soc_term")
simple_safety_xml(result, file=file.path(path, "simple.xml"))

clintrials_gov_convert(file.path(path, "simple.xml"),
                       file.path(path, "ct.xml"))



if( FALSE){
# This was the code used to create the soc.xml file
library(xml2)
soc_xml <- xml_new_root("soc_table")
for( i in 1:nrow(soc_code)){
  xml_add_child(soc_xml,"soc", .where=i-1)
  my_node <- xml_child(soc_xml,search=i)
  xml_add_child(my_node,"soc_term")
  xml_set_text(xml_find_first(my_node,"soc_term"), soc_code[i,"soc_term"])
  xml_add_child(my_node,"eutctId")
  xml_set_text(xml_find_first(my_node,"eutctId"), as.character(soc_code[i,"eutctId"]))
  xml_add_child(my_node,"meddra")
  xml_set_text(xml_find_first(my_node,"meddra"), as.character(soc_code[i,"meddra"]))
}
write_xml(soc_xml, file=file.path(path, "soc.xml"))
}




