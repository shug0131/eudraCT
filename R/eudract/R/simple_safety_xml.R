#' creates a simple xml file from the input of a safety_summary object
#'
#' @param x an object of class \code{safety_summary}, as created by \code{\link{safety_summary}}.
#' @param file a character string name the file to be created
#'
#' @return no output is returned, but a file is created as a side-effect.
#'
#' @export
#'
#' @examples
#' safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
#' simple_safety_xml(safety_statistics, "simple.xml")
#' eudract_convert(input="simple.xml", output="table_eudract.xml")

simple_safety_xml <- function(x, file){
  if(!inherits(x, "safety_summary")){stop(paste(deparse(substitute(x)), "is not a safety_summary object"))}
  GROUP <- x$GROUP
  NON_SERIOUS <- x$NON_SERIOUS
  SERIOUS <- x$SERIOUS
  file_connection <- file(file, open="w")
  writeChar('<?xml version="1.0" encoding="UTF-8"?>',con=file_connection, eos=NULL)
  writeChar('\n<TABLE>',con=file_connection, eos=NULL)
  append_xml(GROUP, file_connection)
  append_xml(NON_SERIOUS, file_connection)
  append_xml(SERIOUS, file_connection)
  writeChar('\n</TABLE>',con=file_connection, eos=NULL)
  close(file_connection)
}


#' internal function to append rows to the output xml file
#'
#' @keywords internal

append_xml <- function(data, file_connection){
  data_name <- deparse(substitute(data))
  var_names <- names(data)
  for(row in 1:nrow(data)){
    writeChar(paste0("\n<",data_name,">\n"), con=file_connection, eos=NULL)
    for( var in var_names){
      x <- as.character(data[row,var])
      if(is.na(x)){
        writeChar(paste0("\t<",var,"/>\n"), con=file_connection, eos=NULL)
      } else{
        writeChar(paste0("\t<",var,">"), con=file_connection, eos=NULL)
        writeChar( x, con=file_connection,   eos=NULL)
        writeChar(paste0("</",var,">\n"), con=file_connection, eos=NULL)
      }
    }
    writeChar(paste0("</",data_name,">"), con=file_connection, eos=NULL)
  }

}
