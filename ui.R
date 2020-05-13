# shiny-deseq2 ui
# ===============
# Created by: Andreas Poehlmann <andreas@poehlmann.io>


dash_header <- dashboardHeader(
  title = "shiny-deseq2"
)

dash_sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Data Upload", tabName = "data-upload", icon = icon("dashboard")),
    menuItem("Data Statistics", tabName = "data-stats", icon = icon("chart-bar")),
    menuItem("DESeq2 Analysis", tabName = "analysis", icon = icon("microscope")),
    menuItem("Data Download", tabName = "data-download", icon = icon("download")),
    menuItem("Visualization", tabName = "data-visualization", icon = icon("chart-pie"))
  )
)

dash_body <- dashboardBody(
  tags$head(
    # Google Analytics Token, see `modules/google_analytics.R`
    `_google_analytics_tag_html`(GA_TOKEN),
    # include custom.css
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  # load shinyjs
  shinyjs::useShinyjs(),

  tabItems(
    # Data Upload Tab ----
    tabItem(
      tabName = "data-upload",

      # Indicators ----
      fluidRow(
        valueBoxOutput("data_upload_value_box_genes", width = 6),
        valueBoxOutput("data_upload_value_box_conditions", width = 6)
      ),

      # Top Row: Feature Count Upload ----
      h2("Feature Counts"),
      fluidRow(
        csvFileBoxInput(
          inputId = "csv_feature_counts",
          title = "Upload Feature Count Data",
          width = 2,
          text = "Please select a CSV file containing your feature counts for each gene."
        ),
        indexColumnSelectBoxInput(
          inputId = "select_rowcol_feature_counts",
          title = "Configure Feature Count Data",
          width = 2,
          text = "Please configure the rownames and columns for the feature count data.",
          rowname_label = "Gene Names",
          columns_label = "Condition Columns"
        ),
        box(
          title = "Feature Counts",
          width = 8,
          collapsible = TRUE,
          solidHeader = FALSE,
          p(
            class = "text-muted",
            "Showing the Feature Count Data loaded from your CSV"
          ),
          column(
            DT::dataTableOutput(
              outputId = "csv_feature_count_table"
            ),
            width = 12
          )
        )
      ),

      # Bottom Row: Column Data Upload ----
      h2("Condition Meta Data"),
      fluidRow(
        csvFileBoxInput(
          inputId = "csv_column_data",
          title = "Upload Column Data",
          width = 2,
          text = "Please select a CSV file containing the column metadata describing your
          experiment conditions."
        ),
        indexColumnSelectBoxInput(
          inputId = "select_rowcol_column_data",
          title = "Configure Column Data",
          width = 2,
          text = "Please configure the rownames and columns for the column data.",
          rowname_label = "Condition Labels",
          columns_label = "Select Meta Data Columns"
        ),
        box(
          title = "Column Data",
          width = 8,
          collapsible = TRUE,
          solidHeader = FALSE,
          p(
            class = "text-muted",
            "Showing the Column Data loaded from your CSV"
          ),
          DT::dataTableOutput(
            outputId = "csv_column_data_table"
          )
        )
      )
    ),

    tabItem(
      tabName = "data-stats",
      h2("Data Statistics"),

      fluidRow(
        box(
          title = "Filter genes",
          width = 9,
          collapsible = TRUE,
          solidHeader = FALSE,
          p(
            class = "text-muted",
            "Adjust these sliders to remove rows that have less than Minimum Counts
            total accross all conditions."
          ),
          column(
            width = 6,
            sliderInput("min_condition_counts", "Minimum Counts for each Condition:",
              min = 0, max = 100,
              value = 0
            )
          ),
          column(
            width = 6,
            sliderInput("min_total_counts", "Minimum Total Counts:",
              min = 0, max = 100,
              value = 0
            )
          )
        )
      ),

      fluidRow(
        box(
          title = "Counts Histogram of the whole dataset",
          width = 6,
          collapsible = TRUE,
          solidHeader = FALSE,
          p(
            class = "text-muted",
            "Check if this histogram agrees with the required DESeq2 assumptions
            and do aditional filtering if necessary."
          ),
          plotOutput(
            outputId = "data_stats_hist_all"
          ) %>% shinycssloaders::withSpinner()
        ),

        box(
          title = "Box plots of individual conditions",
          width = 6,
          collapsible = TRUE,
          solidHeader = FALSE,
          p(
            class = "text-muted",
            "Showing boxplots of log2(counts + 1) for all conditions"
          ),
          plotOutput(
            outputId = "data_stats_boxplots_conditions"
          ) %>% shinycssloaders::withSpinner()
        )
      )
    ),

    tabItem(
      tabName = "analysis",
      h2("DESeq2 Analysis")
    ),

    tabItem(
      tabName = "data-download",
      h2("Data Download")
    ),

    tabItem(
      tabName = "data-visualization",
      h2("Visualization")
    )
  )
)

# The UI main function
ui <- dashboardPage(
  dash_header,
  dash_sidebar,
  dash_body,
)
