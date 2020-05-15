app <- ShinyDriver$new("../", shinyOptions = list(launch.browser = TRUE))
app$snapshotInit("test_initial_page_load")

app$snapshot()
