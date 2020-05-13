# matt-deseq2 rowname colnames select module
# ==========================================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# Module UI function
indexColumnSelectBoxInput <- function(inputId, title, width, text, rowname_label, columns_label) {
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

    selectInput(ns("rowname_column"),
      label = rowname_label,
      choices = "", selected = NULL,
      multiple = FALSE
    ),

    selectInput(ns("selected_columns"),
      label = columns_label,
      choices = "", selected = NULL,
      multiple = TRUE
    )
  )
}

# Module server function
indexColumnSelectBox <- function(input, output, session, data) {
  selectableColumns <- reactive({
    # If no data is available don't do anything yet
    validate(need(data(), message = FALSE))
    colnames(data())
  })

  state <- reactiveValues(
    rownames = "",
    colnames = ""
  )

  observe({
    state$rownames <- input$rowname_column
    state$colnames <- input$selected_columns
  })

  observe({
    scols <- selectableColumns()
    updateSelectInput(
      session,
      inputId = "rowname_column",
      choices = scols,
      selected = scols[1]
    )
    updateSelectInput(
      session,
      inputId = "selected_columns",
      choices = scols,
      selected = scols[-1]
    )
  })

  return(state)
}
