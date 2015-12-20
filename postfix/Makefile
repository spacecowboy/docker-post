build:
	sudo docker build --tag=docker-post/postfix .

run:
	sudo docker run --rm --name=postfix --hostname="mail.example.com" \
	  --net=mail_network -p 1025:25 \
	  -e myhostname="mail.example.com" -e mydomain="example.com" \
	  -it docker-post/postfix

shell:
	sudo docker exec -it postfix /bin/bash
