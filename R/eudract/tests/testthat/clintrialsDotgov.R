path <- "tests/testthat"
if(!exists("events")){
  events <- read.csv(file=file.path(path, "data","events.csv"))
  n_exposed <- c(20,22,18)
}

library(eudract)
result <- safety_summary(events, n_exposed, soc_index="soc_term")
simple_safety_xml(result, file=file.path(path, "simple2.xml"))
eudract_convert(input=file.path(path, "simple2.xml"),
                output=file.path(path, "eudractt2.xml"))

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

<xsl:key name="soc_key" match="document('soc.xml')/soc_table/soc" use="eutctId" />


setwd(path)
eudract_convert(input="simple2.xml",
                output="eudractt2.xml",
                xslt = "simpleToCtGov.xslt")

