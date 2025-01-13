ARG CAR_OCI_REGISTRY_HOST
ARG SKABUILDPYTHON_VERSION
ARG BUILD_IMAGE="artefact.skao.int/ska-build-python:${SKABUILDPYTHON_VERSION}"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-python:local"
FROM $BUILD_IMAGE AS build
ARG PYTANGO_VERSION
ARG DSCONFIG_VERSION

ENV VIRTUAL_ENV=/app
RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3-venv; \
    python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --no-cache-dir pytango==${PYTANGO_VERSION} dsconfig==${DSCONFIG_VERSION}

RUN pip uninstall -y pip

FROM $BASE_IMAGE

ENV VIRTUAL_ENV=/app
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-dsconfig/Dockerfile" \
      int.skao.application="MaxIV Tango Dsconfig" \
      description="Contains the dsconfig application from the Tango controls collaboration" \
      license="BSD-3-Clause"

# Existing Helm charts assume tango-dsconfig starts in the root directory
WORKDIR /
