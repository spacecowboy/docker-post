# dockerpost/postfix

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
container will *print what the DNS record should contain*.

The other volumes are to override the default certificate with your
own valid one to get proper TLS support without warnings. If you
really don't want to have proper certificate (for testing for
example), you can just omit those volumes and use the default
self-signed one.
