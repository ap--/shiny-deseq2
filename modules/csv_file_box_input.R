# matt-deseq2 csv upload module
# =============================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>
# see https://shiny.rstudio.com/articles/modules.html for reference

# Module UI function
csvFileBoxInput <- function(inputId, title, width, text) {
  # Create a namespace function using the provided id
  ns <- NS(inputId)

  box(
    title = title,
    width = width,
    collapsible = TRUE,
    solidHeader = FALSE,

    p(
      class = "text-muted",
      text
    ),

    h5("CSV Loader Settings"),

    # Input: Select separator ----
    selectInput(
      inputId = ns("sep"),
      label = "Seperator:",
      choices = c(
        "Comma" = ",",
        "Semicolon" = ";",
        "Tab" = "\t"
      ),
      selected = ",",
      multiple = FALSE
    ),

    # Input: Select quotes ----
    selectInput(
      inputId = ns("quote"),
      label = "Quote:",
      choices = c(
        "None" = "",
        "Double Quote" = '"',
        "Single Quote" = "'"
      ),
      selected = '"',
      multiple = FALSE
    ),

    # Input: Checkbox if file has header ----
    checkboxGroupInput(
      inputId = ns("header"),
      label = "Header Parsing:",
      choices = list("File has a header"),
      selected = "File has a header"
    ),

    tags$hr(),

    # Input: Select a file ----
    fileInput(
      inputId = ns("csvfile"),
      label = "Choose CSV File:",
      multiple = FALSE,
      accept = c(
        "text/csv",
        "text/comma-separated-values,text/plain",
        ".csv"
      )
    )
  )
}

# Module server function
csvFileBox <- function(input, output, session) {
  # The selected file, if any
  userFile <- reactive({
    # If no file is selected, don't do anything
    validate(need(input$csvfile, message = FALSE))
    input$csvfile
  })

  # The user's data, parsed into a data frame
  dataframe <- reactive({
    read.csv(userFile()$datapath,
      header = !is.null(input$header), # I hate you R.
      quote = input$quote,
      stringsAsFactors = FALSE
    )
  })

  # Return the reactive that yields the data frame
  return(dataframe)
}
