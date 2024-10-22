ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:local"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-admin:local"
FROM $BUILD_IMAGE as build
ARG DATABASEDS_VERSION=Database-Release-5.22

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libmariadbclient-dev-compat \
        cmake \
        git

RUN mkdir /usr/src/databaseds
WORKDIR /usr/src/databaseds
RUN set -xe; \
    git clone --depth=1 --branch=${DATABASEDS_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/TangoDatabase.git /usr/src/databaseds; \
    cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
    cmake --build build -j$(nproc) --target install


FROM $BASE_IMAGE
COPY --from=build /usr/local/bin/Databaseds /usr/local/bin/

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-databaseds/Dockerfile" \
      int.skao.application="TangoDatabase" \
      description="Contains the Databaseds application from the Tango controls collaboration" \
      license="BSD-3-Clause"

USER root

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libmariadb3; \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/local/bin/Databaseds /usr/local/bin/DataBaseds

USER tango

ENTRYPOINT ["/usr/local/bin/DataBaseds"]

CMD ["2", "-ORBendPoint", "giop:tcp::10000"]
