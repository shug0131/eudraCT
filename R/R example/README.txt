Open talk_example.R and edit the first line to point to the containing directory. 

The eudract_tools.R file defines several useful functions. You made need to install some external packageds (tidyr, dplyr, xslt, and their dependencies)

The file safety.rda contains an example of raw data, to be replaced with your own data.

If run correctly then it will produce 2 new files within the same directory:  simple.xml table_eudract.xml. The final one being able to be uploaded into eudraCT. Compare to the files in the "reference output" directory, which is what your output should be. 

You will also have within your R environment a data frame soc_code with three columns giving a complete list of: SOC terms in English, the EudraCT coding values, the MedDRA coding values. This is to be used for linking as needed.