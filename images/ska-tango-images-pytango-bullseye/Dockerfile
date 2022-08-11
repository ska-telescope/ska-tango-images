#
# This Dockerfile compiles Tango dependencies (ZeroMQ and OmniORB) in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG BASE_IMAGE="debian:bullseye-slim"
FROM $BASE_IMAGE as buildenv

ENV ZEROMQ_DOWNLOAD_URL=https://github.com/zeromq/libzmq/archive/v4.3.4.tar.gz
ENV CPPZMQ_DOWNLOAD_URL=https://github.com/zeromq/cppzmq/archive/v4.8.1.tar.gz
ENV OMNIORB_DOWNLOAD_URL=https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2/download 
ENV DEBIAN_FRONTEND=noninteractive

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    autoconf automake build-essential ca-certificates \
    curl libkrb5-dev libtool pkg-config unzip \
    cmake python-dev 

RUN mkdir /usr/src/zeromq
WORKDIR /usr/src/zeromq
RUN curl -kfsSL "$ZEROMQ_DOWNLOAD_URL" -o zeromq.tar.gz \
    && tar xf zeromq.tar.gz -C /usr/src/zeromq --strip-components=1 \
    && ./autogen.sh \
    && ./configure --enable-static=no \
    && make -C /usr/src/zeromq -j$(nproc) \
    && make -C /usr/src/zeromq install \
    && rm -r /usr/src/zeromq

RUN mkdir /usr/src/cppzmq
WORKDIR /usr/src/cppzmq
RUN curl -kfsSL "$CPPZMQ_DOWNLOAD_URL" -o cppzmq.tar.gz \
    && tar xf cppzmq.tar.gz -C /usr/src/cppzmq --strip-components=1 \
    && mkdir build \
    && cd build \
    && cmake -DCPPZMQ_BUILD_TESTS=OFF .. \
    && make -j4 install \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /usr/src/cppzmq

RUN mkdir /usr/src/omniorb
WORKDIR /usr/src/omniorb
RUN curl -kfsSL "$OMNIORB_DOWNLOAD_URL" -o omniorb.tar.bz2 \
    && tar xf omniorb.tar.bz2 -C /usr/src/omniorb --strip-components=1 \
    && ./configure --enable-static=no \
    && make -C /usr/src/omniorb -j$(nproc) \
    && make -C /usr/src/omniorb install \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /usr/src/omniorb

FROM $BASE_IMAGE as tango-deps

LABEL \
    author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
    description="This image includes all the depenencies needed for installing the TANGO-controls framework" \
    license="BSD-3-Clause" \
    registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies" \
    org.skatelescope.team="Systems Team" \
    org.skatelescope.version="1.0.0" \
    int.skao.application="Tango dependencies"

COPY --from=buildenv /usr/local /usr/local


################### tango-cpp

FROM tango-deps AS tango-cpp-buildenv

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    file \
    git \
    libmariadb-dev \
    libmariadb-dev-compat \
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

RUN git clone https://gitlab.com/tango-controls/cppTango.git /usr/src/tango && \
    cd /usr/src/tango && git checkout 9.3.5 && \
    mkdir build && \
    cmake . -B build \
    -DBUILD_TESTING=OFF \
    -DCPPZMQ_BASE=/usr/local/ \
    -DIDL_BASE=/usr/local/ \
    -DOMNI_BASE=/usr/local/ \
    -DZMQ_BASE=/usr/local/ && \
    make -C /usr/src/tango/build -j$(nproc) && \
    make -C /usr/src/tango/build install && \
    ldconfig && \
    rm -r /usr/src/tango

# build and install tango_admin
RUN git clone https://gitlab.com/tango-controls/tango_admin.git /usr/src/tango_admin && \
    cmake -B /usr/src/tango_admin/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/tango_admin && \
    make  -j$(nproc) -C /usr/src/tango_admin/build install

# build and install TangoDatabase
RUN git clone --depth 1 https://gitlab.com/tango-controls/TangoDatabase.git /usr/src/TangoDatabase && \
    cmake -B /usr/src/TangoDatabase/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/TangoDatabase && \
    make  -j$(nproc) -C /usr/src/TangoDatabase/build install


FROM $BASE_IMAGE AS tango-cpp

LABEL \
    author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
    description="This image includes the TANGO-controls framework with all its dependencies" \
    license="BSD-3-Clause" \
    registry="artefact.skao.int/ska-tango-images-tango-cpp" \
    org.skatelescope.team="Systems Team" \
    org.skatelescope.version="1.0.0" \
    int.skao.application="Tango CPP"

COPY --from=tango-cpp-buildenv /usr/local /usr/local

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    libmariadb3 sudo

RUN useradd --create-home --home-dir /home/tango tango

RUN \
    echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango && \
    chmod 0440 /etc/sudoers.d/tango && \
    ln -s /usr/local/bin/Databaseds /usr/local/bin/DataBaseds

USER tango

################## pytango-builder

FROM tango-cpp


LABEL \
    author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
    description="This image includes the pytango framework with all its dependencies and building tools" \
    license="BSD-3-Clause" \
    registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder" \
    org.skatelescope.team="Systems Team" \
    org.skatelescope.version="1.0.0" \
    int.skao.application="PyTango Builder"

USER root

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies:
#
# * build-essential installs C/C++ compilers and build tools
# * libboost-python-dev is required to bind PyTango to the C++ Tango libs
# * pkg-config is used to locate required libraries
# * git is required for Python packages using katversion for release info
#
RUN apt-get update \
    && apt-get -y install --no-install-recommends build-essential \
    libboost-python-dev \
    pkg-config \
    python3-distutils \
    python3-setuptools \
    python3-wheel \
    zlib1g-dev \
    ca-certificates \
    curl \
    git 

RUN curl -k https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
COPY pip.conf /etc/pip.conf

WORKDIR /app

# Install numpy manually before PyTango and other requirements to ensure we
# build PyTango with numpy support.
RUN python3 -m pip install numpy==1.19.2
RUN python3 -m pip install pytango==9.3.3
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 - --yes
ENV PATH="${PATH}:/opt/poetry/bin"

RUN ln -sfn /usr/bin/python3 /usr/bin/python
