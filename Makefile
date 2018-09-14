.DEFAULT_GOAL := help
PROJECT_ID := ${PROJECT_ID}
GEOIP2_DB_FILE_NAME := ${GEOIP2_DB_FILE_NAME}
GEOIP2_DB_FILE_URL := ${GEOIP2_DB_FILE_URL}
GEOIP2_DB_FILE_TGZ := ${GEOIP2_DB_FILE_TGZ}

## Deploy
deploy: download_db
	gcloud --quiet beta app deploy --project=$(PROJECT_ID)

## Download DB
download_db:
	wget $(GEOIP2_DB_FILE_URL)
	tar xzf $(GEOIP2_DB_FILE_TGZ)
	mv -f GeoLite2-Country_*/$(GEOIP2_DB_FILE_NAME) .
	rm -rf $(GEOIP2_DB_FILE_TGZ) GeoLite2-Country_*

## Following logs
logs:
	gcloud app logs tail

## Open application
open:
	gcloud app browse

## Show help
help:
	@make2help $(MAKEFILE_LIST)

.PHONY: help
.SILENT:
