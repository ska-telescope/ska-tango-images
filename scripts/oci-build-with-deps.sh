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

set -ex

BASE_IMAGE=$(extract-image-arg BASE_IMAGE)
BUILD_IMAGE=$(extract-image-arg BUILD_IMAGE)

ADDITIONAL_ARGS="--no-cache"


if [ -n "${CI_COMMIT_SHORT_SHA}" ] && [ -n "${BUILD_IMAGE}" ]; then
    VERS=$(get-version ${BUILD_IMAGE})
    ADDITIONAL_ARGS+=" --build-arg BUILD_IMAGE=\${CAR_OCI_REGISTRY_HOST}/${BUILD_IMAGE}:${VERS}-dev.c${CI_COMMIT_SHORT_SHA}"
fi

if [ -n "${CI_COMMIT_SHORT_SHA}" ] && [ -n "${BASE_IMAGE}" ]; then
    VERS=$(get-version ${BASE_IMAGE})
    ADDITIONAL_ARGS+=" --build-arg BASE_IMAGE=\${CAR_OCI_REGISTRY_HOST}/${BASE_IMAGE}:${VERS}-dev.c${CI_COMMIT_SHORT_SHA}"
fi

set -x

${MAKE} oci-build OCI_IMAGE=${OCI_IMAGE} CAR_OCI_REGISTRY_HOST=${OCI_REGISTRY} RELEASE_CONTEXT_DIR=images/${OCI_IMAGE} \
    OCI_BUILD_ADDITIONAL_ARGS="$ADDITIONAL_ARGS"
