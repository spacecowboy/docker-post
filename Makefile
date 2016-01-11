network:
	sudo docker network create mail_network

initdb:
	cd postgres; make initdb
