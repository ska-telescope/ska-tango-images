ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="python:3.9.6-alpine3.14"
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.3.0"
FROM $BUILD_IMAGE AS buildenv

# Install build time dependencies
RUN apk add --update --no-cache make bash\
    libsodium-dev libstdc++ g++ mariadb-connector-c-dev

RUN apk add --virtual build-dependencies \
    git cmake

# build and install tangoidl
RUN git clone --depth 1 https://gitlab.com/tango-controls/tango-idl.git /idl && \
    cmake -B /idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /idl && \
    make  -j$(nproc) -C /idl/build install   

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
    make  -j$(nproc) -C build && \
    make  -C build install 

# build and install tango_admin
RUN git clone https://gitlab.com/tango-controls/tango_admin.git /tango_admin && \
    cmake -B /tango_admin/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /tango_admin && \
    make  -j$(nproc) -C /tango_admin/build install   

# build and install TangoDatabase
RUN git clone --depth 1 https://gitlab.com/tango-controls/TangoDatabase.git /TangoDatabase && \
    cmake -B /TangoDatabase/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /TangoDatabase && \
    make  -j$(nproc) -C /TangoDatabase/build install 

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

RUN apk add --update --no-cache sudo libstdc++ bash libsodium-dev mariadb-connector-c  

RUN ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9

# for some reason we are getting the wron DataBaseds name
# also create the user tango and add it to sudoers
RUN ln -s /usr/local/bin/Databaseds /usr/local/bin/DataBaseds && \
    adduser -h /home/tango -s /bin/bash -D tango && \
    echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango 

USER tango

