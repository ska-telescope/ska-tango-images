ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-admin:local"
ARG BASE_IMAGE="artefact.skao.int/ska-python:0.1.1"
FROM $BUILD_IMAGE as build

FROM $BASE_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-python/Dockerfile" \
      description="Base image for building images with pyTango applications" \
      license="BSD-3-Clause"

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        sudo \
        libjpeg8; \
    rm -rf /var/lib/apt/lists/*

# Provides tango_admin, libtango, retry and wait-for-it.sh
COPY --from=build /usr/local/ /usr/local/

RUN useradd --create-home --home-dir /home/tango tango

RUN echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango && \
    chmod 0440 /etc/sudoers.d/tango

USER tango

