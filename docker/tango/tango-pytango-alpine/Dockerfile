ARG CAR_OCI_REGISTRY_HOST
ARG BUILDER_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.3.0"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime-alpine:0.3.1"
FROM $BUILDER_IMAGE as buildenv
FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the pytango framework with all its dependencies and no building tools" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-pytango" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="PyTango Runtime"
