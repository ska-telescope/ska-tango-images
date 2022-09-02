ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.0.0"

ARG POETRY_VERSION=1.2
ARG PYTANGO_VERSION=9.3.3
ARG NUMPY_VERSION=1.23.1

FROM $BASE_IMAGE

LABEL \
    author="Piers Harding <Piers.Harding@skao.int>" \
    description="This image illustrates build dependencies" \
    license="Apache2.0" \
    int.skao.team="Systems Team" \
    int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
    int.skao.application="Tango Builder"

USER root

# Install build time dependencies
# boost-dev and libstdc++ are fundamental dependencies
RUN apk --update add --no-cache libstdc++ \
    g++ \
    libsodium-dev \
    libffi-dev \
    zlib-dev \
    boost \
    boost-dev \
    python3-dev \
    py3-pip \
    py3-cryptography \
    bash \
    make \
    ca-certificates \
    curl \
    git

# setup pip ready for package installs
COPY pip.conf /etc/pip.conf
WORKDIR /wheels

# Install numpy manually before PyTango and other requirements to ensure we
# build PyTango with numpy support.
RUN python3.9 -m pip install wheel six numpy==${NUMPY_VERSION}
# now build python wheels for the requirements (pytango, numpy)
RUN python3.9 -m pip wheel numpy==${NUMPY_VERSION} pytango==${PYTANGO_VERSION}

# Install poetry
RUN curl -sSL https://install.python-poetry.org | \
    POETRY_VERSION=${POETRY_VERSION} POETRY_HOME=/usr/local python3 -
