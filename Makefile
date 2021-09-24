BASE = $(shell pwd)

HELM_CHARTS_TO_PUBLISH ?= ska-tango-util ska-tango-base
OCI_IMAGES ?= ska-tango-images-tango-dependencies ska-tango-images-tango-dependencies-alpine ska-tango-images-tango-db ska-tango-images-tango-cpp ska-tango-images-tango-cpp-alpine ska-tango-images-tango-java ska-tango-images-tango-rest ska-tango-images-pytango-builder ska-tango-images-pytango-builder-alpine ska-tango-images-tango-pogo ska-tango-images-tango-libtango ska-tango-images-tango-jive ska-tango-images-pytango-runtime ska-tango-images-pytango-runtime-alpine ska-tango-images-tango-admin ska-tango-images-tango-databaseds ska-tango-images-tango-test ska-tango-images-tango-dsconfig ska-tango-images-tango-itango ska-tango-images-tango-vnc ska-tango-images-tango-pytango ska-tango-images-tango-panic ska-tango-images-tango-panic-gui

# include OCI Images support
include .make/oci.mk

# include Helm Chart support
include .make/helm.mk

# include make support
include .make/make.mk

# include help support
include .make/help.mk

# include core release support
include .make/release.mk

# include your own private variables for custom deployment configuration
-include PrivateRules.mak
