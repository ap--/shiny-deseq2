# matt-deseq2 ui
# ==============
# Created by: Andreas Poehlmann <andreas@poehlmann.io>


dash_header <- dashboardHeader(
  title = "matt-deseq2"
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
  # Google Analytics Token, see `modules/google_analytics.R`
  tags$head(
    `_google_analytics_tag_html`(GA_TOKEN),
  ),

  tabItems(
    tabItem(
      tabName = "data-upload",

      # Top Row: Feature Count Upload ----
      fluidRow(
        csvFileBoxInput(
          inputId = "csv_feature_counts",
          title = "Upload Feature Count Data",
          width = 3,
          text = "Please select a CSV file containing your feature counts for each gene."
        ),
        box(
          title = "Feature Counts",
          width = 9,
          collapsible = TRUE,
          solidHeader = FALSE,
          p(
            class = "text-muted",
            "Showing the Feature Count Data loaded from your CSV"
          ),
          column(
            DT::dataTableOutput(
              outputId = "csv_feature_count_table"
            )
          , width = 12)
        )
      ),

      # Bottom Row: Column Data Upload ----
      fluidRow(
        csvFileBoxInput(
          inputId = "csv_column_data",
          title = "Upload Column Data",
          width = 3,
          text = "Please select a CSV file containing the column metadata describing your
          experiment conditions."
        ),
        box(
          title = "Column Data",
          width = 9,
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
      h2("Data Statistics")
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
