---
layout: post
title: Stata code corrected for scenario with no SAEs or AEs at all in a study.
date: 2020-02-14
---

If the study data contained no SAEs at all, or if there were no non-serious AEs at all,
then the Stata code previously would crash with errors. This has been corrected with
some conditional statements.
