## Test environments
* local x86_64-w64-mingw32/x64 (64-bit) install, R 3.6.0
* Ubuntu 16.04.6 LTS (on travis-ci), R 3.6.1
* Windows Server 2012 R2 x64 (build 9600) on (appveyor), R3.6.1
* check_win_release


## Changes 06NOV2019

Typos, punctuation corrected in the DESCRIPTIOn file

* u  nits   -->  units
* event;for  -->  event; for
* package: prepares --> package prepares
* EudraCT; formats -->  EudraCT and formats


## Changes 04NOV2019 v2, DESCRIPTION file

Angled brackets removed in the URL field, but a reference with <> is added within the Description field

## Changes 04NOV2019

* In DESCRIPTION the URL is now contained in <> brackets
* capitals have been removed from the description line in DESCRIPTION
* In the vignette the second URL https://eudract.ema.europa.eu/docs/technical/schemas/clinicaltrial/results/adverseEvents.xsd , is retained. Further comment is added to explain it is semi-readible data/code file rather than a webpage.
* message() has replace cat or print in eudract_convert(), simple_safety_xml()
* the on.exit(options()) line has been moved within print.safety_summary() to be immediately after the options() modification.
* The examples, vignette, and testing file have been checked for writing files, and all cases have been modified to use tempdir() or tempfile().



## Previous notes are now fixed:

Found the following (possibly) invalid file URIs:
     URI: medra
       From: man/soc_code.Rd
     URI: eutctid
       From: man/soc_code.Rd
Check: for non-standard things in the check directory, Result: NOTE
   Found the following files/directories:
     'simple.xml' 'table_eudract.xml'



## R CMD check results
There were no ERRORs or WARNINGs.

There is 1 NOTE:

---

Found the following (possibly) invalid URLs:
    URL: https://eudract.ema.europa.eu/
      From: inst/doc/eudract.html
      Status: Error
      Message: libcurl error code 60:
        	server certificate verification failed. CAfile: none CRLfile: none
        	(Status without verification: OK)
    URL: https://eudract.ema.europa.eu/docs/technical/schemas/clinicaltrial/results/adverseEvents.xsd
      From: inst/doc/eudract.html
      Status: Error
      Message: libcurl error code 60:
        	server certificate verification failed. CAfile: none CRLfile: none
        	(Status without verification: OK)
---  

Both websites are outside of my control but give crucial documentation relevant to this package. The URLs are both in full working order. Hence this is a false positive.

## Downstream dependencies

New package so no downstream dependencies.
