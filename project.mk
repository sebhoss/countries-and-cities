TIMESTAMP := $(shell date +"%Y-%m-%d %H:%M:%S")

work/country-codes.txt:
	curl --silent https://unece.org/trade/cefact/unlocode-code-list-country-and-territory | htmlq --text 'table' 'td:nth-child(1)' > work/country-codes.txt

work/LoadHubCountryStaging.sql: work/country-codes.txt
	while read -r name; do echo "INSERT INTO HubCountryStaging (LoadDate, RecordSource, CountryCode) VALUES (STR_TO_DATE('${TIMESTAMP}', '%Y-%m-%d %H:%i:%s'), 'unece.org', '$${name}');" >> work/LoadHubCountryStaging.sql; done < work/country-codes.txt

work/albania-city-codes.txt:
	 curl --silent https://service.unece.org/trade/locode/al.htm | htmlq 'body > table:nth-child(3)' 'td:nth-child(2)' --remove-nodes 'body > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(1)' --text | sed 's/\xC2\xA0//g' > work/albania-city-codes.txt

work/germany-city-codes.txt:
	 curl --silent https://service.unece.org/trade/locode/de.htm | htmlq 'body > table:nth-child(3)' 'td:nth-child(2)' --remove-nodes 'body > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(1)' --text | sed 's/\xC2\xA0//g' > work/germany-city-codes.txt

work/LoadHubCityStaging.sql: work/albania-city-codes.txt work/germany-city-codes.txt
	while read -r name; do echo "INSERT INTO HubCityStaging (LoadDate, RecordSource, CityCode) VALUES (STR_TO_DATE('${TIMESTAMP}', '%Y-%m-%d %H:%i:%s'), 'unece.org', '$${name}');" >> work/LoadHubCityStaging.sql; done < work/albania-city-codes.txt
	while read -r name; do echo "INSERT INTO HubCityStaging (LoadDate, RecordSource, CityCode) VALUES (STR_TO_DATE('${TIMESTAMP}', '%Y-%m-%d %H:%i:%s'), 'unece.org', '$${name}');" >> work/LoadHubCityStaging.sql; done < work/germany-city-codes.txt


.tmp/staging-tables-sentinel: work/LoadHubCountryStaging.sql work/LoadHubCityStaging.sql queries/CreateStagingTables.sql
	mkdir --parents $(@D)
	dolt sql --file=queries/CreateStagingTables.sql
	touch $@

.tmp/country-staging-sentinel: work/LoadHubCountryStaging.sql .tmp/staging-tables-sentinel
	mkdir --parents $(@D)
	dolt sql --query='DELETE FROM HubCountryStaging'
	dolt sql --file=work/LoadHubCountryStaging.sql --batch
	touch $@

.tmp/country-loading-sentinel: .tmp/country-staging-sentinel queries/LoadHubCountry.sql
	mkdir --parents $(@D)
	dolt sql --file=queries/LoadHubCountry.sql
	touch $@

.tmp/city-staging-sentinel: work/LoadHubCityStaging.sql .tmp/staging-tables-sentinel
	mkdir --parents $(@D)
	dolt sql --query='DELETE FROM HubCityStaging'
	dolt sql --file=work/LoadHubCityStaging.sql --batch
	touch $@

.tmp/city-loading-sentinel: .tmp/city-staging-sentinel queries/LoadHubCity.sql
	mkdir --parents $(@D)
	dolt sql --file=queries/LoadHubCity.sql
	touch $@

.tmp/city-in-country-loading-sentinel: queries/LoadLinkCityInCountry.sql
	mkdir --parents $(@D)
	dolt sql --file=queries/LoadLinkCityInCountry.sql
	touch $@


##@ dolt
.PHONY: server
server: ## Start a MySQL-compatible database server
	dolt sql-server --config configuration/dolt-server.yaml

.PHONY: client
client: ## Connect to the previously started database
	dolt sql-client


##@ import
.PHONY: hubs
hubs: .tmp/country-loading-sentinel .tmp/city-loading-sentinel ## Import all hubs

.PHONY: links
links: .tmp/city-in-country-loading-sentinel ## Import all links

.PHONY: import
import: hubs links
	dolt sql --file=queries/DropStagingTables.sql
	rm -rf .tmp/staging-tables-sentinel
