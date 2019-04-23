* Written by R;
*  write.foreign(safety_statistics$SERIOUS, datafile = "seriousdata.sas7bdat",  ;

DATA  serious ;
LENGTH
 groupTitle $ 12
 subjectsAffected $ 1
 occurrences $ 1
 term $ 35
 eutctId $ 12
 occurrencesCausallyRelatdTTrtmnt $ 1
 deaths $ 1
 deathsCausallyRelatedToTreatment $ 1
;

INFILE  "&PATH/seriousdata.sas7bdat" 
     DSD 
     LRECL= 91 ;
INPUT
 groupTitle
 subjectsAffected
 occurrences
 term
 eutctId
 occurrencesCausallyRelatdTTrtmnt
 deaths
 deathsCausallyRelatedToTreatment $ 
;
LABEL  occurrencesCausallyRelatdTTrtmnt = "occurrencesCausallyRelatedToTreatment" ;
RUN;
