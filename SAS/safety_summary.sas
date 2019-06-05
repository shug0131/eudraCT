%let PATH=V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\xslt material ;
proc datasets library=WORK kill; run; quit;

proc import file="&PATH\raw_safety.csv" out=ae dbms=csv replace; 
run;

proc sort data=ae;
by group subjid;
run;

data ae2; set ae;
by group subjid;
retain 	serious_any nonserious_any fatal_any;
if first.subjid then do;
	serious_any=0;
	nonserious_any=0;
	fatal_any=0;
end;
if serious=1 then serious_any=1;
if serious=0 then nonserious_any=1;
if fatal=1 then fatal_any=1;
if last.subjid then output;
run;

proc tabulate data=ae2 out=GROUP;
class group;
var serious_any nonserious_any fatal_any;
table group, (serious_any nonserious_any fatal_any)*sum *f=10.0;
run;

/* Non serious */

proc sort data=ae(where=(serious=0)) out=nonserious;
by soc_term term group subjid;
run;

data nonserious_occ nonserious_subj; set nonserious;
by soc_term term group subjid;
if first.subjid then output nonserious_subj;
output nonserious_occ;
run;

proc tabulate data=nonserious out=allcombs;
class soc_term term group;
table soc_term*term, all;
run;


title "Occurences";

proc tabulate data=nonserious_occ out=occ  missing;
class soc_term term group;
table soc_term*term, group/  printmiss;
run;

data occ; merge allcombs(in=_a keep=soc_term term) occ;
by soc_term term;
if N=. then N=0;
if _a then output;
drop _TYPE_ _PAGE_ _TABLE_;
run;

title "Patient count";
proc tabulate data=nonserious_subj out=subj;
class soc_term term group;
table soc_term*term, group/ printmiss;
run;
data subj; merge allcombs(in=_a keep=soc_term term) subj;
by soc_term term;
if N=. then N=0;
if _a then output;
drop _TYPE_ _PAGE_ _TABLE_;
run;

/* Serious */

proc sort data=ae(where=(serious=1)) out=serious;
by soc_term term group subjid;
run;


proc tabulate data=serious out=allcombs;
class soc_term term group;
table soc_term*term, all;
run;

data serious; set serious(rename=(related=related_char));
if related_char="TRUE" then  
		related=0;
else 	related=1;
death_related=related*fatal;
run;


proc tabulate data=serious out=ser_occ  missing;
class soc_term term group;
var related fatal death_related;
table soc_term*term*group, all related fatal death_related/  printmiss;
run;

data ser_occ; merge allcombs(in=_a keep=soc_term term) ser_occ;
by soc_term term;
if N=. then do;
	N=0;
	related_sum=0;
	fatal_sum=0;
	death_related_sum=0;
end;
if _a then output;
drop _TYPE_ _PAGE_ _TABLE_;
run;

/*
TODO list  
merge the data sets
include EutctID coding for SOC
give EudraCT var labels
add in extra data (exposed, extra deaths)
do filtering by AE rate
apply previous work to export to XML,
maybe turn into macro
add in comments
*/