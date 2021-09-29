---
layout: post
title: ClinicalTrials.gov functionality
date: 2021-09-29
---

Functionality has been provide to create XML files for upload of safety data to ClinicalTrials.gov. Beta release available for R, Stata, and SAS. 

You need to have already created the study within ClinicalTrials.gov and then downloaded it as XML. The tools provided here then edit that file with the additional safety data, and it can be uploaded.  The R tools have the facility to automate the steps of downloading, editing and uploading, if you provide user account and password.

The SAS and Stata scripts need editing to provide the local path to the downloaded XML file, and then will produce both EudraCT and ClinicalTrials.gov files. 

The R package has extra functions that are explained within the vignette.

The updated R package is not yet released on CRAN, but can be downloaded from github

`devtools::install_github("shug0131/eudract_pkg", build_vignettes = TRUE)`





