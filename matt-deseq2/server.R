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
  data_select_cols_feature_counts <- callModule(
    indexColumnSelectBox,
    "select_rowcol_feature_counts",
    data_feature_counts
  )
  data_fc_filter_0 <- reactive({
    selection <- data_select_cols_feature_counts
    df <- data_feature_counts()
    req(selection$rownames, selection$colnames, df)
    all_selected <- union(selection$rownames, selection$colnames)
    df[, all_selected] %>%
      remove_rownames() %>%
      column_to_rownames(var = selection$rownames) %>%
      as.data.frame()
  })
  output$csv_feature_count_table <- DT::renderDataTable(
    {
      data_fc_filter_0()
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
  data_select_cols_column_data <- callModule(
    indexColumnSelectBox,
    "select_rowcol_column_data",
    data_column_data
  )
  data_cd_filter_0 <- reactive({
    selection <- data_select_cols_column_data
    req(selection$rownames, selection$colnames, df)
    all_selected <- union(selection$rownames, selection$colnames)
    df <- data_column_data()
    df[, all_selected] %>%
      remove_rownames() %>%
      column_to_rownames(var = selection$rownames) %>%
      as.data.frame()
  })
  output$csv_column_data_table <- DT::renderDataTable(
    {
      data_cd_filter_0()
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
