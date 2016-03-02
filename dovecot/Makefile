.DEFAULT_GOAL := help

.PHONY: help build run push runshell shell

help: ## Print a description of all available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the container image (dockerpost/dovecot)
	sudo docker build --tag=dockerpost/dovecot .

# pop3 - 110
# pop3s - 995
# imap - 143
# imaps - 993
run: ## Run a container with the minimal configuration
	sudo docker run --rm --name=dovecot --hostname=mail.example.com \
	  -p 143:143 -p 110:110 \
	  -e mydomain=example.com --net=mail_network -it dockerpost/dovecot

push: ## Push a new version of the image to DockerHub
	sudo docker push dockerpost/dovecot

runshell: ## Start a container and open bash in it
	sudo docker run --rm --name=dovecot --hostname=mail.example.com \
	  -p 143:143 -p 110:110 \
	  -e mydomain=example.com --net=mail_network -it dockerpost/dovecot /bin/bash

shell: ## Open a bash session inside the 'dovecot' container
	sudo docker exec -it dovecot /bin/bash
