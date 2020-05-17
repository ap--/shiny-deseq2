# shiny-deseq2 deploy to shinyapps.io
# ===================================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

library(rsconnect)

# goto your shinyapps.io control panel and copy the TOKEN code
# into a file named "SHINYAPPS_SECRET.R"

if (!file.exists("SHINYAPPS_SECRET.R")) {
  stop("SHINYAPPS_SECRET.R not in folder!")
}
source("SHINYAPPS_SECRET.R")

library(BiocManager)  # fixes bioconductor depenceny error on shinyapps.io
options(repos = BiocManager::repositories())

deployApp(".", appName = "shiny-deseq2")
