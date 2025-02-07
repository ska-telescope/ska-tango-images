ARG CAR_OCI_REGISTRY_HOST
ARG SKABUILDPYTHON_VERSION
ARG BUILD_IMAGE="artefact.skao.int/ska-build-python:${SKABUILDPYTHON_VERSION}"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-python:local"
FROM $BUILD_IMAGE AS build
ARG PYTANGO_VERSION
ARG NUMPY_VERSION
ARG YAML2ARCHIVING_VERSION

ENV VIRTUAL_ENV=/app
RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3-venv \
        git; \
    python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN mkdir /usr/src/yaml2archiving
WORKDIR /usr/src/yaml2archiving
RUN set -xe; \
    git clone --depth=1 --branch=${YAML2ARCHIVING_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/hdbpp/yaml2archiving.git /usr/src/yaml2archiving; \
    pip install numpy==${NUMPY_VERSION} pytango==${PYTANGO_VERSION} .

RUN pip uninstall -y pip

FROM $BASE_IMAGE AS final

ENV VIRTUAL_ENV=/app
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-yaml2archiving/Dockerfile" \
      int.skao.application="Yaml2Archiving" \
      description="Contains the yaml2archiving tool from the Tango controls collaboration" \
      license="BSD-3-Clause"

ENTRYPOINT ["yaml2archiving"]
