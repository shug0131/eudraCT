ae <- read.csv(file="../../xslt material/raw_safety.csv")

safety_summary(ae, exposed=c(40,40))
length(unique( subset(ae, serious==1 & group=="Experimental")$subjid))
length(unique( subset(ae, serious==1 & group=="Control")$subjid))

library(tidyr)
library(magrittr)
library(dplyr)

ae %<>% within( subjid %<>% as.character %>% trimws)

test <- safety_summary(ae, exposed=c(40,40))

ae3 <- ae %>% filter( group=="Experimental") %>%
  group_by(subjid) %>%
  summarise(ser=any(serious==1))

table(ae3$ser)


subset(ae, subjid=="US3-002")

library(xml2)
simple <- read_xml("simple.xml")
simple <- read_xml("simpl2.xml")
schema <- read_xml("simple.xsd")
xml_validate(simple, schema)

ship <- read_xml("R/shiporder.xml")
shipschema <- read_xml("R/shipschema.xsd")
xml_validate(ship, shipschema)
