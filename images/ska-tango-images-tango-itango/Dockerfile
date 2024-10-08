ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder:local"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime:local"

FROM $BUILD_IMAGE as buildenv
FROM $BASE_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the ITango console for the TANGO-controls framework" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-itango" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="ITango"

USER root
RUN apt-get update && \
      apt-get install -y --no-install-recommends \
      procps 

USER tango

RUN python3 -m pip install --no-cache-dir ipython==8.5.0 itango==0.1.9
# create ipython profile to so that itango doesn't fail if ipython hasn't run yet
RUN ipython profile create

CMD ["itango3"]
