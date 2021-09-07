# ClinicalTrials.Gov

## Introduction

There is a counterpart web portal for registering and report clincial
trial result for the FDA, the US government's equivalent to EMA.

The scope for uploading trial results does appear to be very similar to teh EUdract
site. Hence this folder is the start of a very tentative project to extned
the tool to allow Safety data to be uploaded via an xml file.

## References

Preliminary google search suggests this has been acheived alread using
SAS

* [sas paper 1](https://www.lexjansen.com/pharmasug/2012/AD/PharmaSUG-2012-AD10.pdf)
* [sas paper 2](https://www.lexjansen.com/nesug/nesug10/ph/ph01.pdf)

They outline that the user would need to load up one xml file containing all the
information. This is not as flexible as the EUdract system that allows an
upload of just the safety data.

THe approach recommended, is for the user to first manually enter teh admin information
and efficacy results, then download the XML file produced, add in teh safety XML
file produced by code, re upload.

Details of the xml file are given

* [prose dscription](https://prsinfo.clinicaltrials.gov/results_definitions.html)
* [overall xml schema](https://prsinfo.clinicaltrials.gov/ProtocolRecordSchema.xsd)
* [results xml schema](https://prsinfo.clinicaltrials.gov/RRSUploadSchema.xsd)
* [user guide](https://prsinfo.clinicaltrials.gov/prs-users-guide.html#section9)

## Outline Plan



Now have within R a working xslt file, the relevant schema (which is passing),
and the required soc.xml (as CT.gov uses words rather than magic codes). See
[link to folder](R/eudract/tests/testhat).

Have  a ClinicalTrials.gov account to test and it is working.  

API upload from within R is built as well



* Need to update with doucmentation 
* website 
* sort out environment variables on Travis etc, for testing with passwords on CT.gov
* Do Stata code
* R testing ?

* CRAn
* Furthe dissemination


