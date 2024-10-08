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

ALL_IMAGES=$(patsubst ska-tango-images-%, %, $(OCI_IMAGES))
ALL_BUILD_JOBS=$(addprefix oci-build-,$(ALL_IMAGES))

# Build all the images in order
.PHONY: all
all: $(ALL_BUILD_JOBS)

# Clean all the receipts for the images
.PHONY: clean
clean:
	@rm -rf build

build/receipts/%: scripts/oci-build-with-deps.sh
	scripts/oci-build-with-deps.sh $(OCI_IMAGE)
	@mkdir -p build/receipts
	@touch $@

build/deps/%: OCI_IMAGE=ska-tango-images-$*
build/deps/%: scripts/gen-make-deps.sh
	@mkdir -p build/deps
	@scripts/gen-make-deps.sh $(OCI_IMAGE) $@ build/receipts

include $(addprefix build/deps/, $(ALL_IMAGES))

# We manually define these so we have nice tab completion

define oci-build-image
.PHONY: oci-build-$1
oci-build-$1: build/receipts/$1
endef

$(foreach img,$(ALL_IMAGES),$(eval $(call oci-build-image,$(img))))

.PHONY: oci-build-with-deps
oci-build-with-deps:
	scripts/oci-build-with-deps.sh $(OCI_IMAGE)


.PHONY: oci-tests
oci-tests:
	env SKA_TANGO_IMAGES_DIR=$(BASE)/images pytest tests
