ARG BASE_IMAGE="alpine:3.13"
FROM $BASE_IMAGE AS buildenv

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry.sh

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    file mariadb-connector-c-dev pkgconf-dev \
    g++ python3-dev make czmq-dev libzmq zeromq-dev\
    libffi-dev openssl-dev boost-dev
    
RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake

# build and install cpp zmq at v4.7.1
RUN git clone -b v4.7.1 --depth 1 https://github.com/zeromq/cppzmq.git /cppzmq && \
    export PKG_CONFIG_PATH=/usr/local/zmq/lib/pkgconfig && \
    cmake -B /cppzmq/build -DCPPZMQ_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local /cppzmq && \
    make -C /cppzmq/build install
    
# build and install omniORB at 4.2.4
RUN curl -L https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2/download -o /omniORB.tar.bz2 && \
    mkdir /omniORB && \
    tar xaf /omniORB.tar.bz2 --strip-components=1 -C /omniORB && \
    cd /omniORB && \
    ./configure  && \
    make && \
    make install

# build and install tangoidl
RUN git clone --depth 1 https://gitlab.com/tango-controls/tango-idl.git /idl && \
    cmake -B /idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /idl && \
    make -C /idl/build install   
    

# build and install cppTango
RUN git clone --depth 1 https://gitlab.com/tango-controls/cppTango /cppTango && \
    cd /cppTango && \
    sed -i '1s/^/#include <sys\/types.h>\n#include <bits\/alltypes.h>\n/' /cppTango/log4tango/include/log4tango/FileAppender.hh && \
    mkdir build && \
    cd build && \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig" cmake .. && \
    make && \
    make install

# build and install tango_admin
RUN git clone https://gitlab.com/tango-controls/tango_admin.git /tango_admin && \
    cd /tango_admin && \
    mkdir build && \
    cd build && \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig" cmake .. -DBUILD_TESTING=OFF && \
    make && \
    make install
    
# Now, create the final image minus the tools and source code
ARG BASE_IMAGE="python:3.8.10-alpine3.13"
FROM $BASE_IMAGE 
LABEL \
      author="Piers Harding <Piers.Harding@skao.int>" \
      description="This image illustrates build dependencies" \
      license="Apache2.0" \
      int.skao.team="Systems Team" \
      int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
      int.skao.application="Tango CPP"
      
# copy the built library dependencies from the builder stage
COPY --from=buildenv /usr/local /usr/local

RUN apk add --update --no-cache mariadb-connector-c musl-utils sudo

RUN ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9

RUN adduser -h /home/tango -D tango
RUN echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango \
    && chmod 0440 /etc/sudoers.d/tango
    
USER tango

