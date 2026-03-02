
server <- function(input, output) {
  path <- "~/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/logo/images/"
  logo_files <- list.files(path) |> grep(".*\\.png$", x = _, value = TRUE)
  next_round <- df <- data.frame(id = 1:length(logo_files), filename = logo_files, score = 0)

  draw <- function(df) {
    # random order
    # pair up in sequence, add in the odd one out
    n <- nrow(df)
    df <- df[sample(1:n), ]
    k <- n %/% 2
    m <- n %% 2

    home <- df[1:k, ]
    away <- df[(k + 1):(2 * k), ]
    bye <- df[m * n, ]
    list(home = home, away = away, bye = bye)
  }

  teams <- draw(next_round)
  match <- 1
  n <- nrow(teams$home)
  next_round <- teams$bye
  final <- FALSE

  final_event <- reactive({
    final
  }) |>
    bindEvent(input$submit)


  observe({
    updateActionButton(
      inputId = "submit",
      disabled = input$result == "" | final
    )
  })

  observe({
    result <- ifelse(input$result == "A", teams$home[match, "id"], teams$away[match, "id"])
    df[df$id == result, "score"] <<- 1 + df[df$id == result, "score"]
    next_round <<- rbind(next_round, df[df$id == result, ])
    match <<- match + 1
    updateRadioButtons(inputId = "result", selected = character(0))
    if (match == n + 1) {
      final <<- nrow(next_round) == 1
      match <<- 1
      teams <<- draw(next_round)
      n <<- nrow(teams$home)
      next_round <<- teams$bye
    }
  }) |> bindEvent(input$submit)


  # still need to handle moving to next round, and stopping when have a winner


  output$imageA <- renderImage(
    {
      input$submit
      file <- teams$home[match, "filename"]
      list(src = file.path("images", file), width = "100%")
    },
    deleteFile = FALSE
  )

  output$imageB <- renderImage(
    {
      input$submit
      file <- teams$away[match, "filename"]
      list(src = file.path("images", file), width = "100%")
    },
    deleteFile = FALSE
  )

  output$download <- renderUI({
    input$submit
    if (final_event()) {
      downloadButton("downloadData", "Download")
    }
  })


  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(df, file, row.names = FALSE)
    }
  )


  output$end <- renderUI({
    input$submit
    if (final_event()) {
      helpText("The winner is shown now. Please download and save to `STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/logo/results` with your initials in the filename")
    }
  })

}
