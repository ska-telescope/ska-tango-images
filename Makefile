BASE = $(shell pwd)

RELEASE_SUPPORT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/.make-release-support

# include OCI Images support
include .make/oci.mk

# include raw support
include .make/raw.mk

# include core make support
include .make/base.mk

# include your own private variables for custom deployment configuration
-include PrivateRules.mak

oci-bump-patch-release: ## Bump patch release for all OCI Image .release files in ./images/<dir>
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make bump-patch-release RELEASE_CONTEXT_DIR=images/$(ociimage);)

oci-bump-minor-release: ## Bump minor release for all OCI Image .release files in ./images/<dir>
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make bump-minor-release RELEASE_CONTEXT_DIR=images/$(ociimage);)

oci-bump-major-release: ## Bump major release for all OCI Image .release files in ./images/<dir>
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make bump-major-release RELEASE_CONTEXT_DIR=images/$(ociimage);)

custom-oci-publish-all: ## Custom Publish all OCI Images in OCI_IMAGES_TO_PUBLISH using image local .release
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make oci-publish OCI_IMAGE=$(ociimage) RELEASE_CONTEXT_DIR=images/$(ociimage);)

.PHONY: oci-build-with-deps
oci-build-with-deps:
	scripts/oci-build-with-deps.sh $(OCI_IMAGE)


.PHONY: oci-tests
oci-tests:
	env SKA_TANGO_IMAGES_DIR=$(BASE)/images pytest tests
