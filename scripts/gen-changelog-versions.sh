#!/usr/bin/env bash

# Generate a list of the images and their tags for this release, for adding to
# the CHANGELOG.
#
# Usage:
#
# gen-make-deps.sh

if [ $# -ne 0 ]; then
    echo "Usage:"
    echo -e "\t$0"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -e

for img in images/*; do
    ver=$(make RELEASE_CONTEXT_DIR=${img} show-version 2>/dev/null)
    echo "- $(basename ${img}):${ver%-dirty}"
done
