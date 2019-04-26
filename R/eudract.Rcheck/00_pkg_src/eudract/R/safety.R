#' Example of safety data
#'
#' A dataset containing some example data of safety event in raw source format
#'
#' @format a data frame with 8 columns and 16 rows
#' \describe{
#'    \item{pt}{meddra preferred term code}
#'    \item{subjid}{a unique subject identifier}
#'    \item{related}{a logical indicating if the event is related to the treatment}
#'    \item{fatal}{a numerical 0/1 to indicate if the event was fatal}
#'    \item{serious}{a numerical 0/1 to indicate if the event was serious}
#'    \item{group}{the treatment group for the subject}
#'    \item{term}{a text description of the event. Needs to be matching 1-1 with the pt code}
#' }
#'
#'
"safety"
