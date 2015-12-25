build:
	sudo docker build --tag=docker-post/amavis .

run:
	sudo docker run --rm --name=amavis --hostname="mail.example.com" \
	  --net=mail_network \
	  -e myhostname="mail.example.com" -e mydomain="example.com" \
	  -it docker-post/amavis

shell:
	sudo docker exec -it amavis /bin/bash
