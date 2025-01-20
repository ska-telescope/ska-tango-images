ARG TIMESCALEDB_VERSION
ARG BASE_IMAGE="timescale/timescaledb:${TIMESCALEDB_VERSION}"
FROM $BASE_IMAGE AS build
ARG HDBPP_TIMESCALE_PROJECT_VERSION

USER root

RUN set -xe; \
    apk add git

RUN mkdir /usr/src/hdbpp-timescale-project
WORKDIR /usr/src/hdbpp-timescale-project
RUN set -xe; \
    git init; \
    git remote add origin https://gitlab.com/tango-controls/hdbpp/hdbpp-timescale-project.git; \
    git fetch --depth 1 origin ${HDBPP_TIMESCALE_PROJECT_VERSION}; \
    git checkout FETCH_HEAD

FROM $BASE_IMAGE

USER root

COPY --from=build --chown=postgres:postgres /usr/src/hdbpp-timescale-project/resources/schema/hdb_schema.sql  /docker-entrypoint-initdb.d/901_hdb_schema.sql
COPY --from=build --chown=postgres:postgres /usr/src/hdbpp-timescale-project/resources/schema/hdb_roles.sql  /docker-entrypoint-initdb.d/902_hdb_roles.sql
COPY --from=build --chown=postgres:postgres /usr/src/hdbpp-timescale-project/resources/schema/hdb_images.sql  /docker-entrypoint-initdb.d/903_hdb_images.sql

USER postgres

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-archive-timescaledb/Dockerfile" \
      int.skao.application="TimescaleDb" \
      description="Contains a TimescaleDb with tables for archiving with HDB++" \
      license="BSD-3-Clause"
