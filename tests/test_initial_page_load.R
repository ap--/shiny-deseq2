app <- ShinyDriver$new("../", loadTimeout = 10000)
app$snapshotInit("test_initial_page_load")

app$snapshot()
