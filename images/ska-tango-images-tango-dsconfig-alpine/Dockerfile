ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.0.0"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime-alpine:0.0.0"
FROM $BUILD_IMAGE as buildenv
FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the MaxIV Dsconfig tool" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dsconfig" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="MaxIV Tango Dsconfig"

RUN python3 -m pip install dsconfig && python3.9 -m pip cache purge 

# Existing Helm charts assume tango-dsconfig starts in the root directory
WORKDIR /
