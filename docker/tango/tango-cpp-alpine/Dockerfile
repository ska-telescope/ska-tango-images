ARG CAR_OCI_REGISTRY_HOST
ARG BUILDER_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.1.0"
ARG BASE_IMAGE="python:3.8.10-alpine3.13"
FROM $BUILDER_IMAGE AS buildenv

# build and install tangoidl
RUN mkdir /usr/src && cd /usr/src && \
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
