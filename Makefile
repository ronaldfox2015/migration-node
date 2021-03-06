.DEFAULT_GOAL := help

## GENERAL ##
OWNER 						= api
SERVICE_NAME 				= node-console
VERSION         			= v1
PROVIDER					= ronaldgcr
NETWORk						= api_console
DOCKER_NETWORK				?= --network $(NETWORk)
## DEV ##
TAG_DEV						= 1.0.0
TAG_MYSQL 					= mysql
MYSQL_USER					?= root
MYSQL_ROOT_PASSWORD			?= test
USER_ID  					?= $(shell id -u)
GROUP_ID 					?= $(shell id -g)

## DEPLOY ##
ENV 						?= dev
BUILD_NUMBER 				?= 000001
BUILD_TIMESTAMP 			?= 20181005
DEPLOY_REGION 				?= eu-west-1
ACCOUNT_ID					?= 929226109038
DESIRED_COUNT 				?= 1
MIN_SCALING					?= 1
MAX_SCALING					?= 2
MEMORY_SIZE 				?= 512
CONTAINER_PORT 				?= 80
INFRA_BUCKET 				?= infraestructura.dev

## RESULT_VARS ##
PROJECT_NAME			    = $(OWNER)-$(ENV)-$(SERVICE_NAME)
IMAGE_DEPLOY			    = $(PROVIDER)/$(PROJECT_NAME):$(TAG_DEV)

## VARIABLES FOR LOCAL BALANCER, 'SPRING CONFIG OR ENV VARS' ##
VIRTUAL_HOST				= $(PROJECT_NAME)/$(VERSION)

## DEFAULT ##
NETWORD					    = orbis-training-$(PROJECT_NAME)
PATH_CORE					?= $(PWD)/core


build: ## construccion de la imagen: make build
	docker build -f docker/node/Dockerfile -t $(IMAGE_DEPLOY) docker/node/;

build-image-migration:
	sudo chmod 777 -R app/*
	cp -R  $(PWD)/app/ $(PWD)/docker/node;
	make build;
	rm -R $(PWD)/docker/node/app/;
install: ## install de paquetes
	make tast EXECUTE="install";

tast: ## installar: make tast EXECUTE=install
	docker run -it -v "$(PWD)/app:/app" -w "/app" $(IMAGE_DEPLOY) yarn $(EXECUTE)

typeorm: ## installar: make typeorm EXECUTE=init
	docker run -it -v "$(PWD)/app:/app" -w "/app" $(IMAGE_DEPLOY) typeorm $(EXECUTE)	

kill:
	docker rm -f $(docker ps -a -q)
push: ## Subir imagen al dockerhub: make push
	@docker push $(IMAGE_DEPLOY)

ssh-image: ## inicialiar mysql y applicacion
	docker run -it -v "$(PWD)/app:/app" -w "/app" $(IMAGE_DEPLOY) bash

up: ## up docker containers: make up
	echo $(IMAGE_DEPLOY);
	docker-compose up

mysql: ## construir mysql
	docker run -p 3306:3306 --name $(TAG_MYSQL) $(DOCKER_NETWORK) -v $(PWD)/docker/mysql/sql:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) -e MYSQL_USER=$(MYSQL_USER) -e MYSQL_DATABASE=test -d mysql:5.5;

run: ## ejecuta el migration: make run
	docker run -it -p 80:3000 --name $(PROJECT_NAME) $(DOCKER_NETWORK) -v "$(PWD)/app:/app" -w "/app"  $(IMAGE_DEPLOY) yarn start

migration: ## inicialiar mysql y applicacion
	docker run -it --name $(PROJECT_NAME) $(DOCKER_NETWORK) $(IMAGE_DEPLOY) yarn start
down:## detiene el contenedor: make stop
	docker-compose down
attach: ## attach log to console: make attach
	docker attach --sig-proxy=false $(CONTAINER_NAME)
help: ## ayuda: make help
	@printf "\033[31m%-16s %-59s %s\033[0m\n" "Target" "Help" "Usage"; \
	printf "\033[31m%-16s %-59s %s\033[0m\n" "------" "----" "-----"; \
	grep -hE '^\S+:.*## .*$$' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' | sort | awk 'BEGIN {FS = ":"}; {printf "\033[32m%-16s\033[0m %-58s \033[34m%s\033[0m\n", $$1, $$2, $$3}'
