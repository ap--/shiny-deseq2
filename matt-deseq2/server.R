# matt-deseq2 server
# ==================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# Define server logic ----
server <- function(input, output) {
  # store common state in reactiveValues
  state <- reactiveValues(
    num_genes = 0,
    num_conditions = 0
  )

  # feature counts
  data_feature_counts <- callModule(csvFileBox, "csv_feature_counts")
  output$csv_feature_count_table <- DT::renderDataTable(
    {
      data_feature_counts()
    },
    options = list(scrollX = TRUE)
  )
  output$data_upload_value_box_genes <- renderValueBox({
    valueBox(
      subtitle = "Number of Genes",
      value = state$num_genes,
      color = ifelse(state$num_genes > 0, "green", "red"),
      icon = icon("dna")
    )
  })
  observe({
    state$num_genes <- nrow(data_feature_counts())
  })

  # column meta data
  data_column_data <- callModule(csvFileBox, "csv_column_data")
  output$csv_column_data_table <- DT::renderDataTable(
    {
      data_column_data()
    },
    options = list(scrollX = TRUE)
  )
  output$data_upload_value_box_conditions <- renderValueBox({
    valueBox(
      subtitle = "Number of Experiment Conditions",
      value = state$num_conditions,
      color = ifelse(state$num_conditions > 0, "green", "red"),
      icon = icon("vials")
    )
  })
  observe({
    state$num_conditions <- nrow(data_column_data())
  })
}
