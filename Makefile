# shiny-deseq2
PORT ?= 8080

.PHONY: help run debug

help:
	@echo
	@echo "shiny-deseq2 usage:"
	@echo "  make <target>"
	@echo
	@echo "targets:"
	@echo "  help   print this help"
	@echo "  run    run the app (127.0.0.1:$(PORT))"
	@echo "  debug  run the app in showcase mode"
	@echo

run:
	R -e "shiny::runApp('./', port=$(PORT))"

debug:
	R -e "shiny::runApp('./', port=$(PORT), display.mode='showcase')"
