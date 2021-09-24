ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="python:3.9-alpine3.14"
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.2.1"
FROM $BUILD_IMAGE AS buildenv

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry.sh

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    file mariadb-connector-c-dev pkgconf-dev \
    g++ python3-dev python3 make czmq-dev \
    libffi-dev openssl-dev boost-dev libsodium-dev

RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake

# build and install tangoidl
RUN git clone --depth 1 https://gitlab.com/tango-controls/tango-idl.git /idl && \
    cmake -B /idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /idl && \
    make -C /idl/build install   

## build and install cppTango
## latest main version is not working using previous commit
RUN git clone https://gitlab.com/tango-controls/cppTango /cppTango && \
    cd /cppTango && git checkout 1575524ada0a3f8fe97b4040c07da7c83fced325 && \
    sed -i '1s/^/#include <sys\/types.h>\n#include <bits\/alltypes.h>\n/' /cppTango/log4tango/include/log4tango/FileAppender.hh && \
    mkdir build && \    
    cmake . -B build \  
      -DBUILD_TESTING=OFF \  
      -DCPPZMQ_BASE=/usr/local/ \  
      -DIDL_BASE=/usr/local/ \  
      -DOMNI_BASE=/usr/local/ \  
      -DZMQ_BASE=/usr/local/ && \  
    make -C build && \
    make -C build install 

# build and install tango_admin
RUN git clone https://gitlab.com/tango-controls/tango_admin.git /tango_admin && \
    cd /tango_admin && \
    mkdir build && \
    cd build && \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig" cmake .. -DBUILD_TESTING=OFF && \
    make && \
    make install

# Now, create the final image minus the tools and source code
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

# create the user tango and add it to sudoers, for some reason we need to add it to the tango group
RUN adduser -h /home/tango -D tango && \
    echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango && \
    adduser tango tango

USER tango
