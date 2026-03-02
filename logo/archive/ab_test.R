

draw <- function(df){
  #random order
  # pair up in sequence, add in the odd one out
  n <- nrow(df)
  df <- df[sample(1:n),]
  k <- n%/%2
  m <- n %%2

  home <- df[1:k,]
  away <- df[(k+1):(2*k),]
  bye <-  df[m*n,]
  list(home=home, away=away,  bye=bye)
}



compare <- function(teams){
  # run through home & away
  next_round <- teams$bye
  for( match in 1:nrow(teams$home)){
    result <- game(match, teams)
    # modify the scores in teh original df
    df[ df$id== result, "score"] <<- 1 +  df[ df$id== result, "score"]
    # create new queue
    next_round <- rbind( next_round, df[ df$id==result,])
  }
  next_round
}



game <- function( index, teams){
  # interactive input
  result <- menu(choices=c(teams$home[index,"text"],teams$away[index,"text"] ))
  #gives the  id of the winner and loser
  sides <- c("home", "away")
  teams[[ sides[result] ]][ index, "id"]
}

next_round <- df <- data.frame(id=1:7, text=letters[1:7], score=0)
while( 1 < nrow(next_round)){
  teams <- draw(next_round)
  next_round <- compare(teams)
}

next_round
df

