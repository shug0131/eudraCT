Stata can save a rectangular file into xml format using a command like

import delimited "$directory\xslt material\group.csv", clear
save "group.dta", replace
xmlsave "$directory\Stata\group", legible replace

The starting point is to create 3 such files corresponding to: group, serious, non_serious.
See in the example sub-folder for a more detailed working.

If the file names for these are: group.xml, serious.xml, non_serious.xml then
proceed. Otherwise you will need to edit the short stata_statsfiles.xml to provide the
corrected file names.

Apply the command in stata to convert the three xml files into one simple.xml file

! msxsl.exe stata_statsfiles.xml stata_combine.xslt -o simple.xml

Then convert to eudraCT format

! msxsl.exe simple.xml simpleToEudraCT.xslt -o table_eudract.xml

the final output is the file "table_eudract.xml" which can be uploaded into eudraCT

msxsl.exe is the Microsoft xslt processor downloaded from
https://www.microsoft.com/en-us/download/details.aspx?id=21714
