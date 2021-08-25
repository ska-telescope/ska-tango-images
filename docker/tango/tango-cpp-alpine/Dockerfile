ARG BASE_IMAGE="python:3.10.0rc1-alpine3.14"
FROM $BASE_IMAGE AS builder

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    file mariadb-connector-c-dev pkgconf-dev \
    g++ python3-dev make czmq-dev \
    libffi-dev openssl-dev boost-dev
RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake
# build and install libzmq at v4.2.0
RUN cd /usr/src && \
    git clone https://github.com/zeromq/libzmq && \
    cd libzmq && \
    git checkout v4.2.0 && \
    mkdir build && \
    cd build && \
    cmake -DENABLE_DRAFTS=OFF -DWITH_DOC=OFF -DZMQ_BUILD_TESTS=OFF .. && \
    make && \
    make install
# build and install cpp zmq at v4.2.3
RUN cd /usr/src && \
    git clone https://github.com/zeromq/cppzmq && \
    cd cppzmq && \
    git checkout v4.2.3 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make && \
    make install
# build and install omniORB at 4.2.4
RUN cd /usr/src && \
    wget -O - "https://nav.dl.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2" | tar jxf - && \
    cd omniORB-4.2.4 && \
    ./configure && \
    make && \
    make install
# build and install tangoidl
RUN cd /usr/src && \
    git clone https://gitlab.com/tango-controls/tango-idl && \
    cd tango-idl && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make install
# build and install cppTango
    # git checkout 9.3.4 - only head works at the moment
RUN cd /usr/src && \
    git clone https://gitlab.com/tango-controls/cppTango && \
    cd cppTango && \
    sed -i '1s/^/#include <sys\/types.h>\n#include <bits\/alltypes.h>\n/' /usr/src/cppTango/log4tango/include/log4tango/FileAppender.hh && \
    mkdir build && \
    cd build && \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig" cmake .. && \
    make && \
    make install
# build and install tango_admin
RUN cd /usr/src && \
    git clone https://gitlab.com/tango-controls/tango_admin.git && \
    cd tango_admin && \
    mkdir build && \
    cd build && \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig" cmake .. && \
    make && \
    make install
# Now, create the final image minus the tools and source code
ARG BASE_IMAGE="python:3.10.0rc1-alpine3.14"
FROM $BASE_IMAGE
LABEL \
      author="Piers Harding <Piers.Harding@skao.int>" \
      description="This image illustrates build dependencies" \
      license="Apache2.0" \
      int.skao.team="Systems Team" \
      int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
      int.skao.application="Tango CPP"
# copy the built library dependencies from the builder stage
COPY --from=builder /usr/local /usr/local
RUN apk add --update --no-cache mariadb-connector-c musl-utils
RUN ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9
RUN adduser -h /home/tango -D tango
USER tango