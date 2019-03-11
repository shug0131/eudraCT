** EUDRACT TOOL FOR STATA

global directory "V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\"
cd "$directory\xslt material\"

import delimited "$directory\xslt material\group.csv", clear
save "group.dta", replace
xmlsave "$directory\Stata\group", legible replace

import delimited "$directory\xslt material\non_serious.csv", clear
save "non_serious.dta", replace
xmlsave "$directory\Stata\non_serious", legible replace

import delimited "$directory\xslt material\serious.csv", clear
save "serious.dta", replace
xmlsave "$directory\Stata\serious", legible replace

use "group.dta"
append using "non_serious.dta"
append using "serious.dta"

save "combined.dta", replace
xmlsave "$directory\Stata\combined", legible replace






