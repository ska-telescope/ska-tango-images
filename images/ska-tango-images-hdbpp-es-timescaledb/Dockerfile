ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:local"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-admin:local"
FROM $BUILD_IMAGE AS build
ARG HDBPP_ES_VERSION
ARG LIBHDBPP_VERSION
ARG LIBHDBPP_TIMESCALE_VERSION

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cmake \
        libspdlog-dev \
        libpqxx-dev \
        pkg-config \
        git

RUN mkdir /usr/src/libhdbpp
WORKDIR /usr/src/libhdbpp
RUN set -xe; \
    git clone --depth=1 --branch=${LIBHDBPP_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/hdbpp/libhdbpp.git /usr/src/libhdbpp; \
    # This find module is broken for the 2.2.0 release, but the \
    # TangoConfig.cmake installed by cppTango works so let's force cmake to \
    # use that. \
    rm cmake/FindTango.cmake; \
    cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
    cmake --build build -j$(nproc) --target install

RUN mkdir /usr/src/libhdbpp-timescale
WORKDIR /usr/src/libhdbpp-timescale
RUN set -xe; \
    git clone --depth=1 --branch=${LIBHDBPP_TIMESCALE_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/hdbpp/libhdbpp-timescale.git /usr/src/libhdbpp-timescale; \
    cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib \
        -DBUILD_SHARED_LIBS=ON; \
    cmake --build build -j$(nproc) --target install

RUN mkdir /usr/src/hdbpp-es
WORKDIR /usr/src/hdbpp-es
RUN set -xe; \
    git clone --depth=1 --branch=${HDBPP_ES_VERSION} --recursive -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/hdbpp/hdbpp-es.git /usr/src/hdbpp-es; \
    cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
    cmake --build build -j$(nproc) --target install

FROM $BASE_IMAGE

USER root

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libspdlog1 \
        libpqxx-6.4; \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /usr/local/bin/hdb++es-srv /usr/local/bin/

USER tango

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-hdbpp-es/Dockerfile" \
      int.skao.application="HDB++ Event Subscriber" \
      description="Contains the hdb++ex-srv application from the Tango controls collaboration" \
      license="BSD-3-Clause"

ENTRYPOINT ["/usr/local/bin/hdb++es-srv"]
