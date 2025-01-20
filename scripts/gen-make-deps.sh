#!/usr/bin/env bash

# Generate a dependency file for a given OCI image.
#
# Usage:
#
# gen-make-deps.sh <OCI_IMAGE> <DEPS_FILE> <RECEIPTS_DIR>
#
# This script inspects the docker file to work out which ska-tango-images images
# the provided OCI_IMAGE depends on. It then outputs Makefile dependency rules
# so that the appropriate receipts depend on each other.

if [ $# -ne 3 ]; then
    echo "Usage:"
    echo -e "\t$0 <OCI_IMAGE> <DEPS_FILE> <RECEIPTS_DIR>"
    exit 1
fi

OCI_IMAGE=$1
DEPS_FILE=$2
RECEIPTS_DIR=$3

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/lib.sh

set -e

BASE_IMAGE=$(extract-image-arg BASE_IMAGE)
BUILD_IMAGE=$(extract-image-arg BUILD_IMAGE)

OCI_IMAGE_SLUG=${OCI_IMAGE/ska-tango-images-}
BASE_IMAGE_SLUG=${BASE_IMAGE/ska-tango-images-}
BUILD_IMAGE_SLUG=${BUILD_IMAGE/ska-tango-images-}

# Set the OCI_IMAGE variable, which is used by the receipt rule
echo > $DEPS_FILE "${RECEIPTS_DIR}/${OCI_IMAGE_SLUG}: OCI_IMAGE=${OCI_IMAGE}"

# The image depends on everything in the image directory
echo >> $DEPS_FILE "${RECEIPTS_DIR}/${OCI_IMAGE_SLUG}: images/${OCI_IMAGE}/*"

if [ -n "${BUILD_IMAGE}" ]; then
    echo >> $DEPS_FILE "${RECEIPTS_DIR}/${OCI_IMAGE_SLUG}: ${RECEIPTS_DIR}/${BUILD_IMAGE_SLUG}"
fi

if [ -n "${BASE_IMAGE}" ]; then
    echo >> $DEPS_FILE "${RECEIPTS_DIR}/${OCI_IMAGE_SLUG}: ${RECEIPTS_DIR}/${BASE_IMAGE_SLUG}"
fi

# Make sure this file is updated if the Dockerfile is changed
echo >> $DEPS_FILE "$DEPS_FILE: images/${OCI_IMAGE}/Dockerfile"
