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

tables:
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
					  UNIQUE (name, domain)
					);"

	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE alias ( \
					  id SERIAL PRIMARY KEY, \
					  name VARCHAR(50) NOT NULL, \
					  domain VARCHAR(50) REFERENCES domains (domain) ON DELETE CASCADE ON UPDATE CASCADE, \
					  aka_user INT REFERENCES users ON DELETE CASCADE, \
					  UNIQUE (name, domain)
					);"
mailuser:
	sudo docker exec -it postgres \
	  psql postgres -c "CREATE USER mail WITH PASSWORD 'Cqg2amU7SY'"

	sudo docker exec -it postgres \
	  psql mail -c "GRANT SELECT ON TABLE users,alias TO mail"

example:
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO domains (domain) \
					  VALUES ('example.com');"

	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO users (name, domain, password) \
					  VALUES ('bob', 'example.com', 'abc');"

	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (name, domain, aka_user) \
					  VALUES ('bob.smith', 'example.com', '1');"

errors:
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (name, domain, aka_user) \
					  VALUES ('somename', 'unknown.com', '1');"
