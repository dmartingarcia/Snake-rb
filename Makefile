ndef = $(if $(value $(1)),,$(error $(1) not set))

.PHONY: build

default: help

build: ## Generate entire development environment
build: clean
	docker-compose build --no-cache --force-rm

clean: ## Clean project containers and volumes
	docker-compose down
	docker volume ls | grep "snake-rb" | awk '{ print $$2 }' | xargs docker volume rm || true

run: ## Run application
	echo "In order to run this application we need to enable the public access to the X11 server"
	sudo xhost +
	docker-compose up

help:
	@printf "\033[1mUsage:\033[0m\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image: ## Build docker image
build-image:
	docker build --force-rm --no-cache -t dmartingarcia/snake-rb .

run-image: ## Start server from image
run-image: build-image
	docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" --rm dmartingarcia/snake-rb
