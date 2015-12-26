build:
	sudo docker build --tag=dockerpost/postfix .

run:
	sudo docker run --rm --name=postfix --hostname="mail.example.com" \
	  --net=mail_network -p 1025:25 -p 587:587 \
	  -e myhostname="mail.example.com" -e mydomain="example.com" \
	  -it dockerpost/postfix

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
