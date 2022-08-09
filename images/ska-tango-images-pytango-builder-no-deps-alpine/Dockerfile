ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:9.3.13"
FROM $BASE_IMAGE

LABEL \
    author="Piers Harding <Piers.Harding@skao.int>" \
    description="This image illustrates build dependencies" \
    license="Apache2.0" \
    int.skao.team="Systems Team" \
    int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
    int.skao.application="Tango Builder"

USER root
# pkgconfig needs to find these
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:/usr/lib

# Install build time dependencies
# boost-dev and libstdc++ are fundamental dependencies
RUN apk --update add --no-cache libstdc++ \
    g++ \
    libsodium-dev \
    libffi-dev \
    zlib-dev \
    boost \
    boost-dev \
    bash \
    make \
    ca-certificates \
    tzdata \
    cargo \
    curl \
    git \
    gcc \
    musl-dev \
    openssl-dev \
    python3-dev \
    py3-cryptography

# Install pip as binary as it causes dependency conflicts if installed from apk
# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 22.0.4
# https://github.com/docker-library/python/issues/365
ENV PYTHON_SETUPTOOLS_VERSION 58.1.0
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/5eaac1050023df1f5c98b173b248c260023f2278/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 5aefe6ade911d997af080b315ebcb7f882212d070465df544e1175ac2be519b4

RUN set -eux; \
    \
    wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
    echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
    \
    export PYTHONDONTWRITEBYTECODE=1; \
    \
    python3 get-pip.py \
    --disable-pip-version-check \
    --no-cache-dir \
    --no-compile \
    "pip==$PYTHON_PIP_VERSION" \
    "setuptools==$PYTHON_SETUPTOOLS_VERSION" \
    ; \
    rm -f get-pip.py; \
    \
    pip --version

ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages
# setup pip ready for package installs
COPY pip.conf /etc/pip.conf
WORKDIR /app
COPY requirements.txt requirements.txt

# Install poetry binary 
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 - --yes
ENV PATH="/opt/poetry/bin:$PATH"

# do ldconfig stuff
RUN mkdir -p /etc/ld.so.conf.d \
    && echo "include /etc/ld.so.conf.d/*.conf" > /etc/ld.so.conf \
    && echo "/usr/local/lib" > /etc/ld.so.conf.d/tango.conf \
    && echo "/usr/local/lib64" > /etc/ld.so.conf.d/tango.conf \
    && ldconfig /etc/ld.so.conf.d \
    # this was on the debian version
    && mkdir /venv \
    && ln -s /usr/* /venv/  \
    && ln -s /usr/local/bin/itango3 /venv/bin/itango3 \
    && ln -s /usr/bin/python3 /venv/bin/python 
