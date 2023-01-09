SHELL := /bin/bash
BASE_IMAGE = quay.io/evryfs/base-python
BUILD_URL ?= $(shell pwd)
BUILD_DATE ?= $(shell date --rfc-3339=ns)
GIT_URL := $(shell git config --get remote.origin.url)
GIT_COMMIT := $(shell git rev-parse HEAD)
PY_VER := $(shell head -n1 Dockerfile|cut -d":" -f2|cut -d"-" -f1)
PY_MINOR_VER := $(shell head -n1 Dockerfile|cut -d":" -f2|cut -d"-" -f1|cut -d"." -f1,2)
UVICORN_VERSION ?= $(shell grep uvicorn requirements.txt|cut -d"=" -f3)
GUNICORN_VERSION ?= $(shell grep gunicorn requirements.txt|cut -d"=" -f3)
VERSION = "$(PY_VER)-$(UVICORN_VERSION)-$(GUNICORN_VERSION)"

all: latest push

latest:
	@echo "Building base-python-asgi with uvicorn $(UVICORN_VERSION)"
	docker build . \
		--pull \
		-t evryfs/base-python-asgi:"$(VERSION)" \
		-t evryfs/base-python-asgi:"$(PY_VER)"-stable \
		-t quay.io/evryfs/base-python-asgi:"$(VERSION)" \
		-t quay.io/evryfs/base-python-asgi:"$(PY_VER)"-stable \
		-t quay.io/evryfs/base-python-asgi:"$(PY_MINOR_VER)"-stable \
		-t quay.io/evryfs/base-python-asgi:stable \
		--build-arg UVICORN_VERSION="$(UVICORN_VERSION)" \
		--build-arg GUNICORN_VERSION="$(GUNICORN_VERSION)" \
		--build-arg VERSION="$(VERSION)" \
		--build-arg BUILD_DATE="$(BUILD_DATE)" \
		--build-arg BUILD_URL="$(BUILD_URL)" \
		--build-arg GIT_URL="$(GIT_URL)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		-f Dockerfile

push:
	docker push quay.io/evryfs/base-python-asgi:"$(PY_VER)"-stable
	docker push quay.io/evryfs/base-python-asgi:"$(PY_MINOR_VER)"-stable
	docker push quay.io/evryfs/base-python-asgi:"$(VERSION)"
	docker push quay.io/evryfs/base-python-asgi:stable

