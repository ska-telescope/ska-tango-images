ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="python:3.9.6-alpine3.14"
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.2.2"
FROM $BUILD_IMAGE AS buildenv

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    file mariadb-connector-c-dev pkgconf-dev \
    g++ python3-dev make czmq-dev \
    libffi-dev openssl-dev boost-dev libsodium-dev

RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake

ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango

RUN curl -fsSL "$TANGO_DOWNLOAD_URL" -o tango.tar.gz \
    && tar xf tango.tar.gz -C /usr/src/tango --strip-components=1 \
    && ./configure --with-zmq=/usr/local --with-omni=/usr/local --with-mysqlclient-prefix=/usr --enable-static=no \
    && make -C /usr/src/tango -j$(nproc) \
    && make -C /usr/src/tango install \
    && ldconfig \
    && rm -r /usr/src/tango


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

RUN apk add --update --no-cache mariadb-connector-c musl-utils sudo bash

RUN ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9

# create the user tango and add it to sudoers, for some reason we need to add it to the tango group
RUN adduser -h /home/tango -D tango && \
    echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango

USER tango
