#
# This Dockerfile compiles Tango dependencies (ZeroMQ and OmniORB) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG BASE_IMAGE="ubuntu:22.04"
FROM $BASE_IMAGE as buildenv
ARG DEBIAN_FRONTEND=noninteractive

ENV ZEROMQ_DOWNLOAD_URL=https://github.com/zeromq/libzmq/archive/v4.3.4.tar.gz
ENV CPPZMQ_DOWNLOAD_URL=https://github.com/zeromq/cppzmq/archive/v4.8.1.tar.gz
ENV OMNIORB_DOWNLOAD_URL=https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2/download 

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    libkrb5-dev \
    libtool \
    pkg-config \
    unzip \
    cmake \
    python3-dev \
    python3-pkgconfig \
    unattended-upgrades

# Apply security upgrades (base image)
RUN unattended-upgrade
RUN apt-get purge unattended-upgrades -y

RUN mkdir /usr/src/zeromq
WORKDIR /usr/src/zeromq
RUN curl -kfsSL "$ZEROMQ_DOWNLOAD_URL" -o zeromq.tar.gz \
    && tar xf zeromq.tar.gz -C /usr/src/zeromq --strip-components=1 \
    && ./autogen.sh \
    && ./configure --enable-static=no \
    && make -C /usr/src/zeromq -j$(nproc) \
    && make -C /usr/src/zeromq install \
    && rm -r /usr/src/zeromq

RUN mkdir /usr/src/cppzmq
WORKDIR /usr/src/cppzmq
RUN curl -kfsSL "$CPPZMQ_DOWNLOAD_URL" -o cppzmq.tar.gz \
    && tar xf cppzmq.tar.gz -C /usr/src/cppzmq --strip-components=1 \
    && mkdir build \
    && cd build \
    && cmake -DCPPZMQ_BUILD_TESTS=OFF .. \
    && make -j4 install \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /usr/src/cppzmq

RUN mkdir /usr/src/omniorb
WORKDIR /usr/src/omniorb
RUN curl -kfsSL "$OMNIORB_DOWNLOAD_URL" -o omniorb.tar.bz2 \
    && tar xf omniorb.tar.bz2 -C /usr/src/omniorb --strip-components=1 \
    && ./configure --enable-static=no \
    && make -C /usr/src/omniorb -j$(nproc) \
    && make -C /usr/src/omniorb install \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /usr/src/omniorb

FROM $BASE_IMAGE

LABEL \
    author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
    description="This image includes all the depenencies needed for installing the TANGO-controls framework" \
    license="BSD-3-Clause" \
    registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies" \
    org.skatelescope.team="Systems Team" \
    org.skatelescope.version="1.0.0" \
    int.skao.application="Tango dependencies"

COPY --from=buildenv /usr/local /usr/local
