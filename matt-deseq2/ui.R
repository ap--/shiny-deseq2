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
  tags$head(`_google_analytics_tag_html`(GA_TOKEN)),

  tabItems(
    tabItem(
      tabName = "data-upload",

      # Top Row: Feature Count Upload ----
      fluidRow(
        box(
          title = "Upload Feature Count Data",
          width = 3,
          collapsible = TRUE,
          status = 'warning',
          solidHeader = FALSE,

          p(
            class = "text-muted",
            "Please select a CSV file containing your feature counts for each gene."
          ),

          h5("CSV Loader Settings"),

          # Input: Select separator ----
          selectInput(
            inputId = "sep",
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
            inputId = "quote",
            label = "Quote",
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
            inputId = "header",
            label = "Header Parsing",
            choices = list("File has a header"),
            selected = "File has a header"
          ),

          tags$hr(),

          # Input: Select a file ----
          fileInput(
            inputId = "file1",
            label = "Choose CSV File",
            multiple = FALSE,
            accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".csv"
            )
          )

        ),

        box(
          title = "Feature Counts",
          width = 9,
          collapsible = TRUE,
          solidHeader = FALSE,

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
