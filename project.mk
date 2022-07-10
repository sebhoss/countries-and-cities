##@ sql
.PHONY: server
server: ## Start a MySQL-compatible database server
	dolt sql-server --config configuration/dolt-server.yaml

.PHONY: client
client: ## Connect to the previously started database
	dolt sql-client

##@ import
.PHONY: countries
countries: ## Import all countries
	dolt sql < data/countries.sql

##@ data
work/german-letters.json: ## Read all starting letters for german cities
	curl --location --silent 'https://de.wikipedia.org/w/api.php?action=parse&prop=sections&page=Liste_der_St%C3%A4dte_in_Deutschland&formatversion=2&format=json' | jq '[.parse.sections[] | select(.line | length == 1) | {letter: .line, section: .index}]' > work/german-letters.json

.PHONY: german-cities
german-cities: work/german-letters.json ## Read all german cities into .json files
	for row in $$(cat work/german-letters.json | jq -c '.[]'); do \
		section=$$(echo $${row} | jq -r '.section'); \
		letter=$$(echo $${row} | jq -r '.letter'); \
		url="https://de.wikipedia.org/w/api.php?action=parse&prop=sections&page=Liste_der_St%C3%A4dte_in_Deutschland&formatversion=2&section=$${section}&prop=links&format=json"; \
		echo "$${section} $${letter} $${url}"; \
		curl --location --silent $${url} | jq '[.parse.links[].title]' > work/german-cities-starting-with-$${letter}.json; \
	done;

data/load-german-cities.sql: german-cities ## Read all german cities into .sql files
	rm --force data/load-german-cities.sql
	for row in $$(cat work/german-letters.json | jq -c '.[]'); do \
		letter=$$(echo $${row} | jq -r '.letter'); \
		cat work/german-cities-starting-with-$${letter}.json | jq --raw-output '.[] | "INSERT INTO cities (name, country) SELECT '\''\(.)'\'', id FROM countries WHERE short_name = '\''Deutschland'\'';"' >> data/load-german-cities.sql; \
	done;
