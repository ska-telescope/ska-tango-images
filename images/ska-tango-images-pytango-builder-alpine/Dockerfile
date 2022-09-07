ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.0.0"
FROM $BASE_IMAGE

USER root
COPY pip.conf /etc/pip.conf

# Install regular dependencies and build time dependencies then build pytango and numpy
# clear the cache 
RUN apk --update add --no-cache \
    make \
    ca-certificates \
    curl \
    git \
    boost-python3 \ 
    py3-pip \
    g++ \
    py3-wheel \
    boost-dev \
    python3-dev && \
    python3.9 -m pip install --prefix=/usr/local numpy pytango==9.3.3 && \
    python3.9 -m pip cache purge  
  
ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages


LABEL \
    author="Piers Harding <Piers.Harding@skao.int>" \
    description="This image illustrates build dependencies" \
    license="Apache2.0" \
    int.skao.team="Systems Team" \
    int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
    int.skao.application="Tango Builder"


