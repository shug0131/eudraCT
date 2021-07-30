
rcmdcheck::rcmdcheck()
devtools::load_all()

devtools::build_vignettes(clean=FALSE)
devtools::clean_vignettes()
devtools::check()


.libPaths("U:/My Documents/R/win-library/4.0")
devtools::build_vignettes()
devtools::document(roclets = c('rd', 'collate', 'namespace'))
devtools::build()
devtools::test()

#Check you've got the right version number
install.packages("../eudract_0.11.0.tar.gz",
                 repos = NULL, type = "source")
devtools::build("../eudract_0.11.0.tar.gz", binary=TRUE)


#devtools::build( binary=TRUE)
# modify news.md, cran-comments.md README.rmd
devtools::check_win_release()
rcmdcheck::rcmdcheck()
devtools::check_win_devel()
devtools::check_rhub()
#check github is totally up to date
devtools::release()
devtools::submit_cran()
#add a tag to github
#do some publicity , edit the website news, CTU stats email list.
#Add the .9000 suffix to the Version field in the DESCRIPTION to
#indicate that this is a development version.
#Create a new heading in NEWS.md and commit the changes.
