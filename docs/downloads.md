---
layout: page
title: Downloads
toc: true
---

* toc
{:toc}

## Grab and Go

Compressed folders with self-contained tools are available to download here:


* [R CRAN](https://CRAN.R-project.org/package=eudract) or install within R using ```install.packages("eudract")```
* [SAS]({{ site.ghpath }}/SAS/SAS%20Eudract%20Tools.zip?raw=true)
* [Stata]({{ site.ghpath }}/Stata/Stata%20Eudract%20Tools.zip?raw=true)

##  Source Code

This web-page is simply a front-end to a [github repository](https://github.com/shug0131/eudraCT) . Hence the links below can be accessed via directory navigation. I've added further explanation as to the final objectives.

## Software Tools

The intention is for each of the major software packages ([R](https://cran.r-project.org/), [Stata](https://www.stata.com/), [SAS](https://www.sas.com/)) to have a set of code, libraries, macros, to be used semi-automatically. The format of the original safety data cannot be totally standardised, and depends on each individual clinical trial's database. It is assumed however that it is in the format of one line per event observed, as per the specifications.  

The statistical packages will be used to compute the summary statistics needed, and may indeed be replaced by code provided by the end-user if preferred [see here](faq.html#i-want-to-use-my-own-code-to-calculate-the-summary-statistics).  The statistics must then be saved in a "simple" XML format and then the final steps are universal to reformat using [XSLT](https://www.w3.org/standards/xml/transformation) to meet the EudraCT requirements.

### R

There is an officially release, with testing included, in [CRAN](https://CRAN.R-project.org/package=eudract)
~~~
install.packages("eudract")
~~~

The development version is available from github using the R command.
~~~~
devtools::install_github("shug0131/eudract_pkg", build_vignettes = TRUE)
~~~~

A worked example is given here
~~~
library(eudract)
safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
safety_statistics
simple_safety_xml(safety_statistics, file="simple.xml")
eudract_convert(input="simple.xml", output="table_eudract.xml")
clintrials_gov_convert(input="simple.xml",
                       original=system.file("extdata", "1234.xml", package ="eudract"),
                output="ct_upload_file.xml")
~~~
and the files, simple.xml, table_eudract.xml, ct_upload_file.xml will have been created, the last two being suitable to upload into EudraCT and ClinicalTrials.gov respectively. 

Note that the example for ClinicalTrials there must first be a study set-up within website, and then a download of the XML taken. This is the original argument. Then the original file has the safety events data over-written, and can be manually uploaded back into ClinicalTrials.gov



### SAS

There is now a fully worked and self-sufficient example using SAS in the directory. Start with the file "safety_summary.SAS" and see the comments and "README.txt" file.

A limitation in SAS is that variable names cannot be more than 32 characters, but eudract wants longer names. A variable *can* have a label attached that has no such limitation.  The example creates an additional data set that contains the shorter variable names and the longer labels, which need to match to the eudraCT names.  We output the three summary statistics dataframes *plus* the naming data into a simple XML file. Then we use a preliminary XSLT transformation to give new, longer,  tag names as needed.  

[SAS Example]( {{ site.ghpath }}/SAS)

### Stata

There is now a fully worked and self-sufficient example using Stata in the directory. Start with the file "safety_scriptv0.2.do" and see the comments and "README.txt" file.

If the user can create the summary statistics inside stata, then there are now tools that can convert into xml for upload. Stata saves the internal data into xml format using an in-built command "xmlsave", and then we have provided xslt files that convert. Stata can call a shell command to effect these transformations.

[Stata]( {{ site.ghpath }}/Stata)

### Standard Safety Reporting (R only)

To produce tables and figures suitable for reporting documents, the following code is a worked example

~~~
library(eudract)
safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
incidence_table(safety_statistics, type="serious")
relative_risk_table(safety_statistics, type="non_serious")
dot_plot(safety_statistics, type="non_serious", base=4)
~~~


## XSLT

The scripts used to effect XSLT transformations, with schema files and related data.
[XSLT]( {{ site.ghpath }}/xml%20tools)
