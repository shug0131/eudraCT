library(shiny)
library(bslib)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Logo A/B Test",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    radioButtons(
      inputId = "result",
      label = "Choose your preference",
      choices = c("A", "B"),
      selected = ""
    ),
    actionButton(
      inputId = "submit", label = "Submit",
      disabled = TRUE
    ),
    uiOutput("download")
  ),
  # Output: Images
  layout_columns(
    card(
      card_header("A"),
      plotOutput(outputId = "imageA")
    ),
    card(
      card_header("B"),
      plotOutput(outputId = "imageB")
    )
  )
)
