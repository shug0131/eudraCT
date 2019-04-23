%let PATH=V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\SAS\SAS Example;
/*CODE to create summary statistics in 3 data sets */
%inc "&PATH\groupcode.SAS";
%inc "&PATH\seriouscode.SAS";
%inc "&PATH\nonseriouscode.SAS";
/*Dealing with short variable names but correct labels */
proc contents data=group noprint out=groupvars; run;
proc contents data=serious noprint out=seriousvars; run;
data rename; set groupvars seriousvars;
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
proc xsl in="&PATH\simple0.xml" out="&PATH\simple.xml" xsl="&PATH\renaming.xslt";run;
/*apply the main transformation to get the eudract xml */
proc xsl in="&PATH\simple.xml" out="&PATH\table_eudract.xml" xsl="&PATH\simpleToEudraCT.xslt";run;
