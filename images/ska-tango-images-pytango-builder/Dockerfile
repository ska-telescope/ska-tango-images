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
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:9.3.7"
FROM $BASE_IMAGE

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
               git \
               libjpeg-dev

RUN curl -k https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
COPY pip.conf /etc/pip.conf

WORKDIR /app

# Install numpy manually before PyTango and other requirements to ensure we
# build PyTango with numpy support.
RUN python3 -m pip install numpy==1.19.2

## Install PyTango from Thomas' repo to get latest MacOS workarounds
RUN git clone --depth=1 --branch=develop_9.4-after_cppTango_header_file_separation https://gitlab.com/tjuerges/pytango.git
WORKDIR /app/pytango
RUN python3 setup.py install

WORKDIR /app

COPY requirements.txt /requirements.txt
RUN python3 -m pip install -r /requirements.txt

RUN mkdir /venv && ln -s /usr/* /venv/  && ln -s /usr/local/bin/itango3 /venv/bin/itango3 && ln -sfn /usr/bin/python3 /usr/bin/python
