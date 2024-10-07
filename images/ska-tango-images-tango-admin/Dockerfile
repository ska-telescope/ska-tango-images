ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:local"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-base:local"
FROM $BUILD_IMAGE as build
ARG TANGOADMIN_VERSION=Release_1.17

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        pkg-config \
        cmake \
        git

RUN mkdir /usr/src/tango_admin
WORKDIR /usr/src/tango_admin
RUN set -xe; \
    git clone --depth=1 --branch=${TANGOADMIN_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/tango_admin.git /usr/src/tango_admin; \
    cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
    make  -j$(nproc) -Cbuild install

FROM $BASE_IMAGE
COPY --from=build /usr/local/lib/lib*.so* /usr/local/lib/
COPY --from=build /usr/local/bin/tango_admin /usr/local/bin/

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-admin/Dockerfile"

ENTRYPOINT ["/usr/local/bin/tango_admin"]
