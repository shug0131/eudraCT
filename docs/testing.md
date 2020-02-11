---
layout: page
title: Testing
---

* toc
{:toc}

# Introduction

This test plan is designed to prescribe the scope, approach, resources and schedule
of all testing activities of the EudraCT tool project.

# Definitions

###Positive testing 
Testing performed on the system by providing the valid data as input.
###Negative testing
Testing performed on the system by providing the invalid data as input to ensure that can handle the unwanted input and user behaviour.
###White-box testing
Testing that tests internal structures or workings of an application.

# Test strategy

## Scope of testing

### Feature to be tested

All the features of the EudraCT tool – R package, which were defined in the
Specification document, need to be tested.

|Process step | Feature description|
|---|---|
| Input Data | One-row-per-event format file validation in terms of<br/> - presence minimal set of variables <br/> - values constrains for ‘Serious’, ‘Related’ and ‘Fatal’<br/> - SOCs and terms consistency|
|Statistical Calculations | Proper functioning of the safety.summary() function, in different scenarios (e.g. No SAEs, No not serious events, events with the same PT and different SOC, etc…), including negative testing.|
| | Validation of the 3 subsets of the summary (Group.csv, Serious.csv and Non_Serious.csv) in terms of: <br/> - presence minimal set of variables <br/> - valid format for values|
| XSLT converstion to simple | Export of the concatenated simple.xml file|
| | Validation of file structure against the simple.xsd schema |
| | Integrity of data for Group entries |
| XSTL converstion to eudract |   Creation of output using eudract_convert (). |
| | Validation of file structure against the schema available from the EudraCT website. |
| Upload on EudraCT website | Successful upload of the output on the EudraCT website. |

### Feature not to be tested

* User interfaces
* Hardware interfaces
* Security and performance.

## Test type

 White box testing is performed by the developer for all 3 packages.

### R package
The R package undergoes Unit testing. The purpose is to validate that each module
of the software performs as designed and produces the outputs as required by that
step of the process.
Testing is conducted using a formal set of test cases prepared on basis of the
 specification document.
It is then extended to include negative testing for some of the features details
 in section 2.1.1.
In order to ensure repeatability of testing, short R scripts are used to perform
 the testing, where possible.
In order to enhance sharing, a selection of tests is written using the R package
 /testthat, and integrated in the EudraCT tool package.
Where automate tests were not usable, manual tests are performed.

### SAS and stata

Automated R scripts written to test the R package will be used to test input and
 output files generated using the Stata and SAS packages.

## Test logistics

### Schedule

Testing starts as soon as:

* product specifications are finalised.
* the EudraCT tool is declared available for testing,
*	test cases are drafted.

### System resources

A pc connected to internet, with writing access to the project folder on CCTU
Shared drive and R Studio installation is required to perform the testing.

### Testing Characteristics

The characteristics of the testing are as follows:
-	Testing conditions: the tool is developed on the basis of the specifications.
-	Extent of testing: all test cases will be tested.
-	Method of recording test output: Outcome of each test is documented on the
Testing outline.
-	Test evaluation: a description of the expected output is pre-defined.
A test is considered passed if it meets the criteria, otherwise it is a fail.

###	Test Data Reduction

Multiple iterations of the same test are allowed until resolution.

### Test description

The Testing Outline contains the following information:
*	Category of the test  (step of reference, if manual or negative testing type),
*	Test description,
*	Expected result,
*	Input/output file, as applicable
*	Actual results;
*	Pass or Fail;
*	Comments;
*	Initials and Date.

# Testing Procedure

## Testing Set-up

The EudraCT tool is be made available and accessible to the tester.
Demonstration of its functionality is shown by the developer to the tester.
Dummy input files to be used for testing are created by the developer.
This allows that, in case of test failure, the amended module can be re-tested
 entering the same data that triggered the failure, so ensuring the problem has
  been resolved.  
A working account on the EudraCT training website is created.

## Initialisation

Tester is trained in R, EudraCT tool is installed and the document Testing
Outline is prepared and available.

## Termination

The testing process is deemed terminated when all the items have been tested and passed.

## Review and Approval

A formal review of the completed Testing Outline and related outcomes is
 conducted jointly by the developer and tester. The review includes:
*	Every failed  test;
*	Remedial actions, including timeframes for their implementation or revision
of test documents


# Deliverable Materials

The following documents will be delivered at the end of the testing process:
-	[Testing Outline]( {{ site.ghpath }}/testing/Testing%20Script%20V0.1.xslx?raw=true )
-	Test R scripts in [local folder]( {{ site.ghpath }}/testing),
-	Test R scripts in with the R package [testthat folder]( {{ site.ghpath }}/R/eudract/tests/testthat).
