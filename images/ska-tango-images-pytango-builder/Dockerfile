#
# This Dockerfile creates a Docker image containing a build environment for SKA
# python projects. This image is intended to be used as an intermediate layer,
# where it can be used to compile C extensions to be copied into a final
# release image.
#
# This image caches a compilation of PyTango bindings so that child images
# need not recompile it.
#
ARG CAR_PYPI_REPOSITORY_URL
ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:9.3.13"
FROM $BASE_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the pytango framework with all its dependencies and building tools" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="PyTango Builder"

USER root

RUN apt update

# Install build dependencies:
# * build-essential installs C/C++ compilers and build tools
# * libboost-python-dev is required to bind PyTango to the C++ Tango libs
# * pkg-config is used to locate required libraries
# * git is required for Python packages using katversion for release info

RUN apt-get install -y --no-install-recommends \
      build-essential \
      libboost-python-dev \
      pkg-config \
      python3-distutils \
      python3-setuptools \
      python3-wheel \
      python3-venv \
      zlib1g-dev \
      ca-certificates \
      curl \
      git


RUN apt install -y zip bison build-essential cmake flex git libedit-dev \
  libllvm14 llvm-14-dev libclang-14-dev python3 zlib1g-dev libelf-dev libfl-dev python3-setuptools \
  liblzma-dev libdebuginfod-dev arping netperf iperf

RUN bash -xc "\
    git clone https://github.com/iovisor/bcc.git && \
    mkdir bcc/build && cd bcc/build && \
    cmake .. && \
    make && \
    make install && \
    cmake -DPYTHON_CMD=python3 .. && \
    pushd src/python/ && \
    make && \
    make install && \
    popd \
"

RUN curl -k https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
COPY pip.conf /etc/pip.conf

WORKDIR /app

# Install poetry as a binary
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VERSION=1.8.3
RUN mkdir -p $POETRY_HOME && curl -sSL https://raw.githubusercontent.com/python-poetry/install.python-poetry.org/main/install-poetry.py --output $POETRY_HOME/install-poetry.py
RUN cd $POETRY_HOME && POETRY_VERSION=${POETRY_VERSION} python3 install-poetry.py --yes
RUN /opt/poetry/bin/poetry --help

RUN python3 -m pip install --no-cache-dir numpy
RUN python3 -m pip install --no-cache-dir pytango==9.5.0
# RUN git clone https://gitlab.com/tango-controls/pytango.git && \
#     cd pytango && \
#     python3 setup.py build && \
#     python3 setup.py install && \
#     rm -rf /app/pytango

RUN ln -sfn /usr/bin/python3 /usr/bin/python && ln -sfn /opt/poetry/bin/poetry /usr/local/bin/poetry
