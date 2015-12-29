build:
	sudo docker build --tag=dockerpost/postfix .

run:
	sudo docker run --rm --name=postfix \
	  --hostname=mail.example.com \
	  --net=mail_network \
	  -e myhostname=mail.example.com \
	  -e mydomain=example.com \
	  -p 25:25 \
	  -p 587:587 \
	  -p 465:465 \
	  -v /home/jonas/services/volumes/opendkim-keys:/etc/opendkim/keys \
	  -v /etc/letsencrypt/live/example.com/privkey.pem:/etc/ssl/private/ssl-cert-snakeoil.key \
	  -v /etc/letsencrypt/live/example.com/fullchain.pem:/etc/ssl/certs/ssl-cert-snakeoil.pem \
	  -t dockerpost/postfix

push:
	sudo docker push dockerpost/postfix

shell:
	sudo docker exec -it postfix /bin/bash

test-domain:
	sudo docker exec -it postfix postmap -q example.com pgsql:/etc/postfix/pgsql-domains.cf

test-alias:
	sudo docker exec -it postfix postmap -q bob@example.com pgsql:/etc/postfix/pgsql-aliases.cf

test-mailbox:
	sudo docker exec -it postfix postmap -q bob@example.com pgsql:/etc/postfix/pgsql-mailboxes.cf
