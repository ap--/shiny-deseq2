# shiny-deseq2
PORT ?= 8080

.PHONY: help run debug env-production env-development dev-create-test test

help:
	@echo
	@echo "shiny-deseq2 usage:"
	@echo "  make <target>"
	@echo
	@echo "targets:"
	@echo "  help             print this help"
	@echo "  run              run the app (127.0.0.1:$(PORT))"
	@echo "  debug            run the app in showcase mode"
	@echo "  test             run the tests"
	@echo "  env-production   setup the conda environment"
	@echo "  env-development  setup the conda dev environment"
	@echo "  dev-create-test  create a new shinytest test"
	@echo

run:
	R -e "shiny::runApp('./', port=$(PORT))"

debug:
	R -e "shiny::runApp('./', port=$(PORT), display.mode='showcase')"

test:
	R -f run_tests.R

deploy:
	R -f deploy_app.R

env-production:
	conda env create --force -f=environment.yml -n shiny-deseq2

env-development: env-production
	conda env update -f=environment-dev.yml -n shiny-deseq2

dev-create-test:
	R -e "shinytest::recordTest('.', shinyOptions=list(launch.browser = TRUE))"
