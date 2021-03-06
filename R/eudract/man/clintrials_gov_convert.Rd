% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clintrials_gov_convert.R
\name{clintrials_gov_convert}
\alias{clintrials_gov_convert}
\title{applies a conversion using xslt from a simple xml file to a ClinicalTrials.gov compatible file, and checks against the schema}
\usage{
clintrials_gov_convert(
  input,
  output,
  xslt = system.file("extdata", "simpleToCtGov.xslt", package = "eudract"),
  schema_input = system.file("extdata", "simple.xsd", package = "eudract"),
  schema_output = system.file("extdata", "RRSUploadSchema.xsd", package = "eudract"),
  soc = system.file("extdata", "soc.xml", package = "eudract")
)
}
\arguments{
\item{input}{a character string giving the file path to the simple xml file}

\item{output}{a character string naming the output file}

\item{xslt}{a character string giving the file path to the xslt script. Defaults to the script provided in this package}

\item{schema_input}{a character string giving the file path to the schema for the simple xml file. Defaults to the schema provided in this package}

\item{schema_output}{a character string giving the file path to the schema. A copy was downloaded and is provided in this package as the default.}

\item{soc}{a character string giving an xml file that contains the System Organ Class look-up table going from EudraCT numbers to ClinicalTrials words.}
}
\value{
the output from the validation against the schema. A new file is created as a side-effect, which is suitable to upload into ClinicalTrials.gov.
}
\description{
applies a conversion using xslt from a simple xml file to a ClinicalTrials.gov compatible file, and checks against the schema
}
\examples{
safety_statistics <- safety_summary(safety,
                                    exposed=c("Experimental"=60,"Control"=67))
simple <- tempfile(fileext = ".xml")
eudract <- tempfile(fileext = ".xml")
ct <- tempfile(fileext = ".xml")
simple_safety_xml(safety_statistics, simple)
eudract_convert(input=simple,
                output=eudract)
clintrials_gov_convert(input=simple,
                output=ct)
}
\seealso{
\code{\link{safety_summary}} \code{\link{simple_safety_xml}}
}
