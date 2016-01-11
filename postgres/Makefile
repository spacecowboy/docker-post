# Keep database data between runs
# -v /path/to/db/dir:/var/lib/postgresql/data
run:
	sudo docker run --rm --name=postgres \
					--net=mail_network \
					-e POSTGRES_PASSWORD=R12e8H0Xam \
					-e POSTGRES_USER=postgres \
					-e PGUSER=postgres \
					-e PGPASSWORD=R12e8H0Xam \
					-v /root/maildb:/var/lib/postgresql/data \
					postgres

shell:
	sudo docker exec -it postgres /bin/bash

initdb: db tables mailuser

db:
	sudo docker exec -it postgres \
	  psql postgres -c "CREATE DATABASE mail"

tables: db
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
mailuser: db tables
	sudo docker exec -it postgres \
	  psql mail -c "CREATE USER mail WITH PASSWORD 'Cqg2amU7SY'"

	sudo docker exec -it postgres \
	  psql mail -c "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE domains,users,alias TO mail"
