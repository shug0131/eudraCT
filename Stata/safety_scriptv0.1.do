* check if the termsoc definition works with soc_term as character
*http://wlm.userweb.mwn.de/Stata/wstataddm.htm
clear
global freq_threshold 0
cd  "V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\Stata"
global datafile "raw_safety.csv"
global soc_index meddra
input exposed excessdeaths
60 0
67 0
end
save EXPOSED, replace

import delimited using "soc_code.csv", varnames(1) clear
rename ${soc_index} soc
gen eutctid2=string(eutctid,"%14.0g")
keep soc eutctid2
rename eutctid2 eutctid
save soc_code, replace

import delimited using ${datafile} , varnames(1) clear
save raw, replace





gen nonserious=1-serious
collapse (max) serious nonserious fatal, by(subjid group)
collapse (sum) serious nonserious fatal, by(group) 


sort group
merge 1:1 _n using EXPOSED, nogenerate
gen deathsAllCauses=fatal+excessdeaths
recast int serious nonserious fatal deathsAllCauses exposed
drop excessdeaths

la var group "title"
la var fatal "deathsResultingFromAdverseEvents"
la var serious "subjectsAffectedBySeriousAdverseEvents"
la var nonserious "subjectsAffectedByNonSeriousAdverseEvents"
la var exposed "subjectsExposed"
la var deathsAllCauses "deathsAllCauses"

save GROUPS, replace
xmlsave "group", legible replace


* non-serious


clear

use raw if serious==0
capture confirm numeric variable soc
if _rc==0 {
	gen termsoc = term + string(soc,"%12.0g")
} 
else {
	gen termsoc = term + soc
}
save nonserious, replace

*create all combinations of group and termsoc
sort term soc termsoc
duplicates drop term soc termsoc, force
keep term soc termsoc
cross using GROUPS
keep term soc termsoc group
save ALLCOMBS, replace

use nonserious
contract group termsoc, freq(occurrences)
save OCCURRENCES, replace

use nonserious
duplicates drop termsoc group subjid , force
contract group termsoc, freq(subjectsAffected)
save SUBJECTS, replace

merge 1:1  group termsoc using OCCURRENCES, nogenerate
save NONSERIOUS, replace
clear
use ALLCOMBS
merge 1:1 termsoc group using NONSERIOUS, keep(match master)
replace occurrences=0 if _merge==1
replace subjectsAffected=0 if _merge==1
drop _merge
save NONSERIOUS, replace

* FILTER by rate
merge m:1 group using GROUPS
gen rate=subjectsAffected/exposed *100
collapse (max) rate, by(termsoc)
drop if rate < $freq_threshold
keep termsoc
merge 1:m termsoc using NONSERIOUS, nogenerate keep(match master)
sort termsoc group
drop termsoc

la var group "groupTitle"
la var subjectsAffected "subjectsAffected"
la var occurrences "occurrences"
la var term "term"



save NONSERIOUS, replace

clear
use NONSERIOUS
merge m:1 soc using soc_code
drop if _merge==2
drop _merge soc
la var eutctid "eutctId"
save NONSERIOUS, replace


xmlsave "non_serious", legible replace

* serious
clear
use raw if serious==1
capture confirm numeric variable soc
if _rc==0 {
	gen termsoc = term + string(soc,"%12.0g")
} 
else {
	gen termsoc = term + soc
}
gen relatedDeath=fatal*related
save serious, replace

duplicates drop term soc termsoc, force
keep term soc termsoc
cross using GROUPS
keep term soc termsoc group
save ALLCOMBS, replace

use serious
contract group termsoc, freq(occurrences)
save OCCURRENCES, replace

use serious
duplicates drop termsoc group subjid, force
contract group termsoc, freq(subjectsAffected)
save SUBJECTS, replace

use serious
collapse(sum) related fatal relatedDeath, by(group termsoc)
recast int related fatal relatedDeath
save RELATEDFATAL, replace

use OCCURRENCES
merge 1:1 group termsoc using SUBJECTS, nogenerate
merge m:1 group termsoc using RELATEDFATAL, nogenerate keep(match master)
save SERIOUS, replace

clear
use ALLCOMBS
merge 1:1 termsoc group using SERIOUS, keep(match master)
replace occurrences=0 if _merge==1
replace subjectsAffected=0 if _merge==1
replace related=0 if _merge==1
replace fatal=0 if _merge==1
replace relatedDeath=0 if _merge==1
drop _merge termsoc

la var group "groupTitle"
la var subjectsAffected "subjectsAffected"
la var occurrences "occurrences"
la var term "term"
la var related "occurrencesCausallyRelatedToTreatment"
la var fatal "deaths"
la var relatedDeath	"deathsCausallyRelatedToTreatment"


save SERIOUS, replace

clear
use SERIOUS
merge m:1 soc using soc_code
drop if _merge==2
drop _merge soc
la var eutctid "eutctId"
save SERIOUS, replace


xmlsave "serious", legible replace

rm ALLCOMBS.dta 
rm OCCURRENCES.dta
rm SUBJECTS.dta 
rm RELATEDFATAL.dta
rm EXPOSED.dta


! msxsl.exe stata_statsfiles.xml stata_combine.xslt -o simple.xml

! msxsl.exe simple.xml simpleToEudraCT.xslt -o table_eudract.xml
