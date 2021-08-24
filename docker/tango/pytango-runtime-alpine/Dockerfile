ARG CAR_PYPI_REPOSITORY_URL
ARG CAR_OCI_REGISTRY_HOST
ARG BUILDER_BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.1.0"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.1.1"
FROM $BUILDER_BASE_IMAGE AS builder

FROM $BASE_IMAGE

LABEL \
      author="Piers Harding <Piers.Harding@skao.int>" \
      description="This image illustrates build dependencies" \
      license="Apache2.0" \
      int.skao.team="Systems Team" \
      int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
      int.skao.application="Tango Runtime"

USER root

ENV PIP_INDEX_URL=${CAR_PYPI_REPOSITORY_URL}

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    boost py3-distutils-extra python3 py3-pip boost-python3 make libzmq

COPY --from=builder /usr/local/lib/python3.10 /usr/local/lib/python3.10

COPY pip.conf /etc/pip.conf

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:/usr/lib

RUN mkdir -p /etc/ld.so.conf.d && \
    echo "include /etc/ld.so.conf.d/*.conf" > /etc/ld.so.conf && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/tango.conf && \
    echo "/usr/local/lib64" > /etc/ld.so.conf.d/tango.conf && \
    ldconfig /etc/ld.so.conf.d

USER tango

ENV PIP_INDEX_URL=${CAR_PYPI_REPOSITORY_URL}

ENV PATH="/home/tango/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"
