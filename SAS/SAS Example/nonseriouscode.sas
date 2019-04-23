* Written by R;
*  write.foreign(safety_statistics$NON_SERIOUS, datafile = "nonseriousdata.sas7bdat",  ;

DATA  non_serious ;
LENGTH
 groupTitle $ 12
 subjectsAffected $ 1
 occurrences $ 1
 term $ 35
 eutctId $ 12
;

INFILE  "&PATH/nonseriousdata.sas7bdat" 
     DSD 
     LRECL= 79 ;
INPUT
 groupTitle
 subjectsAffected
 occurrences
 term
 eutctId $ 
;
RUN;
