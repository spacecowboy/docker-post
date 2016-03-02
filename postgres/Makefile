.DEFAULT_GOAL := help

.PHONY: help build run shell

help: ## Print a description of all available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'



# Keep database data between runs
# -v /path/to/db/dir:/var/lib/postgresql/data
run: ## Run a container with the default configuration
	sudo docker run --rm --name=postgres \
					--net=mail_network \
					-e POSTGRES_PASSWORD=R12e8H0Xam \
					-e POSTGRES_USER=postgres \
					-e PGUSER=postgres \
					-e PGPASSWORD=R12e8H0Xam \
					-v /root/maildb:/var/lib/postgresql/data \
					postgres

shell: ## Open a bash session inside the 'dovecot' container
	sudo docker exec -it postgres /bin/bash

initdb: db tables mailuser ## Initialize the database, creating the database, users, and tables

db: ## Create the 'mail' database
	sudo docker exec -it postgres \
	  psql postgres -c "CREATE DATABASE mail"

tables: db ## Create the tables of the 'mail' database, and create the database
	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE domains ( \
					  domain TEXT UNIQUE NOT NULL \
					);"

	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE users ( \
					  name TEXT NOT NULL, \
					  domain TEXT REFERENCES domains (domain) ON DELETE CASCADE ON UPDATE CASCADE, \
					  password TEXT NOT NULL, \
					  UNIQUE (name, domain) \
					);"

	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE alias ( \
					  name TEXT NOT NULL, \
					  domain TEXT NOT NULL, \
					  aka_name TEXT NOT NULL, \
					  aka_domain TEXT NOT NULL, \
					  UNIQUE (name, domain), \
					  FOREIGN KEY (aka_name, aka_domain) REFERENCES users (name, domain) ON DELETE CASCADE ON UPDATE CASCADE, \
					  FOREIGN KEY (domain) REFERENCES domains (domain) ON DELETE CASCADE ON UPDATE CASCADE \
					);"
mailuser: db tables ## Create the mail user, and create the database and tables
	sudo docker exec -it postgres \
	  psql mail -c "CREATE USER mail WITH PASSWORD 'Cqg2amU7SY'"

	sudo docker exec -it postgres \
	  psql mail -c "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE domains,users,alias TO mail"
