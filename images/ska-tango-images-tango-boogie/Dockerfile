ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="artefact.skao.int/ska-build-python:0.1.1"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-python:local"
FROM $BUILD_IMAGE as build
ARG BOOGIE_VERSION=0613475efe44583e3cf724478ef6326e75a52493

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
    #git clone --depth=1 --branch=${BOOGIE_VERSION} --recursive -c advice.detachedHead=false \
    #    https://gitlab.com/nurbldoff/boogie.git /usr/src/boogie; \
    git init \
    && git remote add origin https://gitlab.com/nurbldoff/boogie.git \
    && git fetch --depth 1 origin ${BOOGIE_VERSION} \
    && git checkout FETCH_HEAD; \
    pip install .

FROM $BASE_IMAGE

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
