ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.0.0"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime-alpine:0.0.0"

FROM $BUILD_IMAGE as buildenv
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
RUN apk add --update --no-cache procps \
# if used for tests it will require gnu tar not the busybox one
    tar

USER tango
ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages

# create ipython profile to so that itango doesn't fail if ipython hasn't run yetRUN python3 -m pip install ipython==7.27.0 && python3.9 -m pip cache purge && ipython profile create

COPY requirements.txt /requirements.txt
RUN python3 -m pip install -r /requirements.txt && python3.9 -m pip cache purge

CMD ["itango3"]
