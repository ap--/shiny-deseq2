# matt-deseq2 global
# ==================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# imports ----
library(tidyverse)
library(shiny)
library(shinydashboard)
library(DT)
library(RColorBrewer)
library(tictoc)

# Google Analytics ----
source('modules/google_analytics.R', local = FALSE)
GA_TOKEN <- str_trim(read_file(here("GOOGLE_ANALYTICS.token")))

# Reusable Modules ----
source("modules/csv_file_box_input.R", local = FALSE)
source("modules/index_column_select_box_input.R", local = FALSE)
