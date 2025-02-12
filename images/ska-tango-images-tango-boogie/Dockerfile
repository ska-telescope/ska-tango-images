ARG CAR_OCI_REGISTRY_HOST
ARG SKABUILDPYTHON_VERSION
ARG BUILD_IMAGE="artefact.skao.int/ska-build-python:${SKABUILDPYTHON_VERSION}"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-python:local"
FROM $BUILD_IMAGE AS build
ARG PYTANGO_VERSION
ARG BOOGIE_VERSION

ENV VIRTUAL_ENV=/app
RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3-venv \
        git; \
    python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN mkdir /usr/src/boogie
WORKDIR /usr/src/boogie
RUN set -xe; \
    git init; \
    git remote add origin https://gitlab.com/nurbldoff/boogie.git; \
    git fetch --depth 1 origin ${BOOGIE_VERSION}; \
    git checkout FETCH_HEAD; \
    pip install pytango==${PYTANGO_VERSION} .

RUN pip uninstall -y pip

FROM $BASE_IMAGE AS final

ENV VIRTUAL_ENV=/app
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-boogie/Dockerfile" \
      int.skao.application="Boogie" \
      description="Contains the Boogie application from the Tango controls collaboration" \
      license="BSD-3-Clause"

CMD ["boogie"]
