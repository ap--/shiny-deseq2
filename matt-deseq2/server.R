# matt-deseq2 server
# ==================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# Define server logic ----
server <- function(input, output) {

  # feature counts
  data_feature_counts <- callModule(csvFileBox, "csv_feature_counts")
  output$csv_feature_count_table <- DT::renderDataTable({
    data_feature_counts()
  })

  # column meta data
  data_column_data <- callModule(csvFileBox, "csv_column_data")
  output$csv_column_data_table <- DT::renderDataTable(
    {
      data_column_data()
    },
    options = list(scrollX = TRUE)
  )
}
