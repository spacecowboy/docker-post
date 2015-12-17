run:
	sudo docker run --rm --name=postgres \
					-e POSTGRES_PASSWORD=R12e8H0Xam \
					-e PGUSER=R12e8H0Xam \
					-e POSTGRES_USER=postgres \
					-e PGUSER=postgres \
					postgres

initdb: db tables mailuser

db:
	sudo docker exec -it postgres \
	  psql postgres -c "CREATE DATABASE mail"

tables: db
	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE domains ( \
					  id SERIAL PRIMARY KEY, \
					  domain VARCHAR(50) UNIQUE NOT NULL \
					);"

	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE users ( \
					  id SERIAL PRIMARY KEY, \
					  name VARCHAR(50) NOT NULL, \
					  domain VARCHAR(50) REFERENCES domains (domain) ON DELETE CASCADE ON UPDATE CASCADE, \
					  password VARCHAR(50) NOT NULL, \
					  UNIQUE (name, domain) \
					);"

	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE alias ( \
					  id SERIAL PRIMARY KEY, \
					  name VARCHAR(50) NOT NULL, \
					  domain VARCHAR(50) NOT NULL, \
					  aka_name VARCHAR(50) NOT NULL, \
					  aka_domain VARCHAR(50) NOT NULL, \
					  UNIQUE (name, domain), \
					  FOREIGN KEY (aka_name, aka_domain) REFERENCES users (name, domain) ON DELETE CASCADE ON UPDATE CASCADE \
					);"
mailuser: db tables
	sudo docker exec -it postgres \
	  psql mail -c "CREATE USER mail WITH PASSWORD 'Cqg2amU7SY'"

	sudo docker exec -it postgres \
	  psql mail -c "GRANT SELECT ON TABLE users,alias TO mail"

example: db tables
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO domains (domain) \
					  VALUES ('example.com');"
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO domains (domain) \
					  VALUES ('example.org');"

	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO users (name, domain, password) \
					  VALUES ('bob', 'example.com', 'abc');"

	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (name, domain, aka_user, aka_domain) \
					  VALUES ('bob.smith', 'example.org', 'bob', 'example.com');"

errors: db tables
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (name, domain, aka_user) \
					  VALUES ('somename', 'unknown.com', '1');"
