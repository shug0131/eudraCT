---
layout: page
title: FAQ
toc: true
---

* toc
{:toc}

## Worked Example

The [vignette](https://cran.r-project.org/web/packages/eudract/vignettes/eudract.html) from the R package gives a fully worked example. The canonical example given in the R package's help pages gives the key commands to create XML files suitable for upload to either EudraCT or ClinicalTrials (note the final `clintrials_gov_upload` command is based on a fictitious user account and will not work).

~~~
safety_statistics <- safety_summary(safety,
                                    exposed=c("Experimental"=60,"Control"=67))
simple <- tempfile(fileext = ".xml")
eudract <- tempfile(fileext = ".xml")
ct <- tempfile(fileext = ".xml")
simple_safety_xml(safety_statistics, simple)
eudract_convert(input=simple,
                output=eudract)
clintrials_gov_convert(input=simple,
                       original=system.file("extdata", "1234.xml", package ="eudract"),
                output=ct)
# This needs a real user account to work
clintrials_gov_upload(
    input=simple,
    orgname="CTU",
    username="Student",
    password="Guinness",
    studyid="1234"
)
~~~

For SAS and Stata, the example script is the starting point that should work and allow you to adapt to your needs.

## What do the variables mean in the input data?

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

## Why do I need to enter the numbers exposed

The input data is taken to be the set of adverse events _that have been observed_: one row of data per event.
There may be subjects who did not experience any AEs if the intervention has a good safety profile.
So to calculate incidence rates with a correct denominator we need this extra data; one number per group.

## Excess Deaths?

The eudract system does allow the unusual scenario whereby not all fatalities are
captured within the AE data. If there are any such fatalities then provide counts, per group.
Generally, thought you can ignore this and use the default value of 0.

## SOC coding in more detail

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

## Cleaning free-text AE descriptions

Most trials have free text descriptions of AEs provided by a clinician as source data.
Having variant spellings or descriptions of the same term in the data provided will
be misleading and split the incidence rate into multiple parts. Unlike the SOC,
the eudraCT system will accept free text for terms. It up to the study team to
convert and code free text into an AE dictionary or find an alternative means
to clean the data.

## Can I edit details after uploading

Yes, please do review and ammend by hand using the Eudract portal manually. You may want to confirm if study-wide default values
(AE dictionary, version number, incidence threshold,...) are accurate.

## Systematic vs Non-Systematic reporting

The majority of studies use non-systematic reporting, whereby a patient is asked what AEs happened to them.
The alternative is where a specific list of AEs is provided and the incidence of each AE is explicitly determined.

The default in the tool is to assume that non-systematic reporting was used.
To change this manually inside the EudraCT portal would require it to be done for each AE in the list,
which may be too many changes to be practical.  

An automated alternative, _at the user's risk_, is to edit the final xslt file
[simpleToEudraCT.xlst]( {{ site.ghpath }}/xml%20tools/simpleToEudraCT.xslt)
in lines 15 and 71.

In the R package, this new xslt file would need to be saved locally and the filepath
used as an argument to the `xslt=` argument within `eudract_convert()` .
In SAS, line 297 in the script would need to be edited to use the revised xslt file.
In Stata, line 226 would need to be edited to use the revised xslt file.

## I want to use my own code to calculate the summary statistics

As described in the [Specification]( {{ site.ghpath }}/Specification/Eudract%20Tool%20Specification%20V0.3.docx?raw=true ) this is
entirely possible. You can use your own code to produce the counts and statistics as needed, and then use the latter part of the tool
to convert them into xml files needed by the EudraCT portal.

You will need to manipulate your outputs into three data sets for: Group-level, serious event-group , non serious event- group.

The variable names within those data sets need to be as follows:

#### Group

* title
*	deathsResultingFromAdverseEvents
*	subjectsAffectedBySeriousAdverseEvents
*	subjectsAffectedByNonSeriousAdverseEvents
*	subjectsExposed
*	deathsAllCauses

#### Non Serious

*	groupTitle
*	subjectsAffected
*	occurrences
*	term
*	eutctId


#### Serious
*	groupTitle
*	subjectsAffected
*	occurrences
*	term
*	eutctId
*	occurrencesCausallyRelatedToTreatment
*	deaths
*	deathsCausallyRelatedToTreatment

See [term](faq.html#what-do-the-variables-mean-in-the-input-data)  and [eutctId](faq.html#soc-coding-in-more-detail) for further details on the meaning of these variables.

### R
You would then use the internal function `create.safety_summary`
~~~
create.safety_summary(GROUP, NONSERIOUS, SERIOUS)
simple_safety_xml(safety_statistics, file="simple.xml")
eudract_convert(input="simple.xml", output="table_eudract.xml")
~~~

Where the inputs `GROUP, NONSERIOUS, SERIOUS`, are the data provided by your own code.

### SAS

You would need to start from around line 272 of the [script]({{ site.ghpath }}/SAS/safety_summary.sas) .
An issue is that SAS cannot have variable names as long as those described above. A solution
is to provide _labels_ to such variables that match the names above. There exist pre-saved versions
of SAS data, with no rows, but valid column names/labels [non serious template]({{ site.ghpath }}/SAS/non_serious_blank.sas7bdat),
[serious template]({{ site.ghpath }}/SAS/serious_blank.sas7bdat) for reference.

### Stata

You would need to save the data sets using `xmlsave`,

~~~
use non_serious
xmlsave "non_serious", legible replace
~~~
for example and then use the last few lines from line 224 of the  [script]({{ site.ghpath }}/Stata/safety_scriptv0.2.do) .
Similar to SAS there is a limit of 32 characters to variable names, but _labels_ can be used instead, e.g.
~~~
la var related "occurrencesCausallyRelatedToTreatment"
~~~
