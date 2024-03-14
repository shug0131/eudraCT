install.packages("eudract")
rm(list=ls())
# Forcing it to use a mapped drive on Windows
.libPaths("U:/My Documents/R/win-library/4.1")
original <- system.file("extdata", "1234.xml", package = "eudract")
original <- xml2::read_xml(original)
schema_output <-  system.file("extdata", "ProtocolRecordSchema.xsd",package = "eudract")
schema_output <- xml2::read_xml(schema_output)
xml2::xml_validate(original, schema_output)
# Works fine
.libPaths("\\\\me-filer1/home$/sjb277/My Documents/R/win-library/4.1")
# This is in fact the same directory as previously set but using non-mapped network drive paths
xml2::xml_validate(original, schema_output)
# Still works
# Read in the schema afresh
schema_output <-  system.file("extdata", "ProtocolRecordSchema.xsd",package = "eudract")
schema_output <- xml2::read_xml(schema_output)
xml2::xml_validate(original, schema_output)
# now it fails.


