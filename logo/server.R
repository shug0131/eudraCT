
server <- function(input, output) {
  path <- "~/STATISTICS/NON STUDY FOLDER/Academic Research/Eudract Tool/logo/images/"
  logo_files <- list.files(path) |> grep(".*\\.png$", x = _, value = TRUE)
   df <- data.frame(id = 1:length(logo_files), filename = logo_files, score = 0)

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

  state <- reactiveValues()
  state$teams <- draw(df)
  state$match <- 1
  state$final <- FALSE
  observe({
    state$n <- nrow(state$teams$home)
    state$next_round <- state$teams$bye

  })


  final_event <- reactive({
    state$final
  }) |>
    bindEvent(input$submit)


  observe({
    updateActionButton(
      inputId = "submit",
      disabled = input$result == "" | state$final
    )
  })

  observeEvent(input$submit, {
    if( !state$final) {
      result <- ifelse(input$result == "A",
                       state$teams$home[state$match, "id"],
                       state$teams$away[state$match, "id"])
      df[df$id == result, "score"] <<- 1 + df[df$id == result, "score"]
      state$next_round <- rbind(state$next_round, df[df$id == result, ])
      state$match <- state$match + 1
      updateRadioButtons(inputId = "result", selected = character(0))
    }
    if (state$match == state$n + 1) {
      # need to give byes a score increment as well.
      # Otherwise  A team with max byes winning the final gets less than
      # a losing finalist who played all the rounds.
      df[df$id==state$teams$bye[,"id"], "score" ] <<- 1+ df[df$id==state$teams$bye[,"id"], "score" ]
      state$final <- nrow(state$next_round) == 1
      state$match <- 1
      state$teams <- draw(state$next_round)
      state$n <- nrow(state$teams$home)
      state$next_round <- state$teams$bye
    }
  })


  # still need to handle moving to next round, and stopping when have a winner


  output$imageA <- renderImage(
    {
      #input$submit
      file <- state$teams$home[state$match, "filename"]
      list(src = file.path("images", file), width = "100%")
    },
    deleteFile = FALSE
  )

  output$imageB <- renderImage(
    {
     # input$submit
      file <- state$teams$away[state$match, "filename"]
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
