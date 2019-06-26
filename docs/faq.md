---
layout: page
title: FAQ
toc: true
---

# What do the variables mean in the input data?

- **group**  this is commonly know as the treatment arm and needs to be at least four characters long.
Even if you have a single arm study then you still need this to exist as a constant value.
- **subjid** brief for "subject identification". A number unique to each patient, subject, or participant in the study.
- **term** this is a text description of the adverse event, e.g. "nausea".
This does not strictly have to be taken from a dictionary (medDRA, CTCAE), but it really does help the quality.
- **soc** acronym for "System Organ Class." Which is the top-most level in a hierarchy of grouping AE taken from the [medDRA](https://www.meddra.org/) dictionary.
we have _some_ flexibility here, and either a numerical medDRA code, or the corresponding text.
- **serious** a 0/1 value indicating if the AE was serious.
- **related** a 0/1 value indicating if the AE was related to treatment.
- **fatal** a 0/1 value indicating if the AE resulted in death.

# Why do I need to enter the numbers exposed

The input data is taken to be the set of adverse events _that have been observed_: one row of data per event.
There may be subjects who did not experience any AEs if the intervention has a good safety profile.
So to calculate incidence rates with a correct denominator we need this extra data; one number per group.

# Excess Deaths?

The eudract system does allow the unusual scenario whereby not all fatalities are
captured within the AE data. If there are any such fatalities then provide counts, per group.
Generally, thought you can ignore this and use the default value of 0.

# SOC coding in more detail

If you use the eudraCT system manually to enter AE data, then for each event you can enter a _term_
using free text, but must choose the _SOC_ from a drop-down list of 27 values.
Behind the scenes this is recording a numerical code, the _eutctId_ value given in outputs,
that the eudraCT system took from sources which are rather hard to find at source.

Historically, the values were taken from [eutct](http://eutct.ema.europa.eu/), from which a copy of the codes were taken
as per the [specification document appendix]( {{ site.ghpath }}/Specification/Eudract%20Tool%20Specification%20V0.3.docx?raw=true ).
Currently the [SPOR Referentials Management System](https://spor.ema.europa.eu/rmswi/#/lists/100000000006/terms) is the replacement
although access permissions can be variable, and are outside our control, and there is no option to download in convenient tabular format.

Hence as part of the tools provided here, we include a data set that gives the Eudract code, medDRA code, english text,
to link to your data. There is a choice to link via numerical code, or text, which is specified by the argument _soc_index_, and must be
given a value of either _meddra_ for the numerical option, or _soc_term_ for the text option.

# Cleaning free-text AE descriptions

Most trials have free text descriptions of AEs provided by a clinician as source data.
Having variant spellings or descriptions of the same term in the data provided will
be misleading and split the incidence rate into multiple parts. Unlike the SOC,
the eudraCT system will accept free text for terms. It up to the study team to
convert and code free text into an AE dictionary or find an alternative means
to clean the data.

# Can I edit details after uploading

Yes, please do review and ammend by hand using the Eudract portal manually. You may want to confirm if study-wide default values
(AE dictionary, version number, incidence threshold,...) are accurate.
