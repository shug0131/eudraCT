#' Calculate frequency tables from a rectangular data frame with one row per subject-event
#'
#' @param data a data set containing the following columns: \code{subjid, term, soc, serious, related, fatal, group}
#' @param exposed a numeric vector giving the numbers of subjects exposed in each group.
#' To ensure the ordering is correct either, name the vector with names matching the values in \code{data$group}, or
#' ensure that the data$group is an ordered factor, or relying on alphabetical ordering of the values in
#' \code{data$group}
#' @param excess_deaths a numeric vector giving the number of extra deaths not reporting within \code{data}. Defaults to 0.
#' @param freq_threshold a value on a percentage scale at which to remove events if the incidence falls below. Defaults to 0
#' @param soc_index a character vector either "meddra" or "soc_term", which is used to identify if the soc variable in data gives the numerical meddra code or the description in English.
#' @return a list of three dataframes: GROUP, SERIOUS, NON_SERIOUS. Each contains the summary statistics required by EudraCT, and is suitable for export.
#'
#' @seealso \code{\link{eudract_convert}} \code{\link{simple_safety_xml}}
#'
#' @export
#' @importFrom dplyr group_by summarise left_join mutate select rename ungroup %>%
#' @importFrom magrittr %<>%
#' @examples
#' safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
#' simple_safety_xml(safety_statistics, "simple.xml")
#' eudract_convert(input="simple.xml", output="table_eudract.xml")



safety_summary <- function(data, exposed, excess_deaths=0, freq_threshold=0, soc_index=c("meddra","soc_term")){
  #check the names of data
  var_names <- c("subjid", "term", "soc", "serious", "related", "fatal", "group")
  name_check <- var_names %in% names(data)
  if( !all(name_check)){
    stop( paste("your input data are missing the following variables:",
                paste(var_names[!name_check], collapse=", ")))
  }
  data <- data[,name_check]
  # check if name and length of exposed matches
  if( !inherits(data$group, "factor") ){
    data$group <- factor(data$group)

  }
  group_names <- levels(data$group)
  if( length(exposed)!=length(group_names)){
    stop("the argument 'exposed' needs to be the same length as the number of groups")
  }
  if( !is.null(names(exposed)) && !all( names(exposed) %in% group_names)  ){
    stop("the names of 'exposed' do not match up to the values in 'data$group'")
  }
  if(is.null(names(exposed))){ names(exposed) <- group_names}
  # check length, value and names of excess_deaths
  if( length(excess_deaths)==1 && length(group_names)>1 && excess_deaths==0){
    excess_deaths <- rep(0, length(group_names))
  }
  if( length(excess_deaths)!= length(group_names)){
    stop("the argument 'excess_deaths' needs to be the same length as the number of groups")
  }
  if( !is.null(names(excess_deaths)) && !all( names(excess_deaths) %in% group_names)  ){
    stop("the names of 'excess_deaths' do not match up to the values in 'data$group'")
  }
  if(is.null(names(excess_deaths))){ names(excess_deaths) <- group_names}
  # check the soc_index
  soc_index <- match.arg(soc_index)


  # Group level statistics

  group <- data %>% group_by(subjid,group) %>%
    summarise(
      serious_any=any(serious),
      nonserious_any=any(!serious),
      deaths=any(fatal)
    ) %>% group_by(group) %>%
    summarise(
      subjectsAffectedBySeriousAdverseEvents = sum(serious_any),
      subjectsAffectedByNonSeriousAdverseEvents = sum(nonserious_any),
      deathsResultingFromAdverseEvents = sum(deaths)
    ) %>%
    left_join(data.frame(subjectsExposed=exposed, group=names(exposed)), by="group") %>%
    left_join(data.frame(excess_deaths, group=names(excess_deaths)), by="group" )%>%
    mutate(
      deathsAllCauses=deathsResultingFromAdverseEvents+excess_deaths
    ) %>%
    select( group,subjectsAffectedBySeriousAdverseEvents,subjectsAffectedByNonSeriousAdverseEvents,
            deathsResultingFromAdverseEvents ,subjectsExposed,deathsAllCauses
    ) %>%
    rename("title"="group")


  # Nonserious term-level statistics

  non_serious <- data %>% dplyr::filter(!serious) %>%
    group_by(term, soc, group) %>%
    summarise(subjectsAffected=length(unique(subjid)),
              occurrences=dplyr::n()
    ) %>%
    tidyr::complete(group, tidyr::nesting(term, soc), fill=list("subjectsAffected"=0, "occurrences"=0)) %>%
    rename("groupTitle"="group") %>%
    left_join(soc_code, by=c("soc"=soc_index)) %>% ungroup() %>%
    select(groupTitle,subjectsAffected, occurrences,term,eutctId)

  # filter
  if( freq_threshold>0){
    non_serious %<>% left_join(group, by=c("groupTitle"="group")) %>%
      mutate( rate=subjectsAffected/subjectsExposed*100) %>% group_by(term,eutctId) %>%
      dplyr::filter( max(rate)>=freq_threshold) %>% ungroup %>%
      select(groupTitle,subjectsAffected, occurrences,term,eutctId)
  }

  # Serious term-level statistics.
  serious <- data %>% dplyr::filter(as.logical(serious)) %>%
    group_by(term, soc, group) %>%
    summarise(subjectsAffected=length(unique(subjid)),
              occurrences=dplyr::n(),
              occurrencesCausallyRelatedToTreatment=sum(related),
              deaths=sum(fatal),
              deathsCausallyRelatedToTreatment=sum(fatal*related)
    ) %>%
    tidyr::complete(group, tidyr::nesting(term, soc),
             fill=list("subjectsAffected"=0,
                       "occurrences"=0,
                       "occurrencesCausallyRelatedToTreatment"=0,
                       "deaths"=0,
                       "deathsCausallyRelatedToTreatment"=0
             )
    ) %>%
    rename("groupTitle"="group") %>%
    left_join(soc_code, by=c("soc"=soc_index)) %>% ungroup() %>%
    select(groupTitle,subjectsAffected, occurrences,term,eutctId,
           occurrencesCausallyRelatedToTreatment, deaths,
           deathsCausallyRelatedToTreatment
    )

  # return value
  ans <- list(GROUP=as.data.frame(group),
              NON_SERIOUS=as.data.frame(non_serious),
              SERIOUS=as.data.frame(serious)
  )
  ans <- lapply(ans, df_to_char)
  class(ans) <- "safety_summary"
  ans
}

#' function to make a data frame be entirely character vectors
#'
#' @param df a data frame
#' @keywords internal
df_to_char <- function(df){
  df <- as.data.frame(lapply(df, as.character), stringsAsFactors = FALSE)
}

#' print method for safety summary object
#' @param x a safety_summary object
#' @param ... extra arguments for the generic print method
#' @export
#' @importFrom utils head

print.safety_summary <- function(x,...){
  old_scipen <- options("scipen")
  options(scipen=999)
  cat("Group-Level Statistics\n\n")
  print(x$GROUP)
  cat("\nNon-serious event-level statistics (intial rows)\n\n")
  print(head(x$NON_SERIOUS))
  cat("\nSerious event-level statistics (intial rows)\n\n")
  print(head(x$SERIOUS))
  on.exit( options(scipen=old_scipen))
}

#' function that creates a safety_summary object from individual data.frames
#' @param group a data frame that contains the group-level statistics
#' @param non_serious a data frame that contains the non-serious term-group level statistics
#' @param serious a data frame that containts the serious term-group level statistics
#' @return  a safety_summary object
#' @export

create.safety_summary <- function(group,non_serious, serious){
  group_names <- c("title","subjectsAffectedBySeriousAdverseEvents",
                   "subjectsAffectedByNonSeriousAdverseEvents", "deathsResultingFromAdverseEvents",
                   "subjectsExposed","deathsAllCauses")
  name_check <- group_names %in% names(group) && ncol(group)==length(group_names)
  if( !all(name_check)){
    stop( "group data.frame does not have the correct variable names")
  }
  non_serious_names <- c("groupTitle","subjectsAffected" ,"occurrences","term", "eutctId" )
  name_check <- non_serious_names %in% names(non_serious) && ncol(non_serious)==length(non_serious_names)
  if( !all(name_check)){
    stop( "non_serious data.frame does not have the correct variable names")
  }
  serious_names <- c(non_serious_names,  "occurrencesCausallyRelatedToTreatment",
                     "deaths","deathsCausallyRelatedToTreatment" )
  name_check <- serious_names %in% names(serious) && ncol(serious)==length(serious_names)
  if( !all(name_check)){
    stop( "serious data.frame does not have the correct variable names")
  }



  ans <- list(GROUP=group, NON_SERIOUS=non_serious, SERIOUS=serious)
  ans <- lapply(ans, df_to_char)
  class(ans)="safety_summary"
  ans
}


if(getRversion() >= "2.15.1"){
  utils::globalVariables(
    c("deaths", "deathsAllCauses", "deathsCausallyRelatedToTreatment",
      "deathsResultingFromAdverseEvents" ,"eutctId" ,"fatal", "groupTitle" ,
      "nonserious" ,"occurrences", "occurrencesCausallyRelatedToTreatment", "rate",
      "related" ,"soc", "soc_code" ,"subjectsAffected",
      "subjectsAffectedByNonSeriousAdverseEvents",
      "subjectsAffectedBySeriousAdverseEvents", "subjectsExposed", "subjid", "term"))
}




