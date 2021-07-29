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
* [xml schema](https://prsinfo.clinicaltrials.gov/RRSUploadSchema.xsd)
* [user guide](https://prsinfo.clinicaltrials.gov/prs-users-guide.html#section9)

## Outline Plan

Key component here will be to develop an alternative xslt file that produces
the same content as Eudract but in the slightly different schema. Examination of the
papers, with an example suggest this will be acheivable.


Now have within R a working xslt file, the relevant schema (which is passing),
and the required soc.xml (as CT.gov uses words rather than magic codes). See
[link to folder](R/eudract/tests/testhat).

Need to obtain a ClinicalTrials.gov account to test.  Is there a training portal?
Will it accept just partial results for safety only?  NO
What about the <outcomeMeasures/> which is included?
at the moment to pass the schema? Not sure

* Hae now a test account within https://prstest.clinicaltrials.gov/
* Set up a basic study, then downloaded the XML record overall
* edited the file to add in the safety data.
* Uploaded ( Home>Records > Upload Record)  and it worked
* What to use to check against schema ??

* Tool to to accept a framwork XML download and edit wtih teh new safety data
* maybe API upload from within R is a possibility ?? Warnings about overwriting safety data



Need to update with doucmentation 
* website 

Also equivalent steps for SAS and stata scripts, as for R package update.

Need to obtain a ClinicalTrials.gov account to test.  Or obtain downloads of
finished submissions, plus input data.

How to incorporate into one overall xml file is a good question, and how much
scope to provide to users.
