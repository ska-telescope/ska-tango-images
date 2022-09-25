#
# This Dockerfile creates a Docker image intended to be a base runtime for SKA
# python projects. This image should be used as an intermediate layer
# alongside the pytango-builder image.
#
ARG CAR_PYPI_REPOSITORY_URL
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder:0.3.17"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp:9.3.11"

FROM ${BUILD_IMAGE} as buildenv
FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the pytango framework with all its dependencies and no building tools" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="PyTango Runtime"

USER root


# Permanently install Python and PyTango runtime dependencies:
#
# * libboost-python is required by PyTango;
# * make is required to manage execution of the tests inside the container
# * python3 is required as this image is intended for running Python Tango
#   devices.
#

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
      libboost-python1.74.0 \
      ca-certificates \
      make \
      curl \
      python3 \
      python3-distutils \
      python3-setuptools 
      
# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY --from=buildenv /usr/local/bin/wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY --from=buildenv /usr/local/bin/retry /usr/local/bin/retry
COPY --from=buildenv /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=buildenv /opt/poetry /opt/poetry

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
COPY pip.conf /etc/pip.conf

RUN ln -sfn /usr/bin/python3 /usr/bin/python && ln -sfn /opt/poetry/bin/poetry /usr/local/bin/poetry

USER tango
ENV PATH="home/tango/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"

ONBUILD COPY --chown=tango:tango . /app
ONBUILD COPY --from=buildenv /usr/local/bin/ /usr/local/bin/
ONBUILD WORKDIR /app
