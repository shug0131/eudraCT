#' applies a conversion using xslt from a simple xml file to a eudract compatible file, and checks against the schema
#'
#' @param input a character string giving the file path to the simple xml file
#' @param output a character string naming the output file
#' @param xslt a character string giving the file path to the xslt script. Defaults to the script provided in this package
#' @param schema_input a character string giving the file path to the schema for the simple xml file. Defaults to the schema provided in this package
#' @param schema_output a character string giving the file path to the schema. A copy was downloaded and is provided in this package as the default.
#'
#' @return the output from the validation against the schema. A new file is created as a side-effect, which is suitable to upload into eudraCT.
#' @seealso \code{\link{safety_summary}} \code{\link{simple_safety_xml}}
#'
#' @export
#' @examples
#' safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
#' simple_safety_xml(safety_statistics, "simple.xml")
#' eudract_convert(input="simple.xml", output="table_eudract.xml")


eudract_convert <- function(input, output="table_eudract.xml",
                            xslt=system.file("extdata","simpleToEudraCT.xslt", package="eudract"),
                            schema_input=system.file("extdata","simple.xsd", package="eudract"),
                            schema_output=system.file("extdata","adverseEvents.xsd", package="eudract")
){
  doc <- xml2::read_xml(input)
  style <- xml2::read_xml(xslt)
  schema_input <- xml2::read_xml(schema_input)
  schema_output <- xml2::read_xml(schema_output)
  # check against the input schema
  check_in <- xml2::xml_validate(doc, schema_input)
  if( !check_in){ stop(attr(check_in,"errors"))}
  output_xml <- xslt::xml_xslt(doc, style)
  xml2::write_xml(output_xml, output)
  cat(paste0("'",output, "' is created or modified\n"))
  #check against the output schema
  check_out <- xml2::xml_validate(output_xml, schema_output)
  if( !check_out){ warning(attr(check_out,"errors"))}
  invisible(check_out)
}
