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
	  psql mail -c "CREATE TABLE users ( \
					  email VARCHAR(50) PRIMARY KEY, \
					  name VARCHAR(50) NOT NULL, \
					  domain VARCHAR(50) NOT NULL, \
					  password VARCHAR(50) NOT NULL \
					);"

	sudo docker exec -it postgres \
	  psql mail -c "CREATE TABLE alias ( \
					  email VARCHAR(50) PRIMARY KEY, \
					  aka VARCHAR(50) REFERENCES users ON DELETE CASCADE \
					                                   ON UPDATE CASCADE \
					);"
mailuser:
	sudo docker exec -it postgres \
	  psql postgres -c "CREATE USER mail WITH PASSWORD 'Cqg2amU7SY'"

	sudo docker exec -it postgres \
	  psql mail -c "GRANT SELECT ON TABLE users,alias TO mail"

example:
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO users (email, name, domain, password) \
					  VALUES ('bob@example.com', 'bob', 'example.com', 'abc');"

	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (email, aka) \
					  VALUES ('bob.smith@example.org', 'bob@example.com');"

errors:
	sudo docker exec -it postgres \
	  psql mail -c "INSERT INTO alias (email, aka) \
					  VALUES ('bla', 'blabla');"
