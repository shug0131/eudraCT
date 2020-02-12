setwd("V:/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/testing/bad_data")
#tidy up files
files <- list.files()
keep <- grep("events.csv|create_bad_data.R", files)
if(length(files)>2){unlink(files[-keep])}

base <- read.csv("events.csv", stringsAsFactors = FALSE)
base <- base[,-1]
lapply(base, class)


# create a data frame with each of the variables deleted
vars <- names(base)

for(var in vars){
  index <- names(base)!=var
  x <- base[,index]
  file_name <- paste0("delete_",var,".csv")
  write.csv(x, file = file_name, row.names=FALSE)
}



#function that swaps each variable for a subsitutem and then writes a csv file
make_bad <- function(substitute,prefix){
  for(var in names(base)){
    x <- base
    x[,var] <- substitute
    file_name <- paste0(prefix,"_",var,".csv")
    write.csv(x, file = file_name, row.names = FALSE)
  }
}

# basic list of variable types: integer, character, date, float, logical
make_bad(1:nrow(base),"integer")
make_bad(rep("rhubarb", nrow(base)),"character")
make_bad(as.Date(1:nrow(base), origin=Sys.Date()), "date")
make_bad(rnorm(nrow(base)), "float")
make_bad( as.logical( rbinom(nrow(base),1,0.5)), "logical")

