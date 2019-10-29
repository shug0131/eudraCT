safety_statistics <- safety_summary(safety,
                                    exposed=c("Experimental"=60,"Control"=67))
simple_safety_xml(safety_statistics,
                  file.path(tempdir(), "simple.xml"))
eudract_convert(input=file.path(tempdir(), "simple.xml"),
                output=file.path(tempdir(), "table_eudract.xml"))
