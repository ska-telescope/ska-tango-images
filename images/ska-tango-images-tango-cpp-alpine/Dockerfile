ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="alpine:3.15"
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.0.0"

FROM $BUILD_IMAGE AS buildenv

# Install build time dependencies
RUN apk --update add --no-cache make bash\
    libsodium-dev libstdc++ g++ mariadb-connector-c-dev \
    git cmake python3-dev

# build and install tangoidl
RUN git clone --depth 1 https://gitlab.com/tango-controls/tango-idl.git /idl && \
    cmake -B /idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /idl && \
    make  -j$(nproc) -C /idl/build install

## build and install cppTango
## latest main version is not working using previous commit

RUN git clone https://gitlab.com/tango-controls/cppTango.git /cppTango && \
    cd /cppTango && git checkout 9.3.5 && \
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

RUN apk --update add --no-cache sudo libstdc++ bash libsodium-dev mariadb-connector-c \
# for some reason we are getting the wrong DataBaseds name
    && ln -s /usr/local/bin/Databaseds /usr/local/bin/DataBaseds \
# also create the user tango and add it to sudoers
    && adduser -h /home/tango -s /bin/bash -D tango \
    && echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango

USER tango
