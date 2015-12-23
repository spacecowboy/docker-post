build:
	sudo docker build --tag=docker-post/dovecot .

# pop3 - 110
# pop3s - 995
# imap - 143
# imaps - 993
run:
	sudo docker run --rm --name=dovecot --hostname=mail.example.com \
	  -p 143:143 -p 110:110 \
	  -e mydomain=example.com --net=mail_network -it docker-post/dovecot

shell:
	sudo docker exec -it dovecot /bin/bash
