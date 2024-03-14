---
layout: home
title: Introduction
---
This is the home page of a [NIHR](https://www.nihr.ac.uk/)-funded project to provide tools that will prepare the required statistics needed by EudraCT or ClinicalTrials.gov and format them into the precise requirements to directly upload an XML file into the web portal, with no further data entry by hand. This tool was developed by Cambridge CTU, in collaboration with Birmingham, Glasgow, Leeds CTUs.

The remit of both  [European Clinical Trials Data Base (EudraCT)](https://eudract.ema.europa.eu/result.html) and  [ClinicalTrials.gov](https://clinicaltrials.gov/) is to provide open access to summaries of all registered clinical trial results to help prevent non-reporting of negative results and inform future research. The amount of information required and the format of the results, however, imposes a large extra workload on Clinical Trial Units at the end of studies. In particular, the adverse-event-reporting component requires entering each unique combination of treatment group and safety event along with varied amounts of additional data, depending the severity of each event.

We provide tools across several commonly used statistics software packages: an R package; SAS scripts; Stata scripts.  

For the R package, in addition to the output of XML files to upload, we provide functions to output standard tables (incidence rates, relative risk) and figures (dot plot) commonly used in journal articles and internal statistical reports. 



# Flow-Chart

An overview of the components to the tool is shown below.

![flowchart](img/flowchart.png)
