# matt-deseq2 global
# ==================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# imports
library(tidyverse)
library(shiny)
library(shinydashboard)

# Google Analytics
source('modules/google_analytics.R', local = FALSE)
GA_TOKEN <- str_trim(read_file(here("GOOGLE_ANALYTICS.token")))


