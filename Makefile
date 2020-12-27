ndef = $(if $(value $(1)),,$(error $(1) not set))

.PHONY: build

default: help

help:
	@printf "\033[1mUsage:\033[0m\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build docker image
build:
	docker build --force-rm --no-cache -t dmartingarcia/snake-rb .

run: ## Start server
run:
	docker run --net=host --env="DISPLAY" --volume="/home/david/.Xauthority:/root/.Xauthority:rw" --rm dmartingarcia/snake-rb
