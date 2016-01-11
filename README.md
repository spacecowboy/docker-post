# docker-post

A collection of docker containers for setting up a complete
self-hosted e-mail system. Default configuration provides:

* SMTP server (Postfix)
* IMAP/POP server (Dovecot)
* Virtual domains/users/aliases (Postgres)
* DKIM signing of outgoing mail (OpenDkim)
* DKIM signature verification of incoming mail (Amavis)
* Spam filtering (Postscreen, Amavis with Pyzor/Razor/SpamAssassin)
* Antivirus (Amavis with ClamAV)
* Server side filter/script support with Sieve and ManageSieve
* Entirely [LetsEncrypt](letsencrypt.org) compatible
* Passwords stored hashed and salted (Postgres)

## Before your first run: configure the database

The best way is to run the system once the database is configured is
with the
[provided SystemD units](https://github.com/spacecowboy/docker-post/tree/master/systemd)
in order to get the correct startup and so on even across
reboots. During development, it is useful to run the containers
directly however. See the individual containers for more information
on that.

### Start the database

First edit
[systemd/dockerpost-postgres.service](https://github.com/spacecowboy/docker-post/tree/master/systemd/dockerpost-postgres.service)
and set a location for the volume (`-v` line) of your choice.

Then enable and start the postgres service:

```
cp systemd/dockerpost-postgres.service /etc/systemd/system/
systemctl enable dockerpost-postgres.service
systemctl start dockerpost-postgres.service
```

This will create the required docker-network, pull the latest version of the postgres docker container, and start This just starts a copy of the official Postgres container.

### Configure the database

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

### Add some data to your database

Use the included scripts to easily add your users and aliases into the
database. Note that since foreign keys are used in the DB, order
matters.

#### Domains

[addmaildomain.sh](https://github.com/spacecowboy/docker-post/blob/master/addmaildomain.sh)

```
./addmaildomain.sh example1.com
./addmaildomain.sh example2.org
```

#### Users

[addmailuser.sh](https://github.com/spacecowboy/docker-post/blob/master/addmailuser.sh)

```
./addmailuser.sh bob example1.com secretpassword
./addmailuser.sh alice example2.org moresecretpw
```

Passwords are stored hashed and salted with `SHA512-CRYPT`.

#### Aliases

Aliases are strictly optional. Note that it is possible to login with
either the user-address or any alias-address.

[addmailalias.sh](https://github.com/spacecowboy/docker-post/blob/master/addmailalias.sh)

```
./addmailalias.sh batman example1.com alice example2.org
./addmailalias.sh superman example1.com bob example1.com
```

## Start the rest of the containers

With atleast one user added to the database, you are now ready to
start the rest of the containers.

### Start dovecot

Edit
[systemd/dockerpost-dovecot.service](https://github.com/spacecowboy/docker-post/tree/master/systemd/dockerpost-dovecot.service)
and set the primary `--hostname` for your server, as well as its
domain as `-e mydomain`.

Pick a suitable location to store the mails instead of `/root/mail`
and finally, set the correct path to your certificates. The best way
is to use [LetsEncrypt](letsencrypt.org) to generate a certificate for
all domains you intend to host email for. If you really don't want
to however (for testing for example), you can just omit those volumes
and use dovecot's self-signed one.

Then enable and start it:

```
cp systemd/dockerpost-dovecot.service /etc/systemd/system/
systemctl enable dockerpost-dovecot.service
systemctl start dockerpost-dovecot.service
```

### Start amavis

Amavis provides spam filtering and antivirus checking. Edit
[systemd/dockerpost-amavis.service](https://github.com/spacecowboy/docker-post/tree/master/systemd/dockerpost-amavis.service)
and set the primary `--hostname` for your server.

Amavis needs access to the mail directory (replace `/root/mail`) so
that SpamAssassin can train on Spam and Ham. To remember what has been
learned from the training a directory for the spam database is also
specified (replace `/root/sa_db`).

Enable and start it:

```
cp systemd/dockerpost-amavis.service /etc/systemd/system/
systemctl enable dockerpost-amavis.service
systemctl start dockerpost-amavis.service
```

To setup a daily task to learn what is spam and what is ham, also
enable the timer job:

```
cp systemd/dockerpost-learnspam.service /etc/systemd/system/
cp systemd/dockerpost-learnspam.timer /etc/systemd/system/
systemctl enable dockerpost-learnspam.timer
systemctl start dockerpost-learnspam.timer
```

### Start postfix

Postfix is the SMTP server, delivering outgoing mail and accepting
incoming mail (after verification).

Edit
[systemd/dockerpost-postfix.service](https://github.com/spacecowboy/docker-post/tree/master/systemd/dockerpost-postfix.service)
and set your primary hostname in `--hostname` and `-e myhostname` as well as just the domain in `-e mydomain`.

Then specify a location to store your dkim keys instead of `/root/opendkim-keys`. Note that the container will print what you should put in your DNS records on startup. You can view it with:

    journalctl -a -u dockerpost-postfix.service

Set the same certificate path as you did for dovecot (or omit them
during testing). Then enable and start it:

```
cp systemd/dockerpost-postfix.service /etc/systemd/system/
systemctl enable dockerpost-postfix.service
systemctl start dockerpost-postfix.service
```

### Test it!

You should now have a functioning mail setup (assuming your firewall
accepts the right ports of course). You can test it quickly using telnet.

To see if postfix is functioning type something like the following in order

```
telnet localhost 25

helo mail.somwhere.com

mail from:<john@internet.org>

rcpt to:<bob@example.com>

data

subject: hi this is a test

Just testing

.

quit
```

Note the final `.` to mark the end of the message. Now check the
output from postfix. The first time, postfix should reject the message
(part of spam filtering process). Do it a second time and it should
accept it and deliver it to amavis and then dovecot.
