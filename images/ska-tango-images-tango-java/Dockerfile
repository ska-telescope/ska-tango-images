#
# This Dockerfile builds Tango including Java apps and libraries in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies:9.3.5"
FROM $BUILD_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

LABEL \
    author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
    description="This image includes the Java GUI applications of the TANGO-controls framework" \
    license="BSD-3-Clause" \
    registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java" \
    org.skatelescope.team="Systems Team" \
    org.skatelescope.version="1.0.0" \
    int.skao.application="Tango Java"

ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.5.0.tar.gz
ENV LOG4J=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/log4j-1.2.17.tar.gz

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    git \
    sudo \
    libxrender1 \
    libxtst6 \
    default-jre \
    libxi6 \
    build-essential \
    cmake \
    curl \
    file \
    libmariadbclient-dev-compat \
    pkg-config \
    libmariadb3 \
    python3 \
    libjpeg8-dev

RUN mkdir /usr/java
WORKDIR /usr/java

RUN mkdir -p /usr/src/tango
RUN mkdir -p /usr/share/man/man1
WORKDIR /usr/src/tango

# CMake flag `-Dtangoidl_ROOT=...` is required as a work around for
# tango-controls/TangoSourceDistribution#131
# TODO: Remove flag when issue is fixed
RUN curl -fsSL -k "$TANGO_DOWNLOAD_URL" -o tango.tar.gz \
    && tar xf tango.tar.gz -C /usr/src/tango --strip-components=1 \
    && cd /usr/src/tango \
    && cmake -Bbuild -S. -DTSD_DATABASE=OFF -DTSD_HTLM_DOCUMENTATION=OFF -Dtangoidl_ROOT=$PWD/lib/idl \
    && make -C build -j$(nproc) \
    && make -C build install \
    && ldconfig \
    && rm -r /usr/src/tango

RUN git clone --recurse-submodules --depth=1 --branch=main https://gitlab.com/tango-controls/tango_admin.git /usr/src/tango_admin && \
    cd /usr/src/tango_admin && \
    cmake -B /usr/src/tango_admin/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/tango_admin && \
    make  -j$(nproc) -C /usr/src/tango_admin/build install

WORKDIR /usr/java

RUN wget --no-check-certificate "$LOG4J" -O log4j.tar.gz \
    && tar zxvf log4j.tar.gz \
    && mv apache-log4j-1.2.17/log4j-1.2.17.jar /usr/local/share/java/log4j-1.2.17.jar \
    && rm /usr/java/log4j.tar.gz

RUN useradd --create-home --home-dir /home/tango tango

RUN echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango \
    && chmod 0440 /etc/sudoers.d/tango

USER tango
