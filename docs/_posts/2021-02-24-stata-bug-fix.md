---
layout: post
title: Stata bug fix and minor improvements.
date: 2021-02-24
---

A bug was identified in the stata code where the serious events were being used to
create the output for the non-serious events.

SAS code was in error if the SOC code linked to the soc_code data set using soc_term
rather than meddra code.

Comments added to SAS and Stata to warn that the group names need to be 4 characters
in length. An error is created in the R package for this scenario; new version
released on CRAN.

Advice provide in the FAQ on how to default to systematic, rather than non-systematic,
as the method of data collection.
