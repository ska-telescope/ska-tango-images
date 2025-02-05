#!/usr/bin/env bash

# Builds an OCI image managing the dependencies correctly.
#
# Usage:
#
#   oci-build-with-deps.sh <OCI_IMAGE>
#
# Example:
#
#   oci-build-with-deps.sh ska-tango-images-tango-cpp
#
# This script assumes every ska-tango-images-<x> dependency is 
# tagged as "local" by default as either a BASE_IMAGE or BUILD_IMAGE docker
# build-arg.  For example, here we are using tango-cpp and tango-admin as build
# and base images respectively:
#
#  ```
#  ARG CAR_OCI_REGISTRY_HOST
#  ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:local"
#  ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-admin:local"
#  FROM $BUILD_IMAGE AS build
#  ...
#  FROM $BASE_IMAGE
#  ...
#  ```
# If run inside a CI job ([ -n "$CI_COMMIT_SHORT_SHA" ]), then this script will replace
# the tags of any ska-tango-images with the tags used by the CI pipeline which
# include the CI_COMMIT_SHORT_SHA.  This image will exist provided the Gitlab CI
# has the correct job dependency graph.
#
# If run locally ([ -z "$CI_COMMIT_SHORT_SHA" ]), then this script will ensure that the
# image is tagged with "local".  This will be the correct image if images have
# been built in the correct order, this is handled by the Makefile.

MAKE=${MAKE:-make}
CI_REGISTRY=${CI_REGISTRY:-"registry.gitlab.com"}
CI_PROJECT_NAMESPACE=${CI_PROJECT_NAMESPACE:-"ska-telescope"}
CI_PROJECT_NAME=${CI_PROJECT_NAME:-"ska-tango-images"}
OCI_REGISTRY=${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}

if [ $# -ne 1 ]; then
    echo "Usage:"
    echo -e "\t$0 <OCI_IMAGE>"
    exit 1
fi

OCI_IMAGE=$1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/lib.sh

get-version()
{
    # The awk command skips lines outputted by make, so we just have the version
    # number
    ${MAKE} show-version RELEASE_CONTEXT_DIR=images/$1 2>/dev/null | awk -n '!/^make/{print}'
}

set -e

if [ -n "${CI_JOB_ID}" ]; then
    set -x
fi

BASE_IMAGE=$(extract-image-arg BASE_IMAGE)
BUILD_IMAGE=$(extract-image-arg BUILD_IMAGE)

ADDITIONAL_ARGS=""
if [ -n "${CI_JOB_ID}" ]; then
    ADDITIONAL_ARGS+="--no-cache"
fi

if [ -z "${CI_COMMIT_SHORT_SHA}" ]; then
    export OCI_BUILD_ADDITIONAL_TAGS=local
fi

if [ -n "${CI_COMMIT_SHORT_SHA}" ] && [ -n "${BUILD_IMAGE}" ]; then
    VERS=$(get-version ${BUILD_IMAGE})
    ADDITIONAL_ARGS+=" --build-arg BUILD_IMAGE=\${CAR_OCI_REGISTRY_HOST}/${BUILD_IMAGE}:${VERS}-dev.c${CI_COMMIT_SHORT_SHA}"
fi

if [ -n "${CI_COMMIT_SHORT_SHA}" ] && [ -n "${BASE_IMAGE}" ]; then
    VERS=$(get-version ${BASE_IMAGE})
    ADDITIONAL_ARGS+=" --build-arg BASE_IMAGE=\${CAR_OCI_REGISTRY_HOST}/${BASE_IMAGE}:${VERS}-dev.c${CI_COMMIT_SHORT_SHA}"
fi

while IFS='\n' read -r line; do
    # Skip comments
    if [[ "${line}" == \#* ]]; then
        continue
    fi
    ADDITIONAL_ARGS+=" --build-arg ${line}"
done < $SCRIPT_DIR/upstream-versions

set -x

# We need to provide a CAR_OCI_REGISTRY_HOST which begins with
# "registry.gitlab.com" so that oci-build uses OCI_BUILD_ADDITIONAL_TAGS
${MAKE} oci-build OCI_IMAGE=${OCI_IMAGE} CAR_OCI_REGISTRY_HOST=${OCI_REGISTRY} RELEASE_CONTEXT_DIR=images/${OCI_IMAGE} \
    OCI_BUILD_ADDITIONAL_ARGS="$ADDITIONAL_ARGS"
