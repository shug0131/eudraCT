dm 'log; clear; output; clear;'; /* clear log and output */
/*
___________________________________________________________________________

	Filename				:   DummyDataCreator.SAS

	Date created			:   11/07/2017

	Last amended       		:   13/07/2017 ( To add additional scenarios for the validation of the creator prog - the other data will not be affected just re-saved)

	Trial             		:   N/A

	Analysis				:   N/A

	Purpose Of Program 		:   To create dummy data for the EudraCT validation process

	Directory	      		:   P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASprogs

	Statistician	   		:   Kara-Louise Royle

	SAS version      		:   

	Datasets created  		:  

	Output files			:   

	Reviewed by				:

	Date reviewed			:
___________________________________________________________________________
*/

* Specifying different librarys for the different dummy datasets so they can all be tracked;
libname Dummy "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\Dummy";
libname A "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioA";
libname B "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioB";
libname C "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioC";
libname D "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioD";
libname E "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioE";
libname F "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioF";
libname G "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioG";
libname H "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\ScenarioH";
libname Upload "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\Upload";
libname Upload2 "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\Upload2";
libname Upload3 "P:\CTRU\Stats\Programming\SAS\Eudract\Validation\SASdata\Upload3";

/* Creating the different datasets */

/* Obtaining master CTCAE so we have correct terms for AE and SAE datasets */
proc import out= WORK.ctcae
			datafile="P:\CTRU\Stats\Programming\SAS\Eudract\Validation\Rdata\CTCAE_4.03_2010-06-14.xlsx" 
			dbms=XLSX REPLACE; 
			getnames=yes; 
RUN;

/* Randomly choosing ten events for both the AE and SAE dataset */

proc surveyselect data = ctcae method = SRS rep = 1 
  sampsize = 10 seed = 1707111 out = sae_dummy(rename=(CTCAE_v4_0_SOC=SOC CTCAE_v4_0_Term=term) drop=replicate);
  id CTCAE_v4_0_SOC CTCAE_v4_0_Term;
run;

proc surveyselect data = ctcae method = SRS rep = 1 
  sampsize = 10 seed = 1707112 out = ae_dummy(rename=(CTCAE_v4_0_SOC=SOC CTCAE_v4_0_Term=term) drop=replicate);
  id CTCAE_v4_0_SOC CTCAE_v4_0_Term;
run;

proc print data=sae_dummy noobs;
	run;

proc print data=ae_dummy noobs;
	run;

/* Choosing 26 distinct SOC */
proc sort data=ctcae out=SOC_all;
	by CTCAE_v4_0_SOC;
run;

data SOC_distinct(keep=CTCAE_v4_0_SOC CTCAE_v4_0_Term);
	set SOC_all;
	by CTCAE_v4_0_SOC;
	if first.CTCAE_v4_0_SOC;
run;

proc print data=SOC_distinct noobs;
	run;


/* Importing the Dummy data */

/* EudraCT Groups */
proc import out=work.EudractGrpsPre
			datafile="P:\CTRU\Stats\Programming\SAS\Eudract\Validation\Rdata\DummyCorrect.xlsx" 
			dbms=XLSX REPLACE; 
			getnames=yes; 
			sheet = "EudractGrps";
run;
*Correcting the lengths;
data EudractGrps;
	length id $ 62 desc $ 999;
	set EudractGrpsPre;
run;

/* EudraCT SAE */	
proc import out=work.EudractSAEPre
			datafile="P:\CTRU\Stats\Programming\SAS\Eudract\Validation\Rdata\DummyCorrect.xlsx" 
			dbms=XLSX REPLACE; 
			getnames=yes; 
			sheet = "EudractSAE";
run;	
*Correcting the lengths;
data EudractSAE;
	length SOC $ 100 term $ 100 desc $ 250;
	set EudractSAEPre;
run;
/* EudraCT AE */
proc import out=work.EudractAEPre
			datafile="P:\CTRU\Stats\Programming\SAS\Eudract\Validation\Rdata\DummyCorrect.xlsx" 
			dbms=XLSX REPLACE; 
			getnames=yes; 
			sheet = "EudractAE";
run;
*Correcting the lengths;
data EudractAE;
	length SOC $ 100 term $ 100 desc $ 250;
	set EudractAEPre;
run;

/* Checking the data is in the right form as per guideline */
proc contents data=EudractGrps;
	run;

proc contents data=EudractSAE;
	run;

proc contents data=EudractAE;
	run;

/* Removing the formats & labels which were made as a result of importing data from excel */
proc datasets lib=work;
modify EudractGrps;
format _all_; 
informat _all_;
attrib _all_ label='';
modify EudractAE;
format _all_; 
informat _all_;
attrib _all_ label='';
modify EudractSAE;
format _all_; 
informat _all_;
attrib _all_ label='';
run; 
quit;

/* Saving the correct dummy data */
data dummy.EudractGrps;
	set EudractGrps;
run;
data dummy.EudractSAE;
	set EudractSAE;
run;
data dummy.EudractAE;
	set EudractAE;
run;

/* Removing datasets so we don't get confused calling things the same name */
proc datasets nolist memtype=data lib=work kill;
run;
quit;

/* Scenario A - Each dataset contains only variables with the correct names, variable types, lengths and formats as specified in documentation " */

data A.EudractGrps(drop=x);
	*length is supposed to be 62;
	length id $ 500;
	set dummy.EudractGrps(rename=(deathae=x));
	*idn is correct term;
	rename idn=ifn;
	*deathae is supposed to be numeric;
	deathae = put(x, 8.);
	*No formats should be on the data;
	format death best4.;
	*No labels should be on the data;
	label patn = "Number of patients in safety population";
run;

data A.EudractAE(drop=z);
	*length is supposed to be 250.;
	length desc $ 10;
	set dummy.EudractAE(rename=(Asstype=z));
	*patsn is correct term;
	rename patsn = patn;
	*Asstype is supposed to be numeric;
	Asstype = put(z,3.);
	*No variable is supposed to have a format;
	format term $100.;
	*No variable should have a label;
	label occur="Number of occurences";
run;

data A.EudractSAE(drop=y);
	*length is supposed to be 100.;	
	length SOC $ 50;
	set dummy.EudractSAE(rename=(patsn=y));
	*occur is the correct term;
	rename occur = occurance;
	*patsn is supposed to be numeric;
	patsn=put(y,5.);
	*No variable should have a format;
	format SOC $100.;
	*No variable should have a label;
	label Asstype="Assessment Type";
run;

/* Scenario B: For required fields in the Eudract system each dataset contains no missing data. */

data B.EudractGrps;
	set dummy.EudractGrps;
	*Changing all the required values to have a missing value;
	if idn = 1 then idn = . ;
	if id="Group 2" then id = "";
	if idn=2 then patn = .;
	if id="Group 1" then patae = . ;
	if idn = 2 then patsae = .;
	if id="Group 1" then death = .;
run;

data B.EudractAE;
	set dummy.EudractAE;
	*Changing all the required values to have a missing value;
	if idn = 1 and patsn = 113 then idn = .;
	if SOC = "Nervous system disorders" then SOC = "";
	if term = "Lung infection" then term="";
	if idn = 2 and patsn = 130 then Asstype = .;
	if patsn = 115 then patsn = .;
	if occur = 152 then occur = .;
run;

data B.EudractSAE;
	set dummy.EudractSAE;
	*Changing all required values to have a missing value;
	if idn = 2 and patsn=30 then idn = .;
	if SOC = "Psychiatric disorders" then SOC = "";
	if term = "Fall" then term = "";
	if idn = 1 and patsn=15 then Asstype = .;	
	if patsn = 22 then patsn = .;
	if occur =43 then occur=.;
	if Occurtrt = 66then occurtrt=.;
	if death = 73then death=.;
	if deathtrt = 96 then deathtrt=.;
run;

/* Scenario C: Each SOC entry in the EudractAE and EudractSAE maps to a EUTTC number   */
data C.EudractGrps;
	set Dummy.EudractGrps;
run;

data C.EudractAE;
	set Dummy.EudractAE;
	*Adding a typo so they won't match up;
	if SOC="Ear and labyrinth disorders" then SOC = "Ear and labirinth disorders";
run;

data C.EudractSAE;
	set Dummy.EudractSAE;
	*Adding a typo so they won't match up;
	if SOC = "Renal and urinary disorders" then SOC = "Renel and urinary disorders";
run;

/* Scenario D: A unique IDN is specified for each entry in the EudractGrps dataset */
data D.EudractGrps;
	set Dummy.EudractGrps;
	*Making IDN the same for both groups;
	IDN = 3;
run;

data D.EudractAE;
	set Dummy.EudractAE;
run;

data D.EudractSAE;
	set Dummy.EudractSAE;
run;

/* Scenario E: Check to see that the IDN terms defined in the EudractGrps are in both AE and SAE datasets */
data E.EudractGrps;
	set Dummy.EudractGrps;
run;

data E.EudractAE;
	set Dummy.EudractAE;
	*Setting a defined IDN to missing a renaming an IDN to something not defined. ;
	if IDN = 2 then IDN = .;
	if IDN = 1 and patsn = 121 then IDN = 3;
run;

data E.EudractSAE;
	set Dummy.EudractSAE;
	*Setting a defined IDN to missing a renaming an IDN to something not defined. ;
	if IDN = 2 then IDN = .;
	if IDN = 1 and patsn = 20 then IDN = 3;
run;

/* Scenario F: Each unique event term in EudractAE and EudractSAE datasets has one entry for each of the groups defined in the EudractGrps dataset */
data F.EudractGrps;
	set Dummy.EudractGrps;
run;

data F.EudractAE;
	set Dummy.EudractAE;
	*Removing one AE term row from the second group and adding a duplicate;
	if term="Anorectal infection" and idn=2 then do;
			term="Capillary leak syndrome";
			SOC = "Vascular disorders";
		end;
run;

data F.EudractSAE;
	set Dummy.EudractSAE;
	*Removing one SAE term row from the first group and adding a duplicate;
	if term="Dysgeusia" and idn=1 then do;
		term="Hemorrhoids";
		SOC="Gastrointestinal disorders";
	end;
run;

/* Scenario G: Each Asstype entry in the EudractAE and EudractSAE datasets is either 1 or 2 */
data G.EudractGrps;
	set Dummy.EudractGrps;
run;

data G.EudractAE;
	set Dummy.EudractAE;
	*Changing one Asstype to not be 1 or 2;
	if term="Anorectal infection" and idn=2 then AssType=3;
run;

data G.EudractSAE;
	set Dummy.EudractSAE;
	*Changing one Asstype to not be 1 or 2;
	if term="Dysgeusia" and idn=1 then AssType=-1;
run;

/* Scenario H: Are no warnings fired if the AE dataset is empty? */
data H.EudractGrps;
	set Dummy.EudractGrps;
run;
*Creating an empty AE dataset;
data H.EudractAE;
length soc $100 term $100 desc $250;
call missing(idn,soc,term,desc,Asstype,patsn,occur);
if _N_ = 0 then output;
stop;
run;

data H.EudractSAE;
	set Dummy.EudractSAE;
run;

/* Upload: If present are all the SOC numbers matched accross correctly? */ 
data Upload.EudractGrps;
	set Dummy.EudractGrps;
run;
data Upload.EudractAE;
	set Dummy.EudractAE;
run;
proc import out=work.EudractSAEPre
			datafile="P:\CTRU\Stats\Programming\SAS\Eudract\Validation\Rdata\SOCDistinct.xlsx" 
			dbms=XLSX REPLACE; 
			getnames=yes; 
run;	
*Correcting the lengths;
data EudractSAE;
	length SOC $ 100 term $ 100 desc $ 250;
	set EudractSAEPre;
run;
proc datasets lib=work;
modify EudractSAE;
format _all_; 
informat _all_;
attrib _all_ label='';
run; 
quit;

data Upload.EudractSAE;
	set EudractSAE;
run;

/* Upload2: Data uploads correctly in the presence of asstype=2 */
data Upload2.EudractGrps;
	set Dummy.EudractGrps;
run;

data Upload2.EudractAE;
	set Dummy.EudractAE;
	if term="Urinary tract pain" then asstype=2;
run;

data Upload2.EudractSAE;
	set Dummy.EudractSAE;
	if term="Fall" then asstype=2;
run;

/* Upload3: Data uploads sucessfully if there are a lot of AEs/SAEs */
data Upload3.EudractGrps;
	set Dummy.EudractGrps;
run;

/* Obtaining master CTCAE so we have correct terms for AE and SAE datasets */
proc import out= WORK.ctcae
			datafile="P:\CTRU\Stats\Programming\SAS\Eudract\Validation\Rdata\CTCAE_4.03_2010-06-14.xlsx" 
			dbms=XLSX REPLACE; 
			getnames=yes; 
RUN;

data ctcaepre;
	set ctcae;
	keep CTCAE_v4_0_SOC CTCAE_v4_0_Term;
run;

proc datasets lib=work;
modify ctcaepre;
format _all_; 
informat _all_;
attrib _all_ label='';
run; 
quit;

data Upload3.EudractAE;
   attrib soc length=$100 term length=$100 desc length=$250;
	set ctcaepre(rename=(CTCAE_v4_0_SOC=SOC CTCAE_v4_0_Term=term));
	asstype=1;
	do idn=1 to 2;
    occur = 0;
    patsn = 0;   
    output;
	end;
run;

data Upload3.EudractSAE;
   attrib soc length=$100 term length=$100 desc length=$250;
	set ctcaepre(rename=(CTCAE_v4_0_SOC=SOC CTCAE_v4_0_Term=term));
	asstype=1;
	do idn=1 to 2;
    occur = 0;
    patsn = 0; 
    occurtrt= 0; 
    death= 0;
	deathtrt = 0;
    output;
	end;
run;

/* End of Program */
