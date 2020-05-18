# shiny-deseq2 server
# ===================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

set_menu_item_class <- function(selector, class_, state) {
  if (state) {
    shinyjs::addClass(selector = selector, class = class_)
  } else {
    shinyjs::removeClass(selector = selector, class = class_)
  }
}

# Define server logic ----
server <- function(input, output, session) {
  # store common state in reactiveValues
  state <- reactiveValues(
    num_genes = 0,
    num_unique_genes = 0,
    num_conditions = 0,
    num_unique_conditions = 0,
    num_filtered_genes = 0,
    has_dds = FALSE
  )

  observe({
    is_enabled <- state$num_genes > 0 & state$num_conditions > 0
    for (tab_id in list("data-stats", "analysis")) {
      selector <- sprintf("a[data-value=%s]", tab_id)
      set_menu_item_class(selector, "item-disabled", !is_enabled)
    }
    for (tab_id in list("data-download", "data-visualization")) {
      selector <- sprintf("a[data-value=%s]", tab_id)
      set_menu_item_class(selector, "item-disabled", !state$has_dds)
    }
  })

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
    # implicit return of variables makes me uncomfortable...
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
  df_tidy <- reactive({
    df_cd <- data_cd_filter_0() %>%
      # note: join by rownames isn't supported https://github.com/tidyverse/dplyr/issues/1270
      # todo: should not allow ___condition___ column, but it'll do for now...
      rownames_to_column(var = "___condition___")
    # ? seems I need to assign for the implicit return in expressions to work with pipes
    df <- data_fc_filter_0() %>%
      # todo: and should not allow ___gene___ column...
      rownames_to_column(var = "___gene___") %>%
      pivot_longer(-"___gene___", names_to = "condition", values_to = "counts") %>%
      dplyr::rename(gene = "___gene___") %>%
      # filter genes
      group_by(gene) %>%
      dplyr::filter(sum(counts) >= input$min_total_counts) %>%
      dplyr::filter(all(counts >= input$min_condition_counts)) %>%
      ungroup() %>%
      left_join(df_cd, by = c("condition" = "___condition___"))
  })
  observe({
    state$num_filtered_genes <- n_distinct(df_tidy()$gene)
  })
  output$data_stats_filtered_genes <- renderValueBox({
    if (state$num_unique_genes == 0 | state$num_filtered_genes == 0) {
      color <- "red"
    } else if (state$num_filtered_genes / state$num_unique_genes < 0.5) {
      color <- "yellow"
    } else {
      color <- "green"
    }
    valueBox(
      subtitle = "Filtered Genes",
      value = str_glue("{filtered} / {total}", filtered = state$num_filtered_genes, total = state$num_unique_genes),
      color = color,
      icon = icon("dna")
    )
  })

  output$data_stats_hist_all <- renderPlot({
    df <- df_tidy()
    # fixme: hist renders significantly faster than ggplot geom_histogram on first page load
    # hist(
    #   as.matrix(log2(df$counts + 1)),
    #   breaks = 100,
    #   col = "orchid4",
    #   border = "white",
    #   main = "Log2-transformed counts per Gene",
    #   xlab = "log2(counts + 1)",
    #   ylab = "Number of gene samples",
    #   las = 1,
    #   cex.axis = 0.7
    # )
    ggplot(df, aes(x = log2(counts + 1))) +
      geom_histogram(fill = "orchid4", bins = 100) +
      labs(title = "Log2-transformed counts per Gene") +
      xlab("log2(counts + 1)") +
      ylab("Number of gene samples")
  })

  output$data_stats_boxplots_conditions <- renderPlot({
    df <- df_tidy()
    ggplot(df, aes(x = log2(counts + 1), y = condition)) +
      geom_boxplot()
    # df <- data_fc_filter_0()
    # cd <- data_cd_filter_0()
    # colourCount <- length(unique(cd))
    # getPalette <- colorRampPalette(brewer.pal(9, "Set1"))
    # boxplot(
    #   log2(df + 1),
    #   getPalette(colourCount),
    #   pch = ".",
    #   horizontal = TRUE,
    #   xlab = "log2(counts + 1)",
    #   ylab = "Number of gene samples",
    #   las = 1
    # )
  })


  # TAB 3 ----
  res <- reactiveValues(
    dds = NULL,
    rld = NULL
  )
  dds <- reactiveVal(value = NULL)
  observe({
    conditions <- data_select_cols_column_data$colnames
    updateSelectInput(
      session,
      inputId = "design_columns",
      choices = conditions,
      selected = conditions
    )
  })
  observeEvent(input$run_deseq2, {
    countData <- data_fc_filter_0()
    colData <- data_cd_filter_0()
    selected <- input$design_columns
    validate(
      need(!is.null(selected), "Please select at least one condition")
    )
    withProgress(message = "Running DESeq2 Analysis", {
      .dds <- DESeq2::DESeqDataSetFromMatrix(
        countData = countData,
        colData = colData,
        design = as.formula(
          paste("~ ", paste(selected, collapse = " + "))
        )
      )
      setProgress(value = 1/3)
      dds <- DESeq2::DESeq(.dds)
      res$dds <- dds
      setProgress(value = 2/3)
      res$rld <- DESeq2::rlogTransformation(dds)
      setProgress(value = 1.0)
    })
    state$has_dds <- TRUE
  })

  # TAB 4 ----
  dds_results <- reactive({
    dds_df <- results(res$dds)
    dds_df <- dds_df[order(dds_df$padj), ]
    as.data.frame(dds_df)
  })
  output$data_download_padj <- renderValueBox({
    df <- dds_results()
    valueBox(
      subtitle = "Genes with adjusted p-value < 0.1",
      value = str_glue(
        "{significant} / {total}",
        significant = sum(df$padj < 0.1, na.rm = TRUE),
        total = nrow(df)
      ),
      color = 'green',
      icon = icon("dna")
    )
  })
  output$downloadDESeq2 <- downloadHandler(
    filename = function() {
      "shiny-deseq2-results.csv"
    },
    content = function(file) {
      write.csv(dds_results(), file, row.names = TRUE)
    }
  )
  output$deseq_results_table <- DT::renderDataTable(
    {
      dds_results()
    },
    options = list(scrollX = TRUE)
  )

  # TAB 5 ----
  output$data_visualization_plot_pca <- renderPlot({
    DESeq2::plotPCA(res$rld, intgroup=input$design_columns)
  })

  output$data_visualization_plot_dispest <- renderPlot({
    DESeq2::plotDispEsts(res$dds)
  })

}
