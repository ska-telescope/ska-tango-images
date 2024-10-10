#
# This Dockerfile builds Tango including Java apps and libraries in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="artefact.skao.int/ska-build:0.1.1"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-test:local"

FROM $BUILD_IMAGE as build
ARG DEBIAN_FRONTEND=noninteractive
ARG TANGO_SOURCE_DISTRIBUTION_VERION=9.5.0
ARG LOG4J_VERSION=1.2.17

ENV TSD_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-${TANGO_SOURCE_DISTRIBUTION_VERION}.tar.gz
ENV LOG4J_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/log4j-${LOG4J_VERSION}.tar.gz

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        git \
        default-jre \
        cmake \
        curl

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango

RUN set -xe; \
    curl -fsSL -k "$TSD_DOWNLOAD_URL" -o tango.tar.gz; \
    tar xf tango.tar.gz -C /usr/src/tango --strip-components=1; \
    cmake -Bbuild -Slib/java -DSHELL=/bin/bash -DTSD_RC_FILE=/etc/tangorc -DTSD_JAVA_EXEC=$(which java) -Wno-dev; \
    cmake --build build --target install;

RUN mkdir -p /usr/java
WORKDIR /usr/java

RUN set -xe; \
    wget --no-check-certificate "$LOG4J_DOWNLOAD_URL" -O log4j.tar.gz; \
    tar zxvf log4j.tar.gz; \
    mv apache-log4j-1.2.17/log4j-1.2.17.jar /usr/local/share/java/log4j-1.2.17.jar;

FROM $BASE_IMAGE

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-java/Dockerfile" \
      description="Contains the JTango based applications" \
      license="BSD-3-Clause"

USER root

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        default-jre; \
    rm -rf /var/lib/apt/lists/*

USER tango

COPY --from=build /usr/local /usr/local

ENTRYPOINT []
