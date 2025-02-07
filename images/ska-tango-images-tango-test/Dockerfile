ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:local"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-admin:local"
FROM $BUILD_IMAGE AS build
ARG TANGOTEST_VERSION

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cmake \
        pkg-config \
        git

RUN mkdir /usr/src/TangoTest
WORKDIR /usr/src/TangoTest
RUN set -xe; \
    git clone --depth=1 --branch=${TANGOTEST_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/TangoTest.git /usr/src/TangoTest;  \
    cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
    make  -j$(nproc) -Cbuild install

FROM $BASE_IMAGE AS final
COPY --from=build /usr/local/bin/TangoTest /usr/local/bin

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-test/Dockerfile" \
      int.skao.application="TangoTest" \
      description="Contains the TangoTest application from the Tango controls collaboration" \
      license="BSD-3-Clause"

ENTRYPOINT ["/usr/local/bin/TangoTest"]

CMD ["test"]
