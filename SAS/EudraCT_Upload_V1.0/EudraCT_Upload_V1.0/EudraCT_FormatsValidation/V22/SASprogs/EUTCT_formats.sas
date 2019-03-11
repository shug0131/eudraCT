dm 'log; clear; output; clear;'; /* clear log and output */
**--------------------------------------------------------------------------------;
**||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
**--------------------------------------------------------------------------------;
**                                                                                ;
**Filename..........Eudract Fotmats                                               ;
**                                                                                ;
**Date created......09/02/2017                                                    ;
**                                                                                ;
**Last amended......11/07/2017 (Changing lib folder for validation)               ;
**                                                                                ;
**Trial.............NA                                                            ;
**                                                                                ;
**Analysis..........NA                					                          ;
**                                                                                ;
**Program purpose...Output formats for EUTCT codes from MEDDRA SOC                ;
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

/*will need to update this libname to the correct folder*/
libname library "P:\CTRU\Stats\Programming\SAS\Eudract\EudraCT_FormatsValidation\SASformats";


/*google 'eutct meddra' and take the first link or follow*/
/*http://eutct.ema.europa.eu/eutct/viewListDisplay.do?listId=100000000006&firstTime=true&d-5037238-p=1&d-5037238-n=1&d-5037238-o=1&d-5037238-s=termName*/

/*to check eutct meddra system organ class terms*/
/*The number is the 'identifier' for each SOC term*/
/*The version is found by clicking 'See operational attributes' and using the revision number */

proc format library=library;
	invalue version
		'VersionNumber'=21;
	invalue soc
		'Blood and lymphatic system disorders'=100000004851
		'Cardiac disorders'=100000004849
		'Congenital, familial and genetic disorders'=100000004850
		'Ear and labyrinth disorders'=100000004854
		'Endocrine disorders'=100000004860
		'Eye disorders'=100000004853
		'Gastrointestinal disorders'=100000004856
		'General disorders and administration site conditions'=100000004867
		'Hepatobiliary disorders'=100000004871
		'Immune system disorders'=100000004870
		'Infections and infestations'=100000004862
		'Injury, poisoning and procedural complications'=100000004863
		'Investigations'=100000004848
		'Metabolism and nutrition disorders'=100000004861
		'Musculoskeletal and connective tissue disorders'=100000004859
		'Neoplasms benign, malignant and unspecified (incl cysts and polyps)'=100000004864
		'Nervous system disorders'=100000004852
		'Pregnancy, puerperium and perinatal conditions'=100000004868
		'Psychiatric disorders'=100000004873
		'Renal and urinary disorders'=100000004857
		'Reproductive system and breast disorders'=100000004872
		'Respiratory, thoracic and mediastinal disorders'=100000004855
		'Skin and subcutaneous tissue disorders'=100000004858
		'Social circumstances'=100000004869
		'Surgical and medical procedures'=100000004865
		'Vascular disorders'=100000004866
	;
run;

**================================================================================;
**									END OF PROGRAM								  ;
**================================================================================;
