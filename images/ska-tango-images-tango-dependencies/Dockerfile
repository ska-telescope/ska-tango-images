#
# This Dockerfile compiles Tango dependencies (ZeroMQ and OmniORB) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG BUILD_IMAGE="harbor.skao.int/production/ska-build:0.1.0"
FROM $BUILD_IMAGE as build
ARG DEBIAN_FRONTEND=noninteractive
ARG ZEROMQ_VERSION=4.3.4
ARG CPPMQ_VERSION=4.8.1
ARG OMNIORB_VERSION=4.3.2

ENV ZEROMQ_DOWNLOAD_URL="https://github.com/zeromq/libzmq/archive/v${ZEROMQ_VERSION}.tar.gz"
ENV CPPZMQ_DOWNLOAD_URL="https://github.com/zeromq/cppzmq/archive/v${CPPMQ_VERSION}.tar.gz"
ENV OMNIORB_DOWNLOAD_URL="https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-${OMNIORB_VERSION}/omniORB-${OMNIORB_VERSION}.tar.bz2/download"

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        cmake \
        curl \
        libtool \
        pkg-config \
        unzip; \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/src/zeromq
WORKDIR /usr/src/zeromq
RUN set -xe; \
    curl -kfsSL "$ZEROMQ_DOWNLOAD_URL" -o zeromq.tar.gz; \
    tar xf zeromq.tar.gz -C /usr/src/zeromq --strip-components=1; \
    ./autogen.sh; \
    ./configure --enable-static=no; \
    make -C /usr/src/zeromq -j$(nproc); \
    make -C /usr/src/zeromq install

RUN mkdir /usr/src/cppzmq
WORKDIR /usr/src/cppzmq
RUN set -xe; \
    curl -kfsSL "$CPPZMQ_DOWNLOAD_URL" -o cppzmq.tar.gz; \
    tar xf cppzmq.tar.gz -C /usr/src/cppzmq --strip-components=1; \
    cmake -Bbuild -S. -DCPPZMQ_BUILD_TESTS=OFF; \
    make -Cbuild install

RUN mkdir /usr/src/omniorb
WORKDIR /usr/src/omniorb
RUN set -xe; \
    curl -kfsSL "$OMNIORB_DOWNLOAD_URL" -o omniorb.tar.bz2; \
    tar xf omniorb.tar.bz2 -C /usr/src/omniorb --strip-components=1; \
    ./configure --enable-static=no --disable-longdouble; \
    make -C /usr/src/omniorb -j$(nproc); \
    make -C /usr/src/omniorb install

FROM $BUILD_IMAGE

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-dependencies/Dockerfile"

COPY --from=build /usr/local /usr/local
