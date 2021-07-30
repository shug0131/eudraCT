path <- "tests/testthat"
events <- read.csv(file=file.path(path, "data","events.csv"))
n_exposed <- c(20,22,18)
result <- safety_summary(events, n_exposed, soc_index="soc_term")
simple_safety_xml(result, file=file.path(path, "simple.xml"))

clintrials_gov_convert(input=file.path(path, "simple.xml"),
                       original=file.path(path, "1234.xml"),
                       output=file.path(path, "ct.xml")
                       
)



output <- clintrials_gov_upload(
  input=file.path(path, "simple.xml"),
  orgname="AddenbrookesH",
  username="SBond",
  password="Baginton1",
  studyid="1234",
  url="https://prstest.clinicaltrials.gov/"

)


?readline


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



original <- read_xml("tests/testthat/1234.xml")
safety <- read_xml("tests/testthat/ct.xml")
xml_replace(
  xml_find_first(original, "//reportedEvents"),
  xml_find_first(safety, "//reportedEvents"),
  .copy=TRUE
)
write_xml(original, file=file.path(path, "trial.xml"))

library(httr)

tmp <-  POST(url="https://prstest.clinicaltrials.gov/prs/app/action/ExternalDownload/",
     body=list(
       orgName="AddenbrookesH",
       userName="SBond",
       passWord="Baginton1",
       orgStudyId="1234"
     ),
     encode="form"
)
#https://prstest.clinicaltrials.gov/prs/app/action/SaveCopy/protocol_record.xml?uid=U00032SX&ts=7&sid=S0006HWA&cx=20xqns

write_xml(content(tmp), file=file.path(path, "download.xml"))

myfile <- readLines(con=file.path(path, "trial.xml"))
myfile <- paste(myfile, collapse="\n")

tmp2 <-  POST(url="https://prstest.clinicaltrials.gov/prs/app/action/ExternalUpload",
             body=list(
               orgName="AddenbrookesH",
               userName="SBond",
               passWord="Baginton1",
               uploadXML=myfile,
               autoRelease="false"
             ),
             encode="form"
)
content(tmp2)

POST(url="https://prstest.clinicaltrials.gov/prs/app/action/RecordInfoDownload",
     body=list(
       orgName="AddenbrookesH",
       userName="SBond",
       passWord="Baginton1"
            ),
     encode="form"
     )

library(xml2)
protocol_schema <- read_xml("inst/extdata/ProtocolRecordSchema.xsd")
results_schema <- read_xml("inst/extdata/RRSUploadSchema.xsd")
original <- read_xml("tests/testthat/1234.xml")
output <- read_xml("tests/testthat/download.xml")
xml_validate(original, protocol_schema)
xml_validate(output, results_schema)
