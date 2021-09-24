ARG CAR_OCI_REGISTRY_HOST
ARG BUILDER_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.2.3"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime-alpine:0.2.3"

FROM $BUILDER_IMAGE as buildenv
FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the ITango console for the TANGO-controls framework" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-itango" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="ITango"

USER root
RUN apk add --update --no-cache procps

USER tango
# create ipython profile to so that itango doesn't fail if ipython hasn't run yet
RUN ipython profile create

COPY requirements.txt /requirements.txt
RUN python3 -m pip install -r /requirements.txt

CMD ["itango3"]
