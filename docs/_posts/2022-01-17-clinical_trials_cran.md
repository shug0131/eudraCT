---
layout: post
title: ClinicalTrials.gov functionality release on CRAN
date: 2022-01-17
---

Functionality has been provide to create XML files for upload of safety data to ClinicalTrials.gov. CRAN release available for R, and examples scripts available for Stata, and SAS.

You need to have already created the study within ClinicalTrials.gov and then downloaded it as XML. The tools provided here then edit that file with the additional safety data, and it can be uploaded.  The R tools have the facility to automate the steps of downloading, editing and uploading, if you provide user account and password.


Also some minor fixes: whitespace and missing value handling, forward-compatibility with tidyr::complete.
