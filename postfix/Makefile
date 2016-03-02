.DEFAULT_GOAL := help

.PHONY: help build run push shell test-domain test-alias test-mailbox

help: ## Print a description of all available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:  ## Build the container image (dockerpost/postfix)
	sudo docker build --tag=dockerpost/postfix .

run: ## Run a container with the minimal configuration
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

push: ## Push a new version of the image to DockerHub
	sudo docker push dockerpost/postfix

shell: ## Open a bash session inside the 'postfix' container
	sudo docker exec -it postfix /bin/bash

test-domain:
	sudo docker exec -it postfix postmap -q example.com pgsql:/etc/postfix/pgsql-domains.cf

test-alias:
	sudo docker exec -it postfix postmap -q bob@example.com pgsql:/etc/postfix/pgsql-aliases.cf

test-mailbox:
	sudo docker exec -it postfix postmap -q bob@example.com pgsql:/etc/postfix/pgsql-mailboxes.cf
