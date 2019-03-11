/* clear log and output */
dm 'log; clear; output; clear;'; 

/*UPDATE to Study Directory*/
%let dir=P:\CTRU\Stats\Programming\SAS\Eudract\EudraCT_FormatsValidation\KLR_CHECK;

/* Defining program name */
%let progname=XML_creator;

/*
_______________________________________________________________________________________________________________

	Filename				:  XML_creator_V1.0.sas

	Date created			:  25/01/2017

	Last amended       		:    

	Trial             		:   

	Analysis				:   
 
	Purpose Of Program 		:  To process a standard dataset to output to xml for upload to Eudract system 

	Directory	      		:  &dir directory above

	Statistician	   		:  Andrew Hall

	SAS version      		:  9.4

	Datasets created  		:   

	Output files			:  EudractUpload.xml

	Reviewed by				:  Kara-Louise Royle	

	Date reviewed			:  02/08/2017
    

	Amended by				:	
_______________________________________________________________________________________________________________

*/


/**************/
/* Data steps */
/**************/

title "Eudract XML creator";
footnote;

/* UPDATE the library to be where the SOC formats library is */
libname library "&dir.\SASformats";

/* UPDATE the folder name to be where study-specific managed data are stored */
libname m "&dir.\SASdata";

%macro open1(dataset);
 data &dataset;
  set m.&dataset;
run;
%mend open1;

%open1(EudractGrps);
%open1(EudractAE);
%open1(EudractSAE);


/***********************************************************************/
/* Merge numbers exposed from groups dataset and add SOC EUTCT numbers */
/***********************************************************************/

/*AEs*/
proc sql;
	create table AEs as
	select a.*, b.patn, input('VersionNumber',version.) as version, input(a.soc,soc.) as eutctId
	from EudractAE as a left join EudractGrps as b on a.idn=b.idn
    order by a.term, a.idn;
quit;

/*SAEs*/
proc sql;
	create table SAEs as
	select a.*, b.patn, input('VersionNumber',version.) as version, input(a.soc,soc.) as eutctId
	from EudractSAE as a left join EudractGrps as b on a.idn=b.idn
    order by a.term, a.idn;
quit;

/**********************/
/* Write the XML file */
/**********************/

/*UPDATE output file*/
%let file=&dir.\output\EudractUpload.xml;


/*opening tagset*/
data _null_;
	file "&file";

	/*note no 'MOD' in line above this will create a new file*/
	put '<aev:adverseEvents xmlns:aev="http://eudract.ema.europa.eu/schema/clinical_trial_result/adverse_events" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
run;

/*reporting groups output*/
data _null_;
	file "&file" mod;
	set EudractGrps end=eof;

	/*opening tagset*/
	if _n_=1 then
		put '          <reportingGroups>';

	/*tagset for each observation*/
	put '           <reportingGroup id="ReportingGroup-' idn +(-1)'">';
	put '             <title>' id  +(-1)'</title>';

	if not missing(desc) then
		put '             <description>' desc +(-1)'</description>';
	put '             <subjectsAffectedByNonSeriousAdverseEvents>' patae +(-1)'</subjectsAffectedByNonSeriousAdverseEvents>';
	put '             <subjectsAffectedBySeriousAdverseEvents>' patsae +(-1)'</subjectsAffectedBySeriousAdverseEvents>';
	put '             <subjectsExposed>' patn +(-1)'</subjectsExposed>';
	put '             <deathsAllCauses>' death +(-1)'</deathsAllCauses>';

	if not missing(deathae) then
		put '             <deathsResultingFromAdverseEvents>' deathae +(-1)'</deathsResultingFromAdverseEvents>';
	put '           </reportingGroup>';

	/*closing tagset*/
	if eof then
		put '          </reportingGroups>';
run;

/*non seriousadverse events or AEs output*/
data _null_;
	file "&file" mod;
	set AEs end=eof;
	by term;

	/*opening tagset for all AEs*/
	if _n_=1 then
		put '        <nonSeriousAdverseEvents>';

	/*opening tagset for each AE*/
	if first.term then
		do;
			put '            <nonSeriousAdverseEvent>';

			if not missing(desc) then
				put '                <description>' desc +(-1)'</description>';
			put '                <term>' term +(-1)'</term>';
			put '                <organSystem>';
			put '                    <eutctId>' eutctId +(-1)'</eutctId>';
			put '                    <version>' version +(-1)'</version>';
			put '                </organSystem>';
			put '                <assessmentMethod>';

			if asstype=1 then
				put '                    <value>ADV_EVT_ASSESS_TYPE.systematic</value>';
			else put '                    <value>ADV_EVT_ASSESS_TYPE.non_systematic</value>';
			put '                </assessmentMethod>';
			put '                <dictionaryOverridden>false</dictionaryOverridden>';
			put '                <values>';
		end;

	/*tagsets for each arm*/
	put '                    <value reportingGroupId="ReportingGroup-' idn +(-1)'">';
	if not missing(occur) then 
    put '                        <occurrences>' occur +(-1)'</occurrences>';
	put '                        <subjectsAffected>' patsn +(-1)'</subjectsAffected>';
	put '                        <subjectsExposed>' patn +(-1)'</subjectsExposed>';
	put '                    </value>';

	/*closing tagset for each AE*/
	if last.term then
		do;
			put '                </values>';
			put '            </nonSeriousAdverseEvent>';
		end;

	/*closing tagset for all AEs*/
	if eof then
		put '        </nonSeriousAdverseEvents>';
run;


/*SAEs output*/
data _null_;
	file "&file" mod;
	set SAEs end=eof;
	by term;

	/*opening tagset for all SAEs*/
	if _n_=1 then
		put '        <seriousAdverseEvents>';

	/*opening tagset for each SAE*/
	if first.term then
		do;
			put '            <seriousAdverseEvent>';

			if not missing(desc) then
				put '                <description>' desc +(-1)'</description>';
			put '                <term>' term +(-1)'</term>';
			put '                <organSystem>';
			put '                    <eutctId>' eutctId +(-1)'</eutctId>';
			put '                    <version>' version +(-1)'</version>';
			put '                </organSystem>';
			put '                <assessmentMethod>';

			if asstype=1 then
				put '                    <value>ADV_EVT_ASSESS_TYPE.systematic</value>';
			else put '                    <value>ADV_EVT_ASSESS_TYPE.non_systematic</value>';
			put '                </assessmentMethod>';
			put '                <dictionaryOverridden>false</dictionaryOverridden>';
			put '                <values>';
		end;

	/*tagsets for each arm*/
	put '                    <value reportingGroupId="ReportingGroup-' idn +(-1)'">';
	put '                        <occurrences>' occur +(-1)'</occurrences>';
	put '                        <subjectsAffected>' patsn +(-1)'</subjectsAffected>';
	put '                        <subjectsExposed>' patn +(-1)'</subjectsExposed>';
	put '                        <occurrencesCausallyRelatedToTreatment>' Occurtrt +(-1)'</occurrencesCausallyRelatedToTreatment>';
    put '                        <fatalities>';
    put '                            <deaths>' death +(-1)'</deaths>';
    put '                            <deathsCausallyRelatedToTreatment>'  deathtrt +(-1)'</deathsCausallyRelatedToTreatment>';
	put '                        </fatalities>';
	put '                    </value>';

	/*closing tagset for each SAE*/
	if last.term then
		do;
			put '                </values>';
			put '            </seriousAdverseEvent>';
		end;

	/*closing tagset for all AEs*/
	if eof then
		put '        </seriousAdverseEvents>';
run;


/*closing tagset*/
DATA _NULL_;
	FILE "&file" MOD;
	put '</aev:adverseEvents>';
run;


/*proc datasets nolist memtype=data lib=work kill;*/
/*run;*/
/*quit;*/


/*output log and output*/
dm 'output; file "&dir.\SASout\&progname..lst" replace;';                   
dm 'log; file "&dir.\SASlog\&progname..log" replace;'; 

**================================================================================;
**									END OF PROGRAM								  ;
**================================================================================;



