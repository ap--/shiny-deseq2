# shiny-deseq2 &mdash; a not so shiny deseq2 app

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/ap--/shiny-deseq2/ShinyTest)

I wanted to try see how difficult it is to make a shiny app.
So here is a DESeq2 analysis running in R with a shiny frontend.
<br>
_Disclaimer: I am no expert at all doing differential gene expression analysis, I just needed something to build the app for._

### Access the app online
You can access the online version at [poehlmann.shinyapps.io/shiny-deseq2](https://poehlmann.shinyapps.io/shiny-deseq2/).

**To get started you can download a test dataset from here:**
[example_featurecounts.csv](https://raw.githubusercontent.com/ap--/shiny-deseq2/master/www/example_data/featurecounts.csv)
and
[example_meta.csv](https://raw.githubusercontent.com/ap--/shiny-deseq2/master/www/example_data/meta.csv)

### Contribute
- It'd be awesome if you want to help :heart:
- If this is somewhat useful to you drop me a message!
- If you find scientific mistakes anywhere in the analysis pipeline file a bug and let me know!
- If you know better ways to do this, or visualize it send me a message!

### Notes

To learn how to make shiny apps I tried to immediately start with best practices for organizing larger apps.

#### R package environment

I looked at `packrat` and `conda` for environment management and ultimately decided to use `conda` for this project.
This is probably because I am more familiar with `conda` already.
To setup your environment run either:
```
# install the production environment (environment.yml)
make env-production
# or install the dev environment (environment.yml + environment-dev.yml)
make env-development
```

#### Run the app locally

I tried to put everything in the make file. `make help` will give you an overview. To run the app setup the env and then:
```
make run
```

#### Develop

I setup `shinytest` for this app. Simply do `make test` to run the tests. If you want to add a new test run
`make dev-create-test` and interactively create a new test case in your browser. Note: all test will fail initially
if you add more reactive state to the app or change the main layout. You can run `make test-interactive` to
step through the failed tests and accept changes if they are cosmetic only.
