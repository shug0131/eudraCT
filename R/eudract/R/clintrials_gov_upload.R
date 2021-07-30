#' applies a conversion using xslt from a simple xml file to a ClinicalTrials.gov compatible file, merges into a study record from the portal, and uploads the result.
#'
#' @param input a character string giving the file path to the simple xml file
#' @param orgname a character string giving the organisation name used to log in
#' @param username a character string giving the user-name used to log in
#' @param password a character string giving the password used to log in
#' @param studyid a character string given the unique study id within the portal
#' @param url a character string giving the URL of the website to log in. Defaults to the live site, but the testing site is the alternative.
#' @param check a logical that will check on the command line if you want to proceed as results will be overwritten. Defaults to TRUE.
#' @param output a character string naming the output xml file
#' @param backup a character string naming the copy of the original data that is created.
#' @param xslt a character string giving the file path to the xslt script. Defaults to the script provided in this package
#' @param schema_input a character string giving the file path to the schema for the simple xml file. Defaults to the schema provided in this package
#' @param schema_results a character string giving the file path to the schema for the results section of the output. A copy was downloaded and is provided in this package as the default.
#' @param schema_output a character string giving the file path to the schema for the overall output. A copy was downloaded and is provided in this package as the default.
#' @param soc a character string giving an xml file that contains the System Organ Class look-up table going from EudraCT numbers to ClinicalTrials words.
#'
#' @return Invisibly returns the results from the two API with the portal \code{\link[httr]{response}}, \code{\link[httr]{POST}}  .  A new file is created as a side-effect, which is uploaded into ClinicalTrials.gov. This over-writes the original safety data online with the additional safety events. A backup copy of the original data is also saved.
#' @seealso \code{\link{safety_summary}} \code{\link{simple_safety_xml}} [ClinicalTrials.gov manual](https://prsinfo.clinicaltrials.gov/prs-users-guide.html#section10)
#'
#' @export
#' @example example/canonical.R



clintrials_gov_upload <- function(input, orgname, username, password, studyid,
                                   url="https://register.clinicaltrials.gov/",
                                   check=interactive(),
                                   output="study_file.xml",
                                   backup="bak_study_file.xml",
                            xslt=system.file("extdata","simpleToCtGov.xslt", package="eudract"),
                            schema_input=system.file("extdata","simple.xsd", package="eudract"),
                            schema_results=system.file("extdata","RRSUploadSchema.xsd", package="eudract"),
                            schema_output= system.file("extdata", "ProtocolRecordSchema.xsd", package="eudract"),
                            soc=system.file("extdata","soc.xml", package="eudract")
){
  #Download the original study file
  download <-  httr::POST(url=paste0(url,"prs/app/action/ExternalDownload/"),
               body=list(
                 orgName=orgname,
                 userName=username,
                 passWord=password,
                 orgStudyId=studyid
               ),
               encode="form"
  )
 original <- httr::content(download)
 xml2::write_xml(original, file=backup)

 clintrials_gov_convert(
   input=input,
   original=backup,
   output=output,
   xslt=xslt,
   schema_input=schema_input,
   schema_results=schema_results,
   schema_output= schema_output,
   soc=soc
)


 upload <- readLines(con=output)
 upload <- paste(upload, collapse="\n")

 if(check){
   check_answer=utils::askYesNo(
     paste0("This will attempt to overwrite current results in ",url,"\nDo you want to continue?")
   )
 }

 if(is.na(check_answer) ||!check_answer){
   print("Upload halted")
   upload_result <- NULL
 } else{
   upload_result <-  httr::POST(url=paste0(url,"prs/app/action/ExternalUpload"),
                                body=list(
                                  orgName=orgname,
                                  userName=username,
                                  passWord=password,
                                  uploadXML=upload,
                                  autoRelease="false"
                                ),
                                encode="form"
   )
 }
 invisible(list(download=download, upload=upload_result))
}
