* Written by R;
*  write.foreign(safety_statistics$GROUP, datafile = "groupdata.sas7bdat",  ;

DATA  group ;
LENGTH
 title $ 12
 subjectsAffectedBySersAdvrsEvnts $ 2
 subjectsAffectdByNnSrsAdvrsEvnts $ 2
 deathsResultingFromAdverseEvents $ 2
 subjectsExposed $ 2
 deathsAllCauses $ 2
;

INFILE  "&PATH/groupdata.sas7bdat" 
     DSD 
     LRECL= 43 ;
INPUT
 title
 subjectsAffectedBySersAdvrsEvnts
 subjectsAffectdByNnSrsAdvrsEvnts
 deathsResultingFromAdverseEvents
 subjectsExposed
 deathsAllCauses $ 
;
LABEL  subjectsAffectedBySersAdvrsEvnts = "subjectsAffectedBySeriousAdverseEvents" ;
LABEL  subjectsAffectdByNnSrsAdvrsEvnts = "subjectsAffectedByNonSeriousAdverseEvents" ;
RUN;
