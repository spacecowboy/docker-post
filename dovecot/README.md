# dockerpost/dovecot

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
for all domains you intend to host email for. If you really don't want
to however (for testing for example), you can just omit those volumes
and use dovecot's self-signed one.
