.PHONY: build build-alpine clean test help default

BIN_NAME=prom2click

VERSION := $(shell grep "const Version " version.go | sed -E 's/.*"(.+)"$$/\1/')
BUILD_TIME := $(shell date +%Y%m%d%H%M%S)
GIT_COMMIT=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)

BUILD_VERSION := $(BUILD_TIME).$(GIT_COMMIT)
IMAGE_NAME = woshiaotian/prom2click:$(VERSION).$(BUILD_VERSION)

default: test

help:
	@echo 'Management commands for prom2click:'
	@echo
	@echo 'Usage:'
	@echo '    make build           Compile the project.'
	@echo '    make get-deps        runs glide install, mostly used for ci.'
	
	@echo '    make clean           Clean the directory tree.'
	@echo

build:
	@echo "building ${BIN_NAME} ${VERSION}"
	@echo "GOPATH=${GOPATH}"
	go build -ldflags "-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X main.VersionPrerelease=DEV" -o bin/${BIN_NAME}

build-linux:
	@echo "building ${BIN_NAME} ${VERSION}"
	@echo "GOPATH=${GOPATH}"
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X main.VersionPrerelease=DEV" -o bin/${BIN_NAME}

image: build-linux
	docker build -f ./Dockerfile --rm -t ${IMAGE_NAME} .

get-deps:
	glide install

clean:
	@test ! -e bin/${BIN_NAME} || rm bin/${BIN_NAME}

test:
	go test $(glide nv)

