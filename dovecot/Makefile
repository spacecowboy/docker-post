build:
	sudo docker build --tag=docker-post/dovecot .

run:
	sudo docker run --rm --name=dovecot --hostname=mail.example.com \
	  -e mydomain=example.com --net=mail_network -it docker-post/dovecot

shell:
	sudo docker exec -it dovecot /bin/bash
