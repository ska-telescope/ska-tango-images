ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="artefact.skao.int/ska-base:0.1.0"

FROM $BASE_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-base/Dockerfile"

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        sudo \
        libjpeg8; \
    rm -rf /var/lib/apt/lists/*

COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry

RUN useradd --create-home --home-dir /home/tango tango

RUN echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango && \
    chmod 0440 /etc/sudoers.d/tango

USER tango

