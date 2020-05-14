# shiny-deseq2
PORT ?= 8080

.PHONY: help run debug env-production env-development

help:
	@echo
	@echo "shiny-deseq2 usage:"
	@echo "  make <target>"
	@echo
	@echo "targets:"
	@echo "  help             print this help"
	@echo "  run              run the app (127.0.0.1:$(PORT))"
	@echo "  debug            run the app in showcase mode"
	@echo "  env-production   setup the conda environment"
	@echo "  env-development  setup the conda dev environment"
	@echo

run:
	R -e "shiny::runApp('./', port=$(PORT))"

debug:
	R -e "shiny::runApp('./', port=$(PORT), display.mode='showcase')"

env-production:
	conda env create --force -f=environment.yml -n shiny-deseq2

env-development: env-production
	conda env update -f=environment-dev.yml -n shiny-deseq2
