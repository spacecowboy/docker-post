build:
	sudo docker build --tag=dockerpost/amavis .

run:
	sudo docker run --rm --name=amavis --hostname="mail.example.com" \
	  --net=mail_network \
	  -it dockerpost/amavis

shell:
	sudo docker exec -it amavis /bin/bash
