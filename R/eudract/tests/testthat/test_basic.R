context("basic test")
library(eudract)
library(xml2)


# See V:\STATISTICS\NON STUDY FOLDER\Academic Research\Eudract Tool\SAS\EudraCT_Upload_V1.0\EudraCT_Upload_V1.0\Validation\Notes & Reports


# Idea is to generate a sample of the final answer, the frequency tables.
# then generate individual events that fit that
# then go back using the tools and compare!



#create the answer data

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
ae_death_count <- r_bound(n_arm, pmin(all_death_count,sae_count))
GROUP <- data.frame(
  title=title,
  deathsResultingFromAdverseEvents=ae_death_count,
  subjectsAffectedBySeriousAdverseEvents=sae_count,
  subjectsAffectedByNonSeriousAdverseEvents=ae_count,
  subjectsExposed=n_exposed,
  deathsAllCauses=all_death_count
)

data_file <- "all_soc.csv"
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
                    occurrences=occurrences)


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

related_deaths <- r_bound(n_term_long, upper=pmin(deaths, related))
SERIOUS <- cbind(all_soc[rep(1:nrow(all_soc),n_arm ),],
                 groupTitle=rep(title, rep(nrow(all_soc),n_arm)),
                 subjectsAffected=subjects,
                 occurrences=occurrences,
                 deaths=deaths,
                 occurrencesCausallyRelatedToTreatment=related,
                 deathsCausallyRelatedToTreatment=related_deaths
                 )


### Now create individual patient-event level data.




subjid <- 1:sum(n_exposed)
rx <- rep(title, n_exposed)
events <-data.frame( matrix(NA, nrow = 0, ncol=8))

resample <- function(x, ...) x[sample.int(length(x), ...)]
sample(2,3, replace=TRUE)
resample(2,3,replace=TRUE)

for( rx_index in 1:nrow(GROUP)){
  #NonSerious
  all_subjects <- resample(subset(subjid,rx==GROUP[rx_index,"title"]),
                         GROUP[rx_index,"subjectsAffectedByNonSeriousAdverseEvents"])

  # This doesn't guarantee that they all will get used !!
  ae_by_group <- subset(NONSERIOUS, groupTitle==GROUP[rx_index,"title"] & occurrences>0)

  for( term_index in 1:nrow(ae_by_group)){
    n_subs <- ae_by_group[term_index,"subjectsAffected"]
    n_occurs <- ae_by_group[term_index,"occurrences"]
    subjects <- resample(all_subjects,n_subs)
    repeats <- resample(subjects,n_occurs-n_subs , replace=TRUE)
    occurs <- c(subjects, repeats)
    serious <- rep(0, n_occurs)
    related <- rep(0, n_occurs)
    fatal <- rep(0, n_occurs)
    new_rows <- cbind(ae_by_group[term_index, c("soc","term")],
                      subjid=occurs,
                      serious, related, fatal,
                      group=GROUP[rx_index,"title"]
    )
    events <- rbind(events, new_rows)
  }
  #SERIOUS
  #NonSerious
  all_subjects <- resample(subset(subjid,rx==GROUP[rx_index,"title"]),
                         GROUP[rx_index,"subjectsAffectedBySeriousAdverseEvents"])
  not_yet_dead <- all_subjects
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
    subjects <- resample(the_rest, n_subs-n_fatal_occurs)
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
                      group=GROUP[rx_index,"title"]
    )
    events <- rbind(events, new_rows)
  }
}


wd <- getwd()
if(!is_testing()){setwd("tests/testthat")}
write.csv(GROUP, "GROUP.csv")
write.csv(SERIOUS, "SERIOUS.csv")
write.csv(NONSERIOUS, "NONSERIOUS.csv")
write.csv(events, "events.csv")
setwd(wd)



result <- safety_summary(events, n_exposed, soc_index="soc_term")


result$GROUP
GROUP



compare <- dplyr::left_join(result$NON_SERIOUS, NONSERIOUS, by=c("groupTitle","term"))
with(compare, as.numeric(subjectsAffected.x) - as.numeric(subjectsAffected.y))
with(compare, as.numeric(occurrences.x) - as.numeric(occurrences.y))


compare <- dplyr::left_join(result$SERIOUS, SERIOUS, by=c("groupTitle","term"))
with(compare, as.numeric(subjectsAffected.x) - as.numeric(subjectsAffected.y))
with(compare, as.numeric(occurrences.x) - as.numeric(occurrences.y))
with(compare, as.numeric(deaths.x) - as.numeric(deaths.y))
with(compare, as.numeric(occurrencesCausallyRelatedToTreatment.x) - as.numeric(occurrencesCausallyRelatedToTreatment.y))
with(compare, as.numeric(deathsCausallyRelatedToTreatment.x) - as.numeric(deathsCausallyRelatedToTreatment.y))


safety_statistics <- safety_summary(safety, exposed=c("Experimental"=60,"Control"=67))

test_that("create stats",{
expect_is(safety_statistics,"safety_summary")
expect_equal(length(safety_statistics),3)
expect_is(safety_statistics[[1]],"data.frame")
}
)

test_that("create simple xml",{
file.remove("simple.xml")
simple_safety_xml(safety_statistics, "simple.xml")
new <- read_xml("simple.xml")
ref <- read_xml("reference/simple.xml")
expect_equal(new,ref)
  }
)

test_that("convert to eudract",{
  file.remove("table_eudract.xml")
  eudract_convert(input="simple.xml", output="table_eudract.xml")
  new <- read_xml("table_eudract.xml")
  ref <- read_xml("reference/table_eudract.xml")
  expect_equal(new,ref)
}
)


test_that("trying to use Selenium",{
skip("for now")
skip_on_appveyor()
skip_on_travis()

library(RSelenium)
#http://support.divio.com/articles/646695-how-to-use-a-directory-outside-c-users-with-docker-toolbox-docker-for-windows
#docker run -d -p 4445:4444 -p 5901:5900 -v ${pwd}:/home/statistics selenium/standalone-firefox-debug:2.53.0
# vnc viewer  password = secret

remDr <- remoteDriver(
  remoteServerAddr = "192.168.99.100",
  port = 4445L,
  browserName = "firefox"
)
#remDr$close()
remDr$open()
remDr$navigate("https://eudract-training.ema.europa.eu/results-web/login/login.xhtml")
userid <- remDr$findElement(using = "name", value = "username")
userid$sendKeysToElement(list("w6a6w8"))
password <- remDr$findElement(using= "name", value="password")
password$sendKeysToElement(list("London2016",key="enter"))



#login <- remDr$findElement(using="value", value="Login")
#login$clickElement()

#script <- "mojarra.jsfcljs(document.getElementById('cta_form'),{'resultsInEditList:1:editCtaLink':'resultsInEditList:1:editCtaLink','resultToEdit':'0015-002811-13'},'')"
#remDr$executeScript(script, args = list())

edit_first_item <- remDr$findElement(using="id", value="resultsInEditList:1:editCtaLink")
edit_first_item$clickElement()

upload <- remDr$findElement(using="id", value="load_results")
upload$clickElement()

confirm <- remDr$findElement(using="id", value="confirmUpload")
confirm$clickElement()

select_ae <- remDr$findElement(using="xpath", value="//*/option[@value='ADVERSE_EVENTS']")
select_ae$clickElement()

#Can't work out hwo to interact with the file choose menu

add_file2 <-remDr$findElement(using="id", value="fileUploader:add1")
#might work - but still have to link the local files to the docker image...
remDr$getWindowHandles()
remDr$getCurrentWindowHandle()

remDr$sendKeysToAlert(list("boo"))

remDr$close()

testCsv <- tempfile(fileext = ".csv")
x <- data.frame(a = 1:4, b = 5:8, c = letters[1:4])
write.csv(x, testCsv, row.names = FALSE)


add_file2$sendKeysToElement(list(testCsv))

add_file2$clickElement()
add_file2$getElementText()


remDr$screenshot(display=TRUE)
remDr$getTitle()


shell("docker stop $(docker ps -q)")
}
)
