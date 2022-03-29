#
# This Dockerfile compiles Tango dependencies (ZeroMQ and OmniORB) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG BASE_IMAGE="alpine:3.14"
FROM $BASE_IMAGE as buildenv

# Install build time dependencies
RUN apk --update add --no-cache bash curl \
    openssl ca-certificates libstdc++ \
    g++ make libsodium-dev git cmake python3-dev
    
# build and install libzmq at v4.3.4
RUN git clone -b v4.3.4 --depth 1 https://github.com/zeromq/libzmq /libzmq && \
    cmake -B /libzmq/build -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_DRAFTS=OFF -DWITH_DOC=OFF -DZMQ_BUILD_TESTS=OFF /libzmq  && \
    make  -j$(nproc) -C /libzmq/build install

# build and install cpp zmq at v4.8.1
RUN git clone -b v4.8.1 --depth 1 https://github.com/zeromq/cppzmq.git /cppzmq && \
    cmake -B /cppzmq/build -DCPPZMQ_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local /cppzmq && \
    make  -j$(nproc) -C /cppzmq/build install
    
# build and install omniORB at 4.3.0
RUN curl -L https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.3.0/omniORB-4.3.0.tar.bz2/download -o /omniORB.tar.bz2 && \
    mkdir /omniORB && \
    tar xaf /omniORB.tar.bz2 --strip-components=1 -C /omniORB && \
    cd /omniORB && \
    ./configure --prefix=/usr/local/ && \
    make  -j$(nproc) && \
    make install

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry


FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes all the depenencies needed for installing the TANGO-controls framework" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango dependencies"
      
COPY --from=buildenv /usr/local /usr/local

