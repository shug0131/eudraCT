
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
# modify news.md, cran-comments.md README.rmd
devtools::check_win_release()
rcmdcheck::rcmdcheck()
devtools::check_win_devel()
devtools::check_rhub()
#check github is totally up to date
devtools::release()
# add a tag to github
# do some publicity , edit the website news, CTU stats email list.
#Add the .9000 suffix to the Version field in the DESCRIPTION to
#indicate that this is a development version.
#Create a new heading in NEWS.md and commit the changes.
