#
# This Dockerfile compiles Tango dependencies (ZeroMQ and OmniORB) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG BASE_IMAGE="alpine:latest"
FROM $BASE_IMAGE as buildenv

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    file pkgconf-dev \
    g++ python3-dev make czmq-dev \
    libffi-dev openssl-dev boost-dev
RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake
    
# build and install libzmq at v4.2.0
RUN mkdir /usr/src && cd /usr/src && \
    git clone https://github.com/zeromq/libzmq && \
    cd libzmq && \
    git checkout v4.2.0 && \
    mkdir build && \
    cd build && \
    cmake -DENABLE_DRAFTS=OFF -DWITH_DOC=OFF -DZMQ_BUILD_TESTS=OFF .. && \
    make && \
    make install
    
# build and install cpp zmq at v4.7.1
RUN cd /usr/src && \
    git clone https://github.com/zeromq/cppzmq && \
    cd cppzmq && \
    git checkout v4.7.1 && \
    mkdir build && \
    cd build && \
    cmake  -DCPPZMQ_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make && \
    make install

# build and install omniORB at 4.2.4
RUN cd /usr/src && \
    wget -O - "https://nav.dl.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2" | tar jxf - && \
    cd omniORB-4.2.4 && \
    ./configure && \
    make && \
    make install

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

