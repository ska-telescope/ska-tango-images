ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="artefact.skao.int/ska-build-python:0.1.1"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-python:local"
FROM $BUILD_IMAGE as build

ENV VIRTUAL_ENV=/app
RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3-venv; \
    python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m pip install --no-cache-dir ipython==8.5.0 itango==0.1.9

FROM $BASE_IMAGE

ENV VIRTUAL_ENV=/app
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-itango/Dockerfile" \
      int.skao.application="ITango" \
      description="Contains the itango3 application from the Tango Controls collaboration" \
      license="BSD-3-Clause"

USER root

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      procps; \
    rm -rf /var/lib/apt/lists/*

USER tango

# create ipython profile to so that itango doesn't fail if ipython hasn't run yet
RUN ipython profile create

CMD ["itango3"]
