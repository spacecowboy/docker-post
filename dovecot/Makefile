build:
	sudo docker build --tag=docker-post/dovecot .

run:
	sudo docker run --rm --name=dovecot --net=mail_network -it docker-post/dovecot

shell:
	sudo docker exec -it dovecot /bin/bash
