
rcmdcheck::rcmdcheck()


devtools::build_vignettes(clean=FALSE)
devtools::clean_vignettes()



.libPaths("U:/My Documents/R/win-library/3.6")
devtools::build_vignettes()
devtools::document(roclets = c('rd', 'collate', 'namespace'))
devtools::build()

#Check you've got the right version number
install.packages("../eudract_0.9.0.tar.gz",
                 repos = NULL, type = "source")
devtools::build("../eudract_0.9.0.tar.gz", binary=TRUE)

install.packages("V:/STATISTICS/NON STUDY FOLDER/Software/R/R Code Library/cctu_0.9.0.zip",
                 repos = NULL, type="win.binary")

#devtools::build( binary=TRUE)
