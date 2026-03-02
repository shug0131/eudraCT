path <- "~/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/logo/images/"
logo_files <- list.files(path) |> grep(".*\\.png$", x=_, value = TRUE)
next_round <- df <- data.frame(id=1:length(logo_files), filename=logo_files,score=0)
while( 1 < nrow(next_round)){
  teams <- draw(next_round)
  next_round <- compare(teams)
}

next_round
df
