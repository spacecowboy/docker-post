.DEFAULT_GOAL := help

.PHONY: help build run push shell

help: ## Print a description of all available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the container image (dockerpost/amavis)
	sudo docker build --tag=dockerpost/amavis .

run: ## Run a container with the minimal configuration
	sudo docker run --rm --name=amavis --hostname="mail.example.com" \
	  --net=mail_network \
	  -it dockerpost/amavis

push: ## Push a new version of the image to DockerHub
	sudo docker push dockerpost/amavis

shell: ## Open a bash session inside the 'amavis' container
	sudo docker exec -it amavis /bin/bash
