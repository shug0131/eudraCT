dm 'log; clear; output; clear;'; /* clear log and output */

/* UPDATE to Study Directory. */
%let dir=P:\CTRU\Projects\...;

**--------------------------------------------------------------------------------;
**||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
**--------------------------------------------------------------------------------;
**                                                                                ;
**Filename..........EUTCT_formats_V22                                             ;
**                                                                                ;
**Date created......09/02/2017                                                    ;
**                                                                                ;
**Last amended......															  ;  
**																				  ;
**Trial.............	                                                          ;
**                                                                                ;
**Analysis..........                					                          ;
**                                                                                ;
**Program purpose...Output formats for EUTCT codes from MEDDRA SOC                ;
**																				  ;
**Directory.........&dir above 								       				  ;
**                                                                                ;
**Statistician...... Andrew Hall                                                  ;
**                                                                                ;
**SAS version.......9.4                                                           ;
**                                                                                ;
**Datasets created..None                                                          ;
**                                                                                ;
**Output files......None                                                          ;
**                                                                                ;
**Reviewed by....... Kara-Louise Royle                                            ;
**                                                                                ;
**Date reviewed..... 02/08/2017                                                   ;
**                                                                                ;
**--------------------------------------------------------------------------------;
**||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
**--------------------------------------------------------------------------------;

/*UPDATE this libname to the correct folder*/
libname library "&dir.\SASformats";


/* Follow the instructions within the work instruction to check and if need be update the formats as instructed */

proc format library=library;
	invalue version
		'VersionNumber'=22;
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
		'Product issues'=100000167503
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

/* Output log and output. */
dm 'output; file "&dir.\SASout\&progname..lst" replace;';                   
dm 'log; file "&dir.\SASlog\&progname..log" replace;'; 

**================================================================================;
**									END OF PROGRAM								  ;
**================================================================================;
