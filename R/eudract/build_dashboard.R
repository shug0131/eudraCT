
devtools::build_vignettes(clean=FALSE)
devtools::clean_vignettes()

devtools::build_vignettes()
devtools::build()
install.packages("../eudract_0.2.0.tar.gz",
                 repos = NULL, type = "source")
devtools::build("../eudract_0.2.0.tar.gz", binary=TRUE)

install.packages("V:/STATISTICS/NON STUDY FOLDER/Software/R/R Code Library/cctu_0.4.8.zip",
                 repos = NULL, type="win.binary")

devtools::build( binary=TRUE)
