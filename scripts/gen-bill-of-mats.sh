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

source $SCRIPT_DIR/lib.sh
source $SCRIPT_DIR/upstream-versions

ZEROMQ_NAME=ZeroMQ
CPPZMQ_NAME=cppZMQ
OMNIORB_NAME=omniORB
TANGOIDL_NAME=tango_idl
CPPTANGO_NAME=cppTango
TANGOADMIN_NAME=tango_admin
DATABASEDS_NAME=TangoDatabase
DATABASEDS_TANGODB_NAME="SQL DB from TangoDatabase"
TANGOTEST_NAME=TangoTest
DSCONFIG_NAME=dsconfig
ITANGO_NAME=itango
BOOGIE_NAME="Boogie commit"
LOG4J_NAME=log4j
TANGO_SOURCE_DISTRIBUTION_NAME="Java applications from TangoSourceDistribution"
SKABASE_NAME=ska-base
SKABUILD_NAME=ska-build
SKAPYTHON_NAME=ska-python
SKABUILDPYTHON_NAME=ska-build-python
MARIADB_NAME="MariaDB docker image"

# Recursively prints the upstream versions for the image and its base/build images
function print-upstream-versions {
    if [ -z "$1" ]; then
        return
    fi

    local this=$(basename $1)

    OCI_IMAGE=${this}
    print-upstream-versions $(extract-image-arg BUILD_IMAGE)
    OCI_IMAGE=${this}
    print-upstream-versions $(extract-image-arg BASE_IMAGE)

    local versions=$(awk < images/${this}/Dockerfile '/^ARG.*VERSION$/ { print $2 }')

    for ver_name in ${versions}; do
        if [ ${ver_name} = "TANGO_SOURCE_DISTRIBUTION_VERSION" ] && \
           [ ${CURRENT_IMAGE} != "images/ska-tango-images-tango-java" ]; then
            continue
        fi
        local -n ver=${ver_name}
        local -n upstream=${ver_name%_VERSION}_NAME
        if [ ${ver_name} = "DATABASEDS_VERSION" ] || [ ${ver_name} = "DATABASEDS_TANGODB_VERSION" ] || [ ${ver_name} = "TANGOADMIN_VERSION" ]; then
            ver=${ver##*[-_]}
        fi
        echo "  + ${upstream} ${ver}"
    done

    # Special handling for the java applications which all come from TSD
    if [ ${CURRENT_IMAGE} = "images/ska-tango-images-tango-jive" ]; then
        echo "  + JTango ${TSD_JTANGO_VERSION}"
        echo "  + Jive ${TSD_JIVE_VERSION}"
        echo "  + ATK ${TSD_ATK_VERSION}"
        echo "  + ATK Panel ${TSD_ATK_PANEL_VERSION}"
        echo "  + ATK Tuning ${TSD_ATK_TUNING_VERSION}"
    fi

    if [ ${CURRENT_IMAGE} = "images/ska-tango-images-tango-pogo" ]; then
        echo "  + JTango ${TSD_JTANGO_VERSION}"
        echo "  + Pogo ${TSD_POGO_VERSION}"
    fi

    if [ ${CURRENT_IMAGE} = "images/ska-tango-images-tango-rest" ]; then
        echo "  + JTango ${TSD_JTANGO_VERSION}"
        echo "  + TangoRestServer ${TSD_REST_VERSION}"
    fi
}

set -e

for CURRENT_IMAGE in images/*; do
    ver=$(make RELEASE_CONTEXT_DIR=${CURRENT_IMAGE} show-version 2>/dev/null)
    echo "- $(basename ${CURRENT_IMAGE}):${ver%-dirty}"
    print-upstream-versions ${CURRENT_IMAGE} | sort | uniq
done
