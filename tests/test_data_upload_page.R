app <- ShinyDriver$new("../", loadTimeout = 10000)
app$snapshotInit("test_data_upload_page")

app$uploadFile(`csv_feature_counts-csvfile` = "input_data/featurecounts.csv") # <-- This should be the path to the file, relative to the app's tests/ directory
app$uploadFile(`csv_column_data-csvfile` = "input_data/meta.csv") # <-- This should be the path to the file, relative to the app's tests/ directory
app$snapshot()
