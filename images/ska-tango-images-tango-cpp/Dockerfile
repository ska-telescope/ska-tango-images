#
# This Dockerfile builds base Tango (C++ only, no Java or Python) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies:local"
ARG BASE_IMAGE="harbor.skao.int/production/ska-build:0.1.1"
FROM $BUILD_IMAGE as build
ARG DEBIAN_FRONTEND=noninteractive
ARG TANGOIDL_VERSION=5.1.2
ARG CPPTANGO_VERSION=9.5.0

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cmake \
        curl \
        file \
        git \
        libjpeg8-dev

RUN mkdir -p /usr/src/idl
WORKDIR /usr/src/idl
RUN set -xe; \
    git clone --depth=1 --branch=${TANGOIDL_VERSION} -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/tango-idl.git /usr/src/idl; \
    cmake -B /usr/src/idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/idl; \
    cmake --build /usr/src/idl/build  -j$(nproc) --target install

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango
RUN set -xe; \
    git clone --depth=1 --branch=${CPPTANGO_VERSION} --recurse-submodules --shallow-submodules \
        -c advice.detachedHead=false https://gitlab.com/tango-controls/cppTango.git /usr/src/tango; \
    cmake -S. -Bbuild -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
    cmake --build /usr/src/tango/build -j$(nproc) --target install

FROM $BASE_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-cpp-build/Dockerfile"

COPY --from=build /usr/local /usr/local

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libjpeg8; \
    rm -rf /var/lib/apt/lists/*
