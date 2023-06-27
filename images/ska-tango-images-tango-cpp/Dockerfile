#
# This Dockerfile builds base Tango (C++ only, no Java or Python) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies:9.3.12"
ARG BASE_IMAGE="ubuntu:22.04"
FROM $BUILD_IMAGE as buildenv
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    file \
    git \
    libmariadbclient-dev-compat \
    pkg-config \
    python3 \
    unattended-upgrades \
    libjpeg8-dev

# Apply security upgrades (base image is not patched)
RUN unattended-upgrade
RUN apt-get purge unattended-upgrades -y

# build and install tangoidl
RUN mkdir -p /usr/src/idl
WORKDIR /usr/src/idl

RUN git clone https://gitlab.com/tango-controls/tango-idl.git /usr/src/idl && \
    cd /usr/src/idl && git checkout 5.1.2 && \
    mkdir -p /usr/src/idl/build && \
    cmake -B /usr/src/idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/idl && \
    make  -j$(nproc) -C /usr/src/idl/build install

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango

RUN git clone https://gitlab.com/tango-controls/cppTango.git /usr/src/tango && \
    cd /usr/src/tango && git checkout 9.4.2 && \
    mkdir build && \
    cmake . -B build \
    -DBUILD_TESTING=OFF \
    -DTANGO_CPPZMQ_BASE=/usr/local/ \
    -DTANGO_IDL_BASE=/usr/local/ \
    -DTANGO_OMNI_BASE=/usr/local/ \
    -DTANGO_ZMQ_BASE=/usr/local/ && \
    make -C /usr/src/tango/build -j$(nproc) && \
    make -C /usr/src/tango/build install && \
    ldconfig && \
    rm -r /usr/src/tango

# build and install tango_admin
RUN git clone https://gitlab.com/tango-controls/tango_admin.git /usr/src/tango_admin && \
    cd /usr/src/tango_admin && git checkout Release_1.17 && \
    cmake -B /usr/src/tango_admin/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/tango_admin && \
    make  -j$(nproc) -C /usr/src/tango_admin/build install

# build and install TangoDatabase
RUN git clone https://gitlab.com/tango-controls/TangoDatabase.git /usr/src/TangoDatabase && \
    cd /usr/src/TangoDatabase && git checkout Database-Release-5.21 && \
    cmake -B /usr/src/TangoDatabase/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/TangoDatabase && \
    make  -j$(nproc) -C /usr/src/TangoDatabase/build install

FROM $BASE_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

LABEL \
    author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
    description="This image includes the TANGO-controls framework with all its dependencies" \
    license="BSD-3-Clause" \
    registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp" \
    org.skatelescope.team="Systems Team" \
    org.skatelescope.version="1.0.0" \
    int.skao.application="Tango CPP"

COPY --from=buildenv /usr/local /usr/local

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libmariadb3 \
    sudo \
    libjpeg8-dev

RUN useradd --create-home --home-dir /home/tango tango

RUN \
    echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango && \
    chmod 0440 /etc/sudoers.d/tango && \
    ln -s /usr/local/bin/Databaseds /usr/local/bin/DataBaseds

USER tango
