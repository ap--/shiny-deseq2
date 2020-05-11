# matt-deseq2 server
# ==================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# Define server logic ----
server <- function(input, output) {
  # store common state in reactiveValues
  state <- reactiveValues(
    num_genes = 0,
    num_unique_genes = 0,
    num_conditions = 0,
    num_unique_conditions = 0
  )

  # TAB1 --------
  # feature counts ----
  data_feature_counts <- callModule(csvFileBox, "csv_feature_counts")
  data_select_cols_feature_counts <- callModule(
    indexColumnSelectBox,
    "select_rowcol_feature_counts",
    data_feature_counts
  )
  observe({
    selection <- data_select_cols_feature_counts
    df <- data_feature_counts()
    req(selection$rownames, df)
    state$num_genes <- nrow(df)
    state$num_unique_genes <- n_distinct(df[selection$rownames])
  })
  # filter columns of dataframe in reactive variable for reuse in other tabs
  data_fc_filter_0 <- reactive({
    selection <- data_select_cols_feature_counts
    df <- data_feature_counts()
    req(selection$rownames, selection$colnames, df)
    all_selected <- union(selection$rownames, selection$colnames)
    df <- df[, all_selected] %>%
      remove_rownames() %>%
      column_to_rownames(var = selection$rownames) %>%
      as.data.frame()
  })
  # display in table
  output$csv_feature_count_table <- DT::renderDataTable(
    {
      data_fc_filter_0()
    },
    options = list(scrollX = TRUE)
  )
  # update value box on top
  output$data_upload_value_box_genes <- renderValueBox({
    value <- state$num_genes
    subtitle <- "Number of Genes"
    color <- "red"
    if (state$num_genes > 0) {
      color <- "green"
      if (state$num_genes != state$num_unique_genes) {
        value <- sprintf("%d / %d", state$num_unique_genes, state$num_genes)
        subtitle <- "Number of Genes (WARNING: not all are unique!)"
        color <- "yellow"
      }
    }
    valueBox(
      subtitle = subtitle,
      value = value,
      color = color,
      icon = icon("dna")
    )
  })

  # column meta data ----
  data_column_data <- callModule(csvFileBox, "csv_column_data")
  data_select_cols_column_data <- callModule(
    indexColumnSelectBox,
    "select_rowcol_column_data",
    data_column_data
  )
  observe({
    df <- data_column_data()
    selection <- data_select_cols_column_data
    req(selection$colnames, df)
    state$num_conditions <- nrow(df)
    state$num_unique_conditions <- n_distinct(df[selection$colnames])
  })
  # filter columns of dataframe in reactive variable for reuse in other tabs
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
  # display in table
  output$csv_column_data_table <- DT::renderDataTable(
    {
      data_cd_filter_0()
    },
    options = list(scrollX = TRUE)
  )
  # update value box on top
  output$data_upload_value_box_conditions <- renderValueBox({
    value <- "0"
    if (state$num_conditions > 0) {
      value <- sprintf("%d unique of %d total", state$num_unique_conditions, state$num_conditions)
    }
    valueBox(
      subtitle = "Number of Experiment Conditions",
      value = value,
      color = ifelse(state$num_conditions > 0, "green", "red"),
      icon = icon("vials")
    )
  })


  # TAB2 --------
  output$data_stats_hist_all <- renderPlot({
    df <- data_fc_filter_0()
    hist(
      as.matrix(log2(df + 1)),
      breaks = 100,
      col = "orchid4",
      border = "white",
      main = "Log2-transformed counts per Gene",
      xlab = "log2(counts + 1)",
      ylab = "Number of gene samples",
      las = 1,
      cex.axis = 0.7
    )
  })

  output$data_stats_boxplots_conditions <- renderPlot({
    df <- data_fc_filter_0()
    cd <- data_cd_filter_0()
    colourCount <- length(unique(cd))
    getPalette <- colorRampPalette(brewer.pal(9, "Set1"))
    boxplot(
      log2(df + 1),
      getPalette(colourCount),
      pch = ".",
      horizontal = TRUE,
      xlab = "log2(counts + 1)",
      ylab = "Number of gene samples",
      las = 1
    )
  })
}
