run:
	sudo docker run --rm --name=postgres \
					--net=mail_network \
					-e POSTGRES_PASSWORD=R12e8H0Xam \
					-e POSTGRES_USER=postgres \
					-e PGUSER=postgres \
					-e PGPASSWORD=R12e8H0Xam \
					postgres

shell:
	sudo docker exec -it postgres /bin/bash


initdb: db tables mailuser pwaccess

pwaccess:
	sudo docker exec -it postgres \
	  sed -i -e "s#0.0.0.0/0 md5#0.0.0.0/0 password md5#" /var/lib/postgresql/data/pg_hba.conf

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

example:
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO domains (domain) \
					  VALUES ('example.com');"
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO domains (domain) \
					  VALUES ('example.org');"

	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO users (name, domain, password) \
					  VALUES ('bob', 'example.com', 'abc');"

#	sudo docker exec -it postgres \
#	  psql mail -c "INSERT INTO alias (name, domain, aka_name, aka_domain) \
#					  VALUES ('bob', 'example.com', 'bob', 'example.com');"

	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (name, domain, aka_name, aka_domain) \
					  VALUES ('bob.smith', 'example.org', 'bob', 'example.com');"

errors: db tables
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (name, domain, aka_user) \
					  VALUES ('somename', 'unknown.com', '1');"
