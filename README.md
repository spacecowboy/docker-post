# docker-post

A collection of docker containers for setting up a complete
self-hosted e-mail system. Features include:

* SMTP server (Postfix)
* IMAP/POP server (Dovecot)
* DKIM signing of outgoing mail (OpenDkim)
* DKIM signature verification of incoming mail (Amavis)
* Spam filtering (Postscreen, Amavis with Pyzor/Razor)
* Antivirus (Amavis with Clam)
* Passwords stored hashed and salted (Postgres)
* Server side filter/script support with Sieve and ManageSieve
* Entirely [LetsEncrypt](letsencrypt.org) compatible

## How to get started

The best way is to run the system once the database is configured is
with the
[provided SystemD units](https://github.com/spacecowboy/docker-post/tree/master/systemd)
in order to get the correct startup and so on even across
reboots. During development, it is useful to run the containers
directly however.

### Setup a docker network

The containers need to communicate with each other, and to do so in an
isolated manner a docker network is used. Just create it with:

    docker network create mail_network

It is untested but in theory it should work fine to spread the
containers across several physical machines using docker machine for
example.

### Start the database

Start a container with Postgres:

```
docker run --rm --name=postgres \
  --net=mail_network \
  -e POSTGRES_PASSWORD=R12e8H0Xam \
  -e POSTGRES_USER=postgres \
  -e PGUSER=postgres \
  -e PGPASSWORD=R12e8H0Xam \
  -v /root/maildb:/var/lib/postgresql/data \
  postgres
```

This just starts a copy of the official Postgres container.

The environment variables (`-e`) are used to create a default user, if
a database does not yet exist, and to then provide default credentials
for sql commands done inside that container. You can change the
password (and username) if you like. A specific mail user for the
containers is created later.

The volume (`-v`) specifies where to save (and create if necessary)
the database and can be omitted if you actually want your database to
go away when you stop the container (useful during
development). Change `/root/maildb` to a location of your choice.

You can also change the values in the
[postgres Makefile](https://github.com/spacecowboy/docker-post/blob/master/postgres/)
and in that folder, run:

    make run

### Configure the database

All of the following steps and be done by running `make initdb`.

First create a new database called `mail`:

```
docker exec -it postgres \
  psql postgres -c "CREATE DATABASE mail"
```

Then create the necessary tables.

Domains table:

```
docker exec -it postgres \
  psql mail -c "CREATE TABLE domains ( \
    domain TEXT UNIQUE NOT NULL \
  );"
```

Users table:

```
docker exec -it postgres \
  psql mail -c "CREATE TABLE users ( \
    name TEXT NOT NULL, \
    domain TEXT REFERENCES domains (domain) ON DELETE CASCADE ON UPDATE CASCADE, \
    password TEXT NOT NULL, \
    UNIQUE (name, domain) \
  );"
```

Alias table:

```
docker exec -it postgres \
  psql mail -c "CREATE TABLE alias ( \
    name TEXT NOT NULL, \
    domain TEXT NOT NULL, \
    aka_name TEXT NOT NULL, \
    aka_domain TEXT NOT NULL, \
    UNIQUE (name, domain), \
    FOREIGN KEY (aka_name, aka_domain) REFERENCES users (name, domain) ON DELETE CASCADE ON UPDATE CASCADE, \
    FOREIGN KEY (domain) REFERENCES domains (domain) ON DELETE CASCADE ON UPDATE CASCADE \
  );"
```

The mail user (if you change the password, you'll need to change the
config options in the containers as well):

```
docker exec -it postgres \
  psql mail -c "CREATE USER mail WITH PASSWORD 'Cqg2amU7SY'"
```

And grant access to the mail tables:

```
docker exec -it postgres \
  psql mail -c "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE domains,users,alias TO mail"
```

### Start dovecot

Dovecot is the IMAP/POP/Authentication server and is run with:

```
docker run --rm --name=dovecot \
  --net=mail_network \
  --hostname=mail.example.com \
  -e mydomain=example.com \
  -p 110:110 \
  -p 995:995 \
  -p 143:143 \
  -p 993:993 \
  -p 4190:4190 \
  -v /root/mail:/var/vmail \
  -v /etc/letsencrypt/live/example.com/privkey.pem:/etc/ssl/private/dovecot.pem \
  -v /etc/letsencrypt/live/example.com/fullchain.pem:/etc/ssl/certs/dovecot.pem \
  -t dockerpost/dovecot
```

Dovecot needs to know the primary hostname it is providing mail at,
this is done with `--hostname` for the FQDN, and `-e mydomain` for
just the domain level.

The ports are all optional to expose, depending on what services you
want. Note that dovecot will require TLS on all ports. Imap is
provided on ports 143 and 993. Pop is provided on ports 110
and 995. Port 4190 is for
[ManageSieve](http://wiki2.dovecot.org/Pigeonhole/ManageSieve) to
allow users to configure server-side scripting.

You should override the default certificates with your own. The best
way is to use [LetsEncrypt](letsencrypt.org) to generate a certificate
for all domains you intend to host email for.

### Start amavis

Amavis provides spam filtering and antivirus checking.

```
docker run --rm --name=amavis \
      --net=mail_network \
      --hostname=mail.example.com \
      -t dockerpost/amavis
```

It requires nothing more than the `--hostname` to be specified.

### Start postfix

Postfix is the SMTP server, delivering outgoing mail and accepting
incoming mail (after verification).

```
docker run --rm --name=postfix \
  --net=mail_network \
  --hostname=mail.example.com \
  -e myhostname=mail.example.com \
  -e mydomain=example.com \
  -p 25:25 \
  -p 587:587 \
  -v /root/opendkim-keys:/etc/opendkim/keys \
  -v /etc/letsencrypt/live/example.com/privkey.pem:/etc/ssl/private/ssl-cert-snakeoil.key \
  -v /etc/letsencrypt/live/example.com/fullchain.pem:/etc/ssl/certs/ssl-cert-snakeoil.pem \
  -t dockerpost/postfix
```

The hostname must be specified with `--hostname` and also as `-e
myhostname`, and the domain as `-e mydomain`.

Port 25 must be exposed if you want to receive mail from the
internet. It only handles incoming email and will reject any emails
which are not addressed to a known user. Emails which are addressed to
a known user are then handed off to spam filtering. Port 587 handles
outgoing e-mail and requires a connection with TLS and a user/password
login. Since only authorized users can send e-mail to the internet,
these are not subjected to spam filtering but instead they are signed
with DKIM.

The first volume to specify is where to save the DKIM-keys. You should
change `/root/opendkim-keys` to a suitable location on your
machine. This allows the same key to be reused, which we want since
you should publish the public key in your DNS records. On startup the
container will print what the DNS record should contain.

The other volumes are to override the default certificate with your
own valid one to get proper TLS support without warnings.

### Add some users to the database

Some handy scripts are included to deal with the database. To add a domain,

    ./addmaildomain.sh example.com

Then a user account

    ./addmailuser.sh bob example.com yourverysecretpassword

If desired, a user can also be mapped to one or several aliases:

    ./addmailalias.sh smith example.com bob example.com

Note that the fields are specified as foreign keys and with suitable
unique constraints in the database. For that reason, you have to add
the domain before the user account. If you delete a domain, then all
connected user accounts and aliases are also deleted.

Passwords are stored hashed and salted with `SHA512-CRYPT`.

### Test it!

You should now have a functioning mail setup (assuming your firewall
accepts the right ports of course). You can test it quickly using telnet.

To see if postfix is functioning type the following in order

```
telnet localhost 25

helo mail.somwhere.com

mail from:<john@internet.org>

rcpt to:<bob@example.com>

data

subject: hi this is a test

Just testing

.
```

Note the final `.` to mark the end of the message. Now check the
output from postfix. The first time, postfix should reject the message
(part of spam filtering). Do it a second time and it should accept it
and deliver it to amavis and then dovecot.
