/* EDIT THESE LINES*/
/* Path to the folder you want to use */
%let PATH=V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\SAS;
/*name of the SAS data set used as input, which needs to comply with the specification requirements.*/
%let ae_data=ae;
/* The count of numbers exposed by group, in the order resulting from PROC SORT applied to the group, i.e. alphabetical */
%let exposed=60 67;
/* Numbers of deaths not included in the data set, by group. Default is to leave blank if none */
%let excess_deaths= ;
/* A threshold on the % scale for a minimum rate to include non-serious AEs in the output */
%let freq_threshold=0;
/* which variable in the soc_code data is used to link to the SOC code. value must either be: meddra  soc_term . */
%let soc_index=meddra;


proc datasets library=WORK kill; run; quit;

/* import or identify a dataset called ae with the variables:
term soc subjid fatal related group serious.  group must have values at least 4 characters long */
proc import file="&PATH\raw_safety.csv" out=&ae_data dbms=csv replace; 
run;
/* EDIT completed. No further changes needed below this line. */


libname saswork "&PATH";

data soc_code; set saswork.soc_code;
soc= &soc_index;
run;
proc sort data=soc_code;
by soc;
run;


proc sort data=&ae_data out=ae;
by group subjid;
run;


data ae_by_patient; set ae;
by group subjid;
retain 	serious_any non_serious_any fatal_any;
if first.subjid then do;
	serious_any=0;
	non_serious_any=0;
	fatal_any=0;
end;
if serious=1 then serious_any=1;
if serious=0 then non_serious_any=1;
if fatal=1 then fatal_any=1;
if last.subjid then output;
run;

proc tabulate data=ae_by_patient out=GROUP;
class group;
var serious_any non_serious_any fatal_any;
table group, (serious_any non_serious_any fatal_any)*sum *f=10.0;
run;


data GROUP; set GROUP;
label 
	group=title
	serious_any_Sum=subjectsAffectedBySeriousAdverseEvents
	non_serious_any_Sum=subjectsAffectedByNonSeriousAdverseEvents
	fatal_any_Sum=deathsResultingFromAdverseEvents
	exposed=subjectsExposed
	deathsAllCauses=deathsAllCauses;
exposed=scan("&exposed", _N_)+0;
excess_deaths=scan("&excess_deaths", _N_)+0;
if( excess_deaths=.) then excess_deaths=0;
deathsAllCauses=fatal_any_sum+excess_deaths;
drop _TYPE_ _PAGE_ _TABLE_ excess_deaths;
run;


/* Non serious */
%macro non_serious;
proc sort data=ae(where=(serious=0)) out=non_serious;
by soc term group subjid;
run;

data non_serious_occ non_serious_subj; set non_serious;
by soc term group subjid;
if first.subjid then output non_serious_subj;
output non_serious_occ;
run;

proc tabulate data=non_serious out=allcombs;
class soc term group;
table soc*term, all;
run;
/*needed in case one group has no AEs for example*/
proc sql;
create table allcombs as 
select soc, term, group from allcombs, group;
quit;

proc sort data=allcombs; by soc term group; run;

title "Occurences";

proc tabulate data=non_serious_occ out=occ  missing;
class soc term group;
table soc*term, group/  printmiss;
run;

data occ; merge allcombs(in=_a keep=soc term group) occ;
by soc term group;
if N=. then N=0;
if _a then output;
drop _TYPE_ _PAGE_ _TABLE_;
run;

title "Patient count";
proc tabulate data=non_serious_subj out=subj;
class soc term group;
table soc*term, group/ printmiss;
run;
data subj; merge allcombs(in=_a keep=soc term group) subj;
by soc term group;
if N=. then N=0;
if _a then output;
drop _TYPE_ _PAGE_ _TABLE_;
run;

/* merge together occurrrences and subject counts */
data non_serious; merge occ(rename=(N=occurrences)) subj(rename=(N=subjectsAffected));
by soc term;
run;


data non_serious; merge non_serious(in=_a_) soc_code; *saswork.soc_code(rename=(&soc_index=soc));
by soc;
if _a_ then output;
run;

/* Filtering by rate */
proc sort data=non_serious out=filter;
by group;
run;

data filter;  merge filter group;
by group;
rate=subjectsAffected/exposed*100;
run;
proc tabulate data=filter out=filter;
class soc term;
var rate;
table soc*term,rate*max;
run;

data non_serious; merge  non_serious filter;
by soc term;
if  &freq_threshold <= rate_max then output;
drop _TYPE_ _PAGE_ _TABLE_ soc soc_term meddra rate_max;
rename group=groupTitle;
run;
%mend;

/* Serious */
%macro serious;
proc sort data=ae(where=(serious=1)) out=serious;
by soc term group subjid;
run;

data serious_occ serious_subj; set serious;
by soc term group subjid;
if first.subjid then output serious_subj;
output serious_occ;
run;

proc tabulate data=serious_occ out=allcombs;
class soc term group;
table soc*term, all;
run;

/*needed in case one group has no SAEs for example*/
proc sql;
create table allcombs as 
select soc, term, group from allcombs, group;
quit;

proc sort data=allcombs; by soc term group; run;


data serious_occ; set serious_occ;
deaths_related=related*fatal;
run;


proc tabulate data=serious_occ out=ser_occ  missing;
class soc term group;
var related fatal deaths_related;
table soc*term*group, All related fatal deaths_related/  printmiss;
run;

data ser_occ; merge allcombs(in=_a keep=soc term group) ser_occ;
by soc term group;
if N=. then do;
	N=0;
	related_sum=0;
	fatal_sum=0;
	deaths_related_sum=0;
end;
if _a then output;
drop _TYPE_ _PAGE_ _TABLE_;
run;
proc tabulate data=serious_subj out=ser_subj;
class soc term group;
table soc*term, group/ printmiss;
run;
data ser_subj; merge allcombs(in=_a keep=soc term group) ser_subj;
by soc term group;
if N=. then N=0;
if _a then output;
drop _TYPE_ _PAGE_ _TABLE_;
run;



/* merge together occurrrences and subject counts */
data serious; merge ser_occ(rename=(N=occurrences)) ser_subj(rename=(N=subjectsAffected));
by soc term;
rename group=groupTitle;
run;


data serious; merge serious(in=_a_) soc_code; *saswork.soc_code(rename=(&soc_index=soc));
label 
	related_Sum=occurrencesCausallyRelatedToTreatment
	fatal_Sum=deaths
	deaths_related_Sum=deathsCausallyRelatedToTreatment;
by soc;
if _a_ then output;
drop soc soc_term meddra;
run;
%mend;

/* Conditional Logic to deal with cases where there are no SAEs or no AEs */
/* create blank data sets first */

data non_serious; set saswork.non_serious_blank;
run;
data serious; set saswork.serious_blank;
run;


data NULL; set group end=eof;
retain any_serious any_non_serious 0;
any_serious = max( any_serious, serious_any_sum);
any_non_serious = max( any_non_serious, non_serious_any_sum);
if eof then do;
	if any_serious >0 	  then call execute('%serious');
	if any_non_serious >0 then call execute('%non_serious');
end;
run;




/* Provide a document to check by eye.*/
ods pdf file="&PATH/Safety Data.pdf";
title "Group level data";
proc print data=group label ;
run;
title "Serious group-term level data";
proc print data=serious label ;
run;
title "Non-serious group-term level data";
proc print data=non_serious label ;
run;
ods pdf close;

/* All three data sets produced. Now convert to XML */

proc contents data=group noprint out=groupvars; run;
proc contents data=serious noprint out=seriousvars; run;
proc contents data=non_serious noprint out=non_seriousvars; run;

data rename; set groupvars seriousvars non_seriousvars;
if label^="" then output;
keep name label;
rename name=old label=new;
run;
/* save pre-version of the simple xml */
libname simple0 xml "&PATH\simple0.xml" ;
proc datasets nolist;
  copy in=work out=simple0;
    select group serious non_serious rename ;
  run;
quit;
/*use xslt to rename within simple xml to get the correct tag or variable names*/
proc xsl in="&PATH\simple0.xml" out="&PATH\simple.xml" xsl="&PATH\sas_xml_renaming.xslt";run;

/*use xslt to transform into the format needed by EudraCT */
proc xsl in="&PATH\simple.xml" out="&PATH\table_eudract.xml" xsl="&PATH\simpleToEudraCT.xslt";run;

%put Please email cctu@addenbrookes.nhs.uk to tell us if you have successfully uploaded a study to EudraCT. This is to allow us to measure the impact of this tool.;
