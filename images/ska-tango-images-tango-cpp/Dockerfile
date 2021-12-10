#
# This Dockerfile builds base Tango (C++ only, no Java or Python) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies:9.3.5"
ARG BASE_IMAGE="debian:buster-slim"
FROM $BUILD_IMAGE as buildenv

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        file \
        git \
        libmariadbclient-dev \
        libmariadbclient-dev-compat \
        pkg-config python


# build and install tangoidl

RUN mkdir -p /usr/src/idl
WORKDIR /usr/src/idl

RUN git clone --depth 1 https://gitlab.com/tango-controls/tango-idl.git /usr/src/idl && \
    mkdir -p /usr/src/idl/build && \
    cmake -B /usr/src/idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/idl && \
    make  -j$(nproc) -C /usr/src/idl/build install

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango

RUN git clone https://gitlab.com/piersharding/cppTango.git /usr/src/tango && \
    cd /usr/src/tango && git checkout enable-static-zmq-ports-9.3.3-somewhere && \
    mkdir build && \
    cmake . -B build \
      -DBUILD_TESTING=OFF \
      -DCPPZMQ_BASE=/usr/local/ \
      -DIDL_BASE=/usr/local/ \
      -DOMNI_BASE=/usr/local/ \
      -DZMQ_BASE=/usr/local/ && \
    make -C /usr/src/tango/build -j$(nproc) && \
    make -C /usr/src/tango/build install && \
    ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9 && \
    ldconfig && \
    rm -r /usr/src/tango


FROM $BASE_IMAGE

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
    apt-get -y install --no-install-recommends \
        libmariadb3 sudo

RUN useradd --create-home --home-dir /home/tango tango

RUN echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango \
    && chmod 0440 /etc/sudoers.d/tango

USER tango
