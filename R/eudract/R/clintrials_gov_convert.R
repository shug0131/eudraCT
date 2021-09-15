#' applies a conversion using xslt from a simple xml file to a ClinicalTrials.gov compatible file, and checks against the schema
#'
#' @param input a character string giving the file path to the simple xml file
#' @param original a character string giving the file path to the study file downloaded from ClinicalTrials.gov
#' @param output a character string naming the output file
#' @param xslt a character string giving the file path to the xslt script. Defaults to the script provided in this package
#' @param schema_input a character string giving the file path to the schema for the simple xml file. Defaults to the schema provided in this package
#' @param schema_results a character string giving the file path to the schema for the results section of the output. A copy was downloaded and is provided in this package as the default.
#' @param schema_output a character string giving the file path to the schema for the overall output. A copy was downloaded and is provided in this package as the default.
#' @param soc a character string giving an xml file that contains the System Organ Class look-up table going from EudraCT numbers to ClinicalTrials words.
#'
#' @return the output from the validation against the schema. A new file is created as a side-effect, which is suitable to upload into ClinicalTrials.gov. This over-writes the file given in \code{original} with the additional safety events.
#' @seealso \code{\link{safety_summary}} \code{\link{simple_safety_xml}}
#'
#' @export
#' @example example/canonical.R


clintrials_gov_convert <- function(input, original, output,
                            xslt=system.file("extdata","simpleToCtGov.xslt", package="eudract"),
                            schema_input=system.file("extdata","simple.xsd", package="eudract"),
                            schema_results=system.file("extdata","RRSUploadSchema.xsd", package="eudract"),
                            schema_output= system.file("extdata", "ProtocolRecordSchema.xsd", package="eudract"),
                            soc=system.file("extdata","soc.xml", package="eudract")
){
  doc <- xml2::read_xml(input)
  original <- xml2::read_xml(original)
  style <- xml2::read_xml(xslt)
  schema_input <- xml2::read_xml(schema_input)
  schema_output <- xml2::read_xml(schema_output)
  schema_results <- xml2::read_xml(schema_results)
  # check against the input schema
  check_in <- xml2::xml_validate(doc, schema_input)
  if( !check_in){ stop("safety data is invalid\n", attr(check_in,"errors"))}
  check_in <- xml2::xml_validate(original, schema_output)
  if( !check_in){ stop("original study file is invalid \n", attr(check_in,"errors"))}

  soc <- normalizePath(soc, winslash = "/")
  soc <- gsub("\\s","%20", soc) # As the xslt document() function needs this
  safety <- xslt::xml_xslt(doc, style,params=list(soc_xml_file_path=soc))
  xml2::xml_replace(
    xml2::xml_find_first(original, "//reportedEvents"),
    xml2::xml_find_first(safety, "//reportedEvents"),
    .copy=TRUE
  )
  
  
# alternative xslt way to do this, used in SAS and Stata code is
  
  # find_replace <- xml2::read_xml(system.file("extdata","find_replace.xslt", package="eudract"))
  # xml2::write_xml(safety, output) 
  # replace <- normalizePath(output, winslash = "/")
  # replace <- gsub("\\s","%20", replace)
  # using the original safety data not running line 41
  # original <- xslt::xml_xslt(original, find_replace, params=list(replace_file_path=replace))
  
  
  
  
  xml2::write_xml(original, output)
  
  message(paste0("'",output, "' is created or modified\n"))
  #check against the output schema
  check_out <- xml2::xml_validate(safety, schema_results)
  if( !check_out){ warning(attr(check_out,"errors"))}

  check_out <- xml2::xml_validate(original, schema_output)
  if( !check_out){ warning(attr(check_out,"errors"))}

  message("Please email cctu@addenbrookes.nhs.uk to tell us if you have successfully uploaded a study to ClinicalTrials.gov .\nThis is to allow us to measure the impact of this tool.")
  invisible(check_out)
}
