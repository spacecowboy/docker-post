# docker-post/postgres

Regular postgres database container for dockerpost. To start a
suitable container directly do:

```
docker run --rm --name=postgres \
  --net=mail_network \
  -e POSTGRES_PASSWORD=R12e8H0Xam \
  -e POSTGRES_USER=postgres \
  -e PGUSER=postgres \
  -e PGPASSWORD=R12e8H0Xam \
  -v /root/maildb:/var/lib/postgresql/data \
  postgres:9.4
```

This just starts a copy of the official Postgres container. The
password and user are for the default root user. A separate user is
created for the mail tables specifically so you may change these if
you like.

The containers need to communicate with each other, and to do so in an
isolated manner a docker network is used. Every SystemD script will
create the network before starting, if it doesn't already exist. To
create it manually, do:

    docker network create mail_network

before starting the container. This creates a *bridge* type network.

## Config options

The environment variables (`-e`) are used to create a default user, if
a database does not yet exist, and to then provide default credentials
for sql commands done inside that container. You can change the
password (and username) if you like. A specific mail user for the
containers is created later.

The volume (`-v`) specifies where to save (and create if necessary)
the database and can be omitted if you actually want your database to
go away when you stop the container (useful during
development). Change `/root/maildb` to a location of your choice.
