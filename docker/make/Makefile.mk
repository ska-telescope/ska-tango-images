#
#   Copyright 2015  Xebia Nederland B.V.
#   Modifications copyright (c) 2019 SKA Organisation
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
NAME=$(shell basename $(CURDIR))

RELEASE_SUPPORT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/.make-release-support

IMAGE_BUILDER ?= docker
CAR_OCI_REGISTRY_HOST ?= artefact.skatelescope.org
CAR_OCI_REGISTRY_PREFIX ?= ska-tango-images

IMAGE=$(CAR_OCI_REGISTRY_HOST)/$(CAR_OCI_REGISTRY_PREFIX)/$(NAME)

VERSION=$(shell . $(RELEASE_SUPPORT) ; getVersion)
TAG=$(shell . $(RELEASE_SUPPORT); getTag)

SHELL=/bin/bash

BUILD_CONTEXT=.
FILE_PATH=Dockerfile

.PHONY: pre-build docker-build post-build build release patch-release minor-release major-release tag check-status check-release showver \
	push pre-push do-push post-push

build: pre-build docker-build post-build

pre-build:

post-build:

pre-push:

post-push:

docker-build: .release
	$(IMAGE_BUILDER) build $(BUILD_ARGS) -t $(IMAGE):$(VERSION) $(BUILD_CONTEXT) -f $(FILE_PATH) --build-arg CAR_OCI_REGISTRY_HOST=$(CAR_OCI_REGISTRY_HOST) --build-arg CAR_OCI_REGISTRY_PREFIX=$(CAR_OCI_REGISTRY_PREFIX)
	@DOCKER_MAJOR=$(shell $(IMAGE_BUILDER) -v | sed -e 's/.*version //' -e 's/,.*//' | cut -d\. -f1) ; \
	DOCKER_MINOR=$(shell $(IMAGE_BUILDER) -v | sed -e 's/.*version //' -e 's/,.*//' | cut -d\. -f2) ; \
	if [ $$DOCKER_MAJOR -eq 1 ] && [ $$DOCKER_MINOR -lt 10 ] ; then \
		echo $(IMAGE_BUILDER) tag -f $(IMAGE):$(VERSION) $(IMAGE):latest ;\
		$(IMAGE_BUILDER) tag -f $(IMAGE):$(VERSION) $(IMAGE):latest ;\
	else \
		echo $(IMAGE_BUILDER) tag $(IMAGE):$(VERSION) $(IMAGE):latest ;\
		$(IMAGE_BUILDER) tag $(IMAGE):$(VERSION) $(IMAGE):latest ; \
	fi

.release:
	@echo "release=0.0.0" > .release
	@echo "tag=$(NAME)-0.0.0" >> .release
	@echo INFO: .release created
	@cat .release

release: check-status check-release build push

push: pre-push do-push post-push

do-push:
	@curl --output /dev/null --silent --head --fail -r 0-0 "https://$(CAR_OCI_REGISTRY_HOST)/repository/docker/v2/$(CAR_OCI_REGISTRY_PREFIX)/$(NAME)/manifests/$(VERSION)"; \
	result=$$?; \
	if [ $$result -eq 0 ] ; then \
		echo "Version $(VERSION) of image $(IMAGE) already exists"; \
	else \
		echo "Version $(VERSION) of image $(IMAGE) does not exist"; \
		$(IMAGE_BUILDER) push $(IMAGE):$(VERSION); \
	fi;

snapshot: build push

showver: .release
	@. $(RELEASE_SUPPORT); getVersion

tag-patch-release: VERSION := $(shell . $(RELEASE_SUPPORT); nextPatchLevel)
tag-patch-release: .release tag

tag-minor-release: VERSION := $(shell . $(RELEASE_SUPPORT); nextMinorLevel)
tag-minor-release: .release tag

tag-major-release: VERSION := $(shell . $(RELEASE_SUPPORT); nextMajorLevel)
tag-major-release: .release tag

patch-release: tag-patch-release release
	@echo $(VERSION)

minor-release: tag-minor-release release
	@echo $(VERSION)

major-release: tag-major-release release
	@echo $(VERSION)

tag: TAG=$(shell . $(RELEASE_SUPPORT); getTag $(VERSION))
tag: check-status
#	@. $(RELEASE_SUPPORT) ; ! tagExists $(TAG) || (echo "ERROR: tag $(TAG) for version $(VERSION) already tagged in git" >&2 && exit 1) ;
	@. $(RELEASE_SUPPORT) ; setRelease $(VERSION)
#	git add .
#	git commit -m "bumped to version $(VERSION)" ;
#	git tag $(TAG) ;
#	@ if [ -n "$(shell git remote -v)" ] ; then git push --tags ; else echo 'no remote to push tags to' ; fi

check-status:
	@. $(RELEASE_SUPPORT) ; ! hasChanges || (echo "ERROR: there are still outstanding changes" >&2 && exit 1) ;

check-release: .release
	@. $(RELEASE_SUPPORT) ; tagExists $(TAG) || (echo "ERROR: version not yet tagged in git. make [minor,major,patch]-release." >&2 && exit 1) ;
	@. $(RELEASE_SUPPORT) ; ! differsFromRelease $(TAG) || (echo "ERROR: current directory differs from tagged $(TAG). make [minor,major,patch]-release." ; exit 1)
