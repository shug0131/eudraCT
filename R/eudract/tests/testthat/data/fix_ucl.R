setwd("tests/testthat/data/")
eudract_convert("simple_from_ucl.xml","output_from_ucl.xml")
#produces error code
# Error in eudract_convert("simple_from_ucl.xml", "output_from_ucl.xml") :
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This element is not expected. Expected is ( eutctId ).
# Element 'soc_code': This ele

# SO lets use the xml2 library and delete those nodes.
library(xml2)
simple <- read_xml("simple_from_ucl.xml")
soc <- xml_find_all(simple, "//soc_code")
xml_remove(soc)
write_xml(simple,file="socless.xml")
eudract_convert("socless.xml","output_from_ucl.xml")
