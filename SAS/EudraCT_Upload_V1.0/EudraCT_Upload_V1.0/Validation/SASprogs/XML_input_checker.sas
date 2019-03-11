dm 'log; clear; output; clear;'; /* clear log and output */
/*Update to Study Directory*/

%let dir=P:\CTRU\Stats\Programming\SAS\Eudract\;

**--------------------------------------------------------------------------------;
**||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
**--------------------------------------------------------------------------------;
**                                                                                ;
**Filename..........XML_input_checker                                             ;
**                                                                                ;
**Date created......09/02/2017                                                    ;
**                                                                                ;
**Last amended......                                                              ;
**                                                                                ;
**Trial.............NA                                                            ;
**                                                                                ;
**Analysis..........NA                					                          ;
**                                                                                ;
**Program purpose...Check input datasets are in the correct format                ;
**																				  ;
**Directory.........P:\CTRU\Stats\Programming\SAS\Eudract       				  ;
**                                                                                ;
**Statistician......Andrew Hall	                                                  ;
**                                                                                ;
**SAS version.......9.4                                                           ;
**                                                                                ;
**Datasets created..None                                                          ;
**                                                                                ;
**Output files......None                                                          ;
**                                                                                ;
**Reviewed by.......                                                              ;
**                                                                                ;
**Date reviewed.....                                                              ;
**                                                                                ;
**--------------------------------------------------------------------------------;
**||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
**--------------------------------------------------------------------------------;

**********;
*Data steps;
**********;
title "XML_input_checker";
footnote;

/*Define library required to recode SOC*/
libname library "P:\CTRU\Stats\Programming\SAS\Eudract";
*enter the folder name where study-specific managed data are stored ;
libname m "&dir.";

%macro open1(dataset);
 data &dataset;
  set m.&dataset;
run;
%mend open1;

%open1(EudractGrps);
%open1(EudractAE);
%open1(EudractSAE);


data EudractAE;
length soc $100 term $100 desc $250;
call missing(idn,soc,term,desc,Asstype,patsn,occur);
if _N_ = 0 then output;
stop;
run;



/*check the Sytem organ class terms and Version number are correct*/
proc format library=library cntlout=formatsout; 
run;

/*print out the formats to check they have loaded correctly*/
proc sql;
	select distinct fmtname, start, label
    from formatsout
    order by fmtname, start;
quit; 


/****************************************************/
/*Check to see if Eudractgrps has the correct dataset structure*/
/****************************************************/
/*this is the correct structure*/
data EudractGrpsformat;
length id $62 desc $999;
call missing(idn,id,desc,patn,patae,patsae,death,deathae);
if _N_ = 0 then output;
stop;
run;

/*create datasets of varaible names variable types, length and format*/
proc contents data=EudractGrpsformat out=cont1(keep = name type length format) noprint;
run;

proc contents data=EudractGrps out=cont2(keep = name type length format) noprint;
run;

/*Variables can be defined in upper and lower case this shouldn't be a warning*/
data cont1; 
set cont1; 
name=upcase(name); 
run;
data cont2; 
set cont2; 
name=upcase(name); 
run;

proc sort data=cont1; 
   by name;
run;

proc sort data=cont2;
	by name;
run;
 
proc compare listvar
  base=cont1
  compare=cont2 error;
run;
/*if errors exist look at the report to see why or open up the two datasets cont1 and cont2 to compare - cont 1 is the correct format*/


/****************************************************/
/*Check to see if EudractSAE has the correct structure*/
/****************************************************/

data EudractSAEformat;
length soc $100 term $100 desc $250;
call missing(idn,soc,term,desc,Asstype,patsn,occur,Occurtrt,death,deathtrt);
if _N_ = 0 then output;
stop;
run;

proc contents data=EudractSAEformat out=cont3(keep = name type length format label) noprint;
run;

proc contents data=EudractSAE out=cont4(keep = name type length format label) noprint;
run;

/*Variables can be defined in upper and lower case this shouldn't be an error*/
data cont3; 
set cont3; 
name=upcase(name); 
run;
data cont4; 
set cont4; 
name=upcase(name); 
run;

proc sort data=cont3; 
   by name;
run;

proc sort data=cont4;
	by name;
run;
 
proc compare listvar
  base=cont3
  compare=cont4 error;
run;

/*if errors exist look at the report to see why or open up the two datasets cont5 and cont6 to compare where structures are differnt cont 3 is the correct format*/

/****************************************************/
/*Check to see if EudractAE has the correct structure*/
/****************************************************/

data EudractAEformat;
length soc $100 term $100 desc $250;
call missing(idn,soc,term,desc,Asstype,patsn,occur);
if _N_ = 0 then output;
stop;
run;

proc contents data=EudractAEformat out=cont5(keep = name type length format) noprint;
run;

proc contents data=EudractAE out=cont6(keep = name type length format) noprint;
run;

/*Variables can be defined in upper and lower case this shouldn't be an error*/
data cont5; 
set cont5; 
name=upcase(name); 
run;
data cont6; 
set cont6; 
name=upcase(name); 
run;

proc sort data=cont5; 
   by name;
run;

proc sort data=cont6;
	by name;
run;
 
proc compare listvar
  base=cont5
  compare=cont6 error ;
run;
/*if errors exist look at the report to see why or open up the two datasets cont5 and cont6 to compare where structures are differnt cont5 is the correct format*/


/*checks to see there are no missing values*/
data _null_;
   set EudractGrps;
   if missing(idn) then put "ERR" "OR: variable IDN has missing values in the EudractGrps dataset";
   if missing(id) then put "ERR" "OR: variable ID has missing values in the EudractGrps dataset";
   if missing(patn) then put "ERR" "OR: variable PATN has missing values in the EudractGrps dataset";
   if missing(patae) then put "ERR" "OR: variable PATAE has missing values in the EudractGrps dataset";
   if missing(patsae) then put "ERR" "OR: variable PATSAE has missing values in the EudractGrps dataset";
   if missing(death) then put "ERR" "OR: variable DEATH has missing values in the EudractGrps dataset";
run; 

data _null_;
   set EudractSAE;
   if missing(idn) then put "ERR" "OR: variable IDN has missing values in the EudractAE dataset";
   if missing(input(soc,soc.)) then put "ERR" "OR:" SOC +(-1)" hasn't matched, check the format or input dataset";
   if missing(Asstype) then put "ERR" "OR: variable TERM has missing values in the EudractAE dataset";
   if missing(patsn) then put "ERR" "OR: variable PATN has missing values in the EudractAE dataset";
   if missing(occur) then put "ERR" "OR: variable PATAE has missing values in the EudractAE dataset";
   if missing(occurtrt) then put "ERR" "OR: variable PATSAE has missing values in the EudractAE dataset";
   if missing(death) then put "ERR" "OR: variable DEATH has missing values in the EudractAE dataset";
   if missing(deathtrt) then put "ERR" "OR: variable DEATHAE has missing values in the EudractAE dataset";
run; 

data _null_;
   set EudractAE;
   if missing(idn) then put "ERR" "OR: variable IDN has missing values in the EudractAE dataset";
   if missing(input(soc,soc.)) then put "ERR" "OR:" SOC +(-1)" hasn't matched, check the format or input dataset";
   if missing(Asstype) then put "ERR" "OR: variable TERM has missing values in the EudractAE dataset";
   if missing(patsn) then put "ERR" "OR: variable PATN has missing values in the EudractAE dataset";
   if missing(occur) then put "ERR" "OR: variable PATAE has missing values in the EudractAE dataset";
run; 

/*check to see Idn is unique in EudractGrps*/
proc sql;
	create table check1 as
	select distinct idn, count(*) as total, count(distinct idn) as totalidn
	from EudractGrps
    order by idn;    
quit;

data _null_;
	set check1 end=a;
	if total ne totalidn then put "ERR" "OR: variable IDN in the EudractGrps dataset isn't unique";   
run;

/*check to see all entries of IDN in AEs and SAEs match to those in the reporting group*/
proc sort data=EudractSAE out=check2(keep= idn) nodupkey; by idn; run;
proc sort data=EudractAE out=check3(keep= idn) nodupkey; by idn; run;

data _null_;
	merge check1(in=a) check2(in=b) ;
	by idn;
	if a and not b then put "ERR" "OR: variable with IDN=" idn +(-1)" is in the EudractGrps dataset but not in the EudractSAE dataset";  
	if b and not a then put "ERR" "OR: variable with IDN=" idn +(-1)" is in the EudractSAE dataset but not defined in the EudractGrps dataset";
run;

/*code to count number of observations in AEs dataset to make sure er rors don't fire if AEs dataset is empty*/ 
proc sql noprint;
 select count(*) into :nobs from check3;
quit;

data _null_;
	merge check1(in=a) check3(in=b);
	by idn;
	nobs=compress("&nobs.");
	if nobs ne "0" and a and not b then put "ERR" "OR: variable with IDN=" idn +(-1)" is in the EudractGrps dataset but not in the EudractAE dataset";  
	if b and not a then put "ERR" "OR: variable with IDN=" idn +(-1)" is in the EudractAE dataset but not defined in the EudractGrps dataset";
run;


/*check to see that there are the correct number of entries for each term*/
data SAE_AE;
	set EudractSAE(in=a) EudractAE;
    if a then dset='EudractSAE';

	/*add a check for assessment type as it needs to be 1 or 2*/
	if asstype not in (1,2) then put "Asstype in dataset=" dset +(-1)" has entries that are not 1 or 2"; 
run;

proc sql;
/*Count number of groups and merge back to all entries*/
	create table check4 as
	select *, count(distinct idn) as ngroups
	from sae_AE;
/*count number of entries for each term*/
    create table check5 as
	select distinct dset, term, ngroups, count(distinct idn) as numidn, count(*) as nentries
	from check4
    group by dset, term;
quit;

data _null_;
	merge check5;
	if ngroups<numidn then put "ERR" "OR: term=" term +(-1) "in dataset=" dset +(-1)" has missing groups";
	if nentries>numidn then put "ERR" "OR: term=" term +(-1) "in dataset=" dset +(-1)" has duplicate entries";
run;

**================================================================================;
**									END OF PROGRAM								  ;
**================================================================================;
