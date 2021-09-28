ARG CAR_OCI_REGISTRY_HOST
ARG BUILDER_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.2.6"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime-alpine:0.2.6"
FROM $BUILDER_IMAGE as buildenv
FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the MaxIV Dsconfig tool" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dsconfig" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="MaxIV Tango Dsconfig"

RUN python3 -m pip install python-dsconfig

# Existing Helm charts assume tango-dsconfig starts in the root directory
WORKDIR /
