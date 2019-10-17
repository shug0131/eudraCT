## Test environments
* local x86_64-w64-mingw32/x64 (64-bit) install, R 3.6.0
* Ubuntu 16.04.6 LTS (on travis-ci), R 3.6.1
* Windows Server 2012 R2 x64 (build 9600) on (appveyor), R3.6.1
* check_win_release

## R CMD check results
There were no ERRORs or WARNINGs.

There were 2 NOTES:

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
  
  Found the following (possibly) invalid file URIs:
    URI: medra
      From: man/soc_code.Rd
    URI: eutctid
      From: man/soc_code.Rd
---

Both websites are outside of my control but give crucial documentation relevant to this package. The URLs are both in full working order. Hence this is a false positive.

## Downstream dependencies

New package so no downstream dependencies.
