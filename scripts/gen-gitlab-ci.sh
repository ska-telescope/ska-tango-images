#!/usr/bin/env bash

# Generate .gitlab-ci.yml.
#
# Usage:
#
#   gen-gitlab-ci.sh
#
# This script uses gitlab-ci.yml.head as the starting point and appends jobs for
# each OCI image defined in the images/ directory.  For each image we need to
# generate a scan and build job, which extends the .container-scanning and
# .image_builder_template templates respectively.  These templates are defined
# in the gitlab-ci.yml.head directory.
#
# This script also captures any build time dependencies between the OCI images
# using the `needs` field.  For example, if we had a OCI image called
# ska-tango-images-qux, with the following Dockerfile:
#
#   ARG CAR_OCI_REGISTRY_HOST
#   ARG BASE_IMAGE=${CAR_OCI_REGISTRY_HOST}/ska-tango-images-foo:local
#   ARG BUILD_IMAGE=${CAR_OCI_REGISTRY_HOST}/ska-tango-images-bar:local
#
# Then we would expect the following CI jobs to be generated:
#
#   scan_qux:
#     extends: .container-scanning
#     variables:
#       OCI_IMAGE: ska-tango-images-qux
#
#   build_qux:
#     extends: .image_builder_template
#     variables:
#       OCI_IMAGE: ska-tango-images-qux
#     needs:
#       - build_foo
#       - build_bar
#
# Note:
#   Dependency relationships between the OCI images is _only_ determined by
#   BASE_IMAGE and BUILD_IMAGE docker build-args.
#

if [ $# -ne 0 ]; then
    echo "Usage:"
    echo -e "\t$0"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/lib.sh

set -ex

TARGET=$SCRIPT_DIR/../.gitlab-ci.yml

cp $SCRIPT_DIR/gitlab-ci.yml.head ${TARGET}

for IMG in images/*; do
    OCI_IMAGE=${IMG#*/}
    BASE_IMAGE=$(extract-image-arg BASE_IMAGE)
    BUILD_IMAGE=$(extract-image-arg BUILD_IMAGE)

    OCI_IMAGE_SLUG=${OCI_IMAGE/ska-tango-images-}
    BASE_IMAGE_SLUG=${BASE_IMAGE/ska-tango-images-}
    BUILD_IMAGE_SLUG=${BUILD_IMAGE/ska-tango-images-}

    cat << EOF >> $TARGET

scan_${OCI_IMAGE_SLUG}:
  extends: .container-scanning
  variables:
    OCI_IMAGE: ${OCI_IMAGE}

build_${OCI_IMAGE_SLUG}:
  extends: .image_builder_template
  variables:
    OCI_IMAGE: ${OCI_IMAGE}
EOF

    if [ -n "${BASE_IMAGE}" ] || [ -n "${BUILD_IMAGE}" ]; then
        cat << EOF >> $TARGET
  needs:
EOF
    fi

    if [ -n "${BASE_IMAGE}" ]; then
        cat << EOF >> $TARGET
    - build_${BASE_IMAGE_SLUG}
EOF
    fi
    if [ -n "${BUILD_IMAGE}" ]; then
        cat << EOF >> $TARGET
    - build_${BUILD_IMAGE_SLUG}
EOF
    fi
done

