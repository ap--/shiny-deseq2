# shiny-deseq2 global
# ===================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# imports ----
library(DESeq2) # DESeq2 masks quite a few tidyverse things, import first so that tidyverse masks everything
library(tidyverse)
library(here)
library(shiny)
library(shinydashboard)
library(DT)
library(RColorBrewer)
library(tictoc)
library(shinycssloaders)

# Google Analytics ----
source("modules/google_analytics.R", local = FALSE)
GA_TOKEN <- google_analytics_read_token_file(here("GOOGLE_ANALYTICS.token"))

# Reusable Modules ----
source("modules/csv_file_box_input.R", local = FALSE)
source("modules/index_column_select_box_input.R", local = FALSE)
