%let PATH=V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool;



proc import datafile="&path.\xslt material\group.csv"
        out=group
        dbms=csv
        replace;
guessingrows=10000;
run;
proc import datafile="&path.\xslt material\non_serious.csv"
        out=non_serious
        dbms=csv
        replace;
guessingrows=10000;
run;
proc import datafile="&path.\xslt material\serious.csv"
        out=serious
        dbms=csv
        replace;
guessingrows=10000;
run;
/*
data non_serious; set non_serious;
keep group subjectsAffected occurrences term eutctId;
rename group= groupTitle;
run;

/ * SAS doesn't do variable names longer than 32 chars. D'oh * /

data serious; set serious;
keep group subjectsAffected occurrences term eutctId occurrencesCausallyRelatedToTre deaths deathsCausallyRelatedToTreatmen;
rename group= groupTitle;
run;

/*Write the data * /

libname test xml "&PATH\SAS\test2.xml" ;

proc datasets nolist;
  copy in=work out=test;
    select group serious non_serious ;
  run;
quit;
*/

*libname test;

filename SGFXML "&PATH\SAS\example7.xml";
filename map "&PATH\SAS\autogenexport.map";
libname SGFXML xmlv2 xmltype=xmlmap xmlmap=map;

data sgfxml.SERIOUS;
 set work.SERIOUS work.GROUP;
run;
