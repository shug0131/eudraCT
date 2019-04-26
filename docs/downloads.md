---
layout: page
title: Downloads
toc: true
---

This web-page is simply a front-end to a [github repository](https://github.com/shug0131/eudraCT) . Hence the links below can be accessed via directory navigation. I've added further explanation as to the final objectives, but please be aware that this currently simply a partial  mirror of the local directory hosting the project with Cambridge CTU: No guarantees

# Specification

This is a document giving the specification for the project and will be used to perform testing against. It is finalised.

 * [Specification]( {{ site.ghpath }}/Specification/Eudract%20Tool%20Specification%20V0.3.docx?raw=true )

# Software Tools

The intention is for each of the major software packages ([R](https://cran.r-project.org/), [Stata](https://www.stata.com/), [SAS](https://www.sas.com/)) to have a set of code, libraries, macros, to be used semi-automatically. The format of the original safety data cannot be totally standardised, and depends on each individual clinical trial's database. It is assumed however that it is in the format of one line per event observed, as per the specifications.  

The statistical packages will be used to compute the summary statistics needed, and may indeed be replaced by code provided by the end-user if preferred.  The statistics must then be saved in a "simple" XML format and then the final steps are universal to reformat using [XSLT](https://www.w3.org/standards/xml/transformation) to meet the EudraCT requirements.

## R

There is now an R package in development that can be installed directly from github
~~~~
devtool::install_github("shug0131/eudraCT/R/eudract")
~~~~
for directly installing from github,  and from CRAN in the longer term after testing is completed
~~~
install.packages("eudract")
~~~

However, currently it really is just a bunch of code files. A worked example is given here
~~~
library(eudract)
safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
safety_statistics
simple_safety_xml(safety_statistics, "simple.xml")
eudract_convert(input="simple.xml", output="table_eudract.xml")
~~~
and tow files, simple.xml & table_eudract.xml will have been created, the latter being suitable to upload into EudraCT.


## SAS

SAS currently has no example code to produce the summary statistics. The example given simply reads in the dataframes that were generated within R and exported.

A limitation in SAS is that variable names cannot be more than 32 characters, but eudract wants longer names. A variable *can* have a label attached that has no such limitation.  The example creates an additional data set that contains the shorter variable names and the longer labels, which need to match to the eudraCT names.  We output the three summary statistics dataframes *plus* the naming data into a simple XML file. Then we use a preliminary XSLT transformation to give new, longer,  tag names as needed.  

[SAS Example]( {{ site.ghpath }}/SAS/SAS%20Example)

## Stata

Sorry but there has been very little progress in producing code for Stata.

[Stata]( {{ site.ghpath }}/Stata)


# XSLT

The scripts used to effect XSLT transformations are here. This needs tidying up.

[XSLT]( {{ site.ghpath }}/xslt%20scripts)


# Manuals and Training

A set of manuals will be produced.

# Testing

Formal unit testing will be provided. It is the intention that any end user will be able to replicate the tests described here, and also be able to compare their outputs to a set of reference outputs to be doucmented here.
