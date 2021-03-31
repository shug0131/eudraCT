context("basic test")
library(eudract)
library(xml2)

if( is_testing()){path <- tempdir()} else{ path <- "tests/testthat"}
# See V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\SAS\EudraCT_Upload_V1.0\EudraCT_Upload_V1.0\Validation\Notes & Reports


# Idea is to generate a sample of the final answer, the frequency tables.
# then generate individual events that fit that
# then go back using the tools and compare!



#create the answer data

set.seed(1333)

n_arm <- 3
n_exposed <- c(20,22,18)
r_bound <- function(n,upper=100,lower=0,mean=(upper+lower)/2){
  x <- rpois(n, lambda =mean)
  pmax(pmin(x,upper),lower)
}

title <- paste("Group", toupper(letters[1:n_arm]))
ae_count <- r_bound(n_arm,n_exposed)
sae_count <- r_bound(n_arm,n_exposed)
all_death_count <- r_bound(n_arm,n_exposed)
ae_death_count <- r_bound(n_arm,
                          lower=pmax(0, all_death_count+sae_count-n_exposed),
                          upper= pmin(all_death_count,sae_count))
GROUP <- data.frame(
  title=title,
  deathsResultingFromAdverseEvents=ae_death_count,
  subjectsAffectedBySeriousAdverseEvents=sae_count,
  subjectsAffectedByNonSeriousAdverseEvents=ae_count,
  subjectsExposed=n_exposed,
  deathsAllCauses=all_death_count
)

data_file <- "data/all_soc_v2.csv"
if(!is_testing()){data_file <- paste0("tests/testthat/",data_file)}

all_soc <- read.csv(data_file, stringsAsFactors = FALSE)
term <- all_soc$term
ae_long <- rep(GROUP$subjectsAffectedByNonSeriousAdverseEvents,rep(length(term),n_arm))
n_term_long <- nrow(all_soc)*n_arm
subjects <- r_bound(n_term_long,upper=ae_long)
occurrences <- r_bound(n_term_long, lower=subjects, upper=ifelse(subjects==0,0,subjects+10))
NONSERIOUS <- cbind(all_soc[rep(1:nrow(all_soc),n_arm ),],
                    groupTitle=rep(title, rep(nrow(all_soc),n_arm)),
                    subjectsAffected=subjects,
                    occurrences=occurrences, stringsAsFactors=FALSE)

# Check that the sum across tersm, by group, of #subjects is > GROUP$subjects

if( any(
with(NONSERIOUS,tapply(subjectsAffected,groupTitle, sum))-GROUP$subjectsAffectedByNonSeriousAdverseEvents<0)
){warning("This simulation may fail- not enough subjects in NONSERIOUS")}



sae_long <- rep(GROUP$subjectsAffectedBySeriousAdverseEvents,rep(length(term),n_arm))

# This is also constrained by the deaths variable in GROUPS
# For each treatment group, need a vector of deaths that sums to
# the total given in GROUP.
# A patient can only die once, from a single event.
deaths <- integer(0)
for( i in 1:n_arm){
  deaths <- c(
    deaths,
    rmultinom(1,
              size=GROUP$deathsResultingFromAdverseEvents[i],
              prob=rep(1, length(term))
    )
  )
}
subjects <- r_bound(n_term_long,lower=deaths, upper=sae_long)
occurrences <- r_bound(n_term_long, lower=subjects, upper=ifelse(subjects==0,0,subjects+10))
related <- r_bound(n_term_long, upper=occurrences)

related_deaths <- r_bound(n_term_long, lower=pmax(0,related+deaths-occurrences), upper=pmin(deaths, related))
SERIOUS <- cbind(all_soc[rep(1:nrow(all_soc),n_arm ),],
                 groupTitle=rep(title, rep(nrow(all_soc),n_arm)),
                 subjectsAffected=subjects,
                 occurrences=occurrences,
                 deaths=deaths,
                 occurrencesCausallyRelatedToTreatment=related,
                 deathsCausallyRelatedToTreatment=related_deaths, stringsAsFactors=FALSE
                 )

if( any(
  with(SERIOUS,tapply(subjectsAffected,groupTitle, sum))-GROUP$subjectsAffectedBySeriousAdverseEvents<0)
){warning("This simulation may fail- not enough subjects in SERIOUS")}


### Now create individual patient-event level data.




subjid <- 1:sum(n_exposed)
rx <- rep(title, n_exposed)
events <-data.frame( matrix(NA, nrow = 0, ncol=8), stringsAsFactors = FALSE)

resample <- function(x, ...) x[sample.int(length(x), ...)]
sample(2,3, replace=TRUE)
resample(2,3,replace=TRUE)


# function factory to keep looping round selecting from a vector, starting where you finished before
# giving back a vector of the desired length. Call it once to create the function

loop <- function(obj, start=1){
  obj_length <- length(obj)
 #start <- 1
  function(n){
    if(n>0){
      index <- (start-1):(start+n-2) %% obj_length +1
      start <<- index[n]+1
      obj[index]
    }
  }
}




for( rx_index in 1:nrow(GROUP)){
  #NonSerious
  all_subjects <- resample(subset(subjid,rx==GROUP[rx_index,"title"]),
                         GROUP[rx_index,"subjectsAffectedByNonSeriousAdverseEvents"])
  # To guarantee that they all will get used !!
  subject_loop <- loop(all_subjects)


  # This doesn't guarantee that they all will get used !!
  ae_by_group <- subset(NONSERIOUS, groupTitle==GROUP[rx_index,"title"] & occurrences>0)

  for( term_index in 1:nrow(ae_by_group)){
    n_subs <- ae_by_group[term_index,"subjectsAffected"]
    n_occurs <- ae_by_group[term_index,"occurrences"]
    # To guarantee that they all will get used !!
    subjects <- subject_loop(n_subs) #resample(all_subjects,n_subs)
    repeats <- resample(subjects,n_occurs-n_subs , replace=TRUE)
    occurs <- c(subjects, repeats)
    serious <- rep(0, n_occurs)
    related <- rep(0, n_occurs)
    fatal <- rep(0, n_occurs)
    new_rows <- cbind(ae_by_group[term_index, c("soc","term")],
                      subjid=occurs,
                      serious, related, fatal,
                      group=GROUP[rx_index,"title"],row.names=NULL
    )
    events <- rbind(events, new_rows)
  }
  #SERIOUS
  #NonSerious
  all_subjects <- resample(subset(subjid,rx==GROUP[rx_index,"title"]),
                         GROUP[rx_index,"subjectsAffectedBySeriousAdverseEvents"])
  not_yet_dead <- all_subjects
  #to guarantee they all get uesed
  subject_loop <- loop(not_yet_dead)

  sae_by_group <- subset(SERIOUS, groupTitle==GROUP[rx_index,"title"] & occurrences>0)

  for( term_index in 1:nrow(sae_by_group)){
    # deaths only one per subject
    # adds up to total inside each term
    # start with the deaths first and then get the other, non-fatal events.
    n_fatal_occurs <- sae_by_group[term_index,"deaths"]
    fatal_occurs <- resample(not_yet_dead, n_fatal_occurs)
    not_yet_dead <- not_yet_dead[!(not_yet_dead %in% fatal_occurs)]
    #iterate the line above
    the_rest <- all_subjects[!(all_subjects %in% fatal_occurs)]
    n_subs <- sae_by_group[term_index,"subjectsAffected"]
    n_occurs <- sae_by_group[term_index,"occurrences"]
    n_related <- sae_by_group[term_index,"occurrencesCausallyRelatedToTreatment"]
    n_fatal_related <- sae_by_group[term_index,"deathsCausallyRelatedToTreatment"]
    ###to guarantee they all get uesed
    new_start <- environment(subject_loop)$start
    subject_loop <- loop(the_rest, start=new_start)
    subjects <- subject_loop(n_subs-n_fatal_occurs)#resample(the_rest, n_subs-n_fatal_occurs)
    repeats <- resample(c(fatal_occurs,subjects),n_occurs-n_subs , replace=TRUE)
    occurs <- c(fatal_occurs, subjects, repeats)
    serious <- rep(1, n_occurs)
    fatal <- rep(1:0,c(n_fatal_occurs, n_occurs - n_fatal_occurs))
    ## Not working!
    related <- c(
      resample(
        rep(1:0,
            c(n_fatal_related,n_fatal_occurs - n_fatal_related))
      ),
      resample(
        rep(1:0,
        c(n_related - n_fatal_related, n_occurs-n_related+n_fatal_related-n_fatal_occurs)
        )
      )
    )
    new_rows <- cbind(sae_by_group[term_index, c("soc","term")],
                      subjid=occurs,
                      serious, related, fatal,
                      group=GROUP[rx_index,"title"], row.names=NULL
    )
    events <- rbind(events, new_rows, stringsAsFactors=FALSE)
  }
}


write.csv(GROUP, file.path(path,"GROUP.csv"),row.names = FALSE)
write.csv(SERIOUS, file.path(path,"SERIOUS.csv"),row.names = FALSE)
write.csv(NONSERIOUS, file.path(path,"NONSERIOUS.csv"),row.names = FALSE)
write.csv(events, file.path(path,"events.csv"),row.names = FALSE)




result <- safety_summary(events, n_exposed, soc_index="soc_term")

test_that("compare GROUP input and output",{
expect_true(
  all(result$GROUP$subjectsAffectedBySeriousAdverseEvents ==GROUP$subjectsAffectedBySeriousAdverseEvents)
)
  expect_true(
    all(result$GROUP$subjectsAffectedByNonSeriousAdverseEvents ==GROUP$subjectsAffectedByNonSeriousAdverseEvents)
  )
  expect_true(
    all(result$GROUP$subjectsExposed ==GROUP$subjectsExposed)
  )
  expect_true(
    all(result$GROUP$deathsResultingFromAdverseEvents ==GROUP$deathsResultingFromAdverseEvents)
  )
}
)



compare <- dplyr::left_join(result$NON_SERIOUS, NONSERIOUS, by=c("groupTitle","term"))

test_that("Nonserious",{
  expect_true( all(with(compare, as.numeric(subjectsAffected.x) - as.numeric(subjectsAffected.y))==0))
  expect_true( all(with(compare, as.numeric(occurrences.x) - as.numeric(occurrences.y))==0))
}
)



compare <- dplyr::left_join(result$SERIOUS, SERIOUS, by=c("groupTitle","term"))

test_that("Serious",{
  expect_true(all(with(compare, as.numeric(subjectsAffected.x) - as.numeric(subjectsAffected.y))==0))
  expect_true(all(with(compare, as.numeric(occurrences.x) - as.numeric(occurrences.y))==0))
  expect_true(all(with(compare, as.numeric(deaths.x) - as.numeric(deaths.y))==0))
  expect_true(all(with(compare, as.numeric(occurrencesCausallyRelatedToTreatment.x) - as.numeric(occurrencesCausallyRelatedToTreatment.y))==0))
  expect_true(all(with(compare, as.numeric(deathsCausallyRelatedToTreatment.x) - as.numeric(deathsCausallyRelatedToTreatment.y))==0))
}
)

#simple_safety_xml(result, "simple.xml")
#eudract_convert("simple.xml","eudract.xml")

safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))

test_that("create stats",{
expect_is(safety_statistics,"safety_summary")
expect_equal(length(safety_statistics),3)
expect_is(safety_statistics[[1]],"data.frame")
}
)

test_that("create simple xml",{
simple_safety_xml(safety_statistics, file.path(path,"simple.xml"))
new <- read_xml(file.path(path,"simple.xml"))
ref <- read_xml("reference/simple.xml")
expect_equal(new,ref)
  }
)

test_that("convert to eudract",{
  eudract_convert(input=file.path(path,"simple.xml"), output=file.path(path,"table_eudract.xml"))
  new <- read_xml(file.path(path,"table_eudract.xml"))
  ref <- read_xml("reference/table_eudract.xml")
  expect_equal(new,ref)
}
)


test_that("convert to ClinicalTrials.Gov",{
  clintrials_gov_convert(input=file.path(path,"simple.xml"), output=file.path(path,"table_ct.xml"))
  new <- read_xml(file.path(path,"table_ct.xml"))
  ref <- read_xml("reference/table_ct.xml")
  expect_equal(new,ref)
}
)



test_that("works for a frequency threshold",
          {
            expect_is(
              safety_summary(safety, exposed=c("Experimental"=60,"Control"=67), freq_threshold = 3),
              "safety_summary"
            )
          }
          )

test_that("print the safety summary",{
  x <- capture_output_lines( print(safety_statistics) )
  expect_equal(x[1], "Group-Level Statistics")

})

test_that("create a safety summary by hand",{
  safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))
  safety_stats2 <- create.safety_summary(safety_statistics$GROUP,
                                         safety_statistics$NON_SERIOUS,
                                         safety_statistics$SERIOUS
                                         )
  expect_identical(safety_statistics, safety_stats2)

})







