ARG CAR_OCI_REGISTRY_HOST
ARG BUILDER_BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.2.3"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.2.13"
FROM $BUILDER_BASE_IMAGE AS buildenv

FROM $BASE_IMAGE
LABEL \
      author="Piers Harding <Piers.Harding@skao.int>" \
      description="This image illustrates build dependencies" \
      license="Apache2.0" \
      int.skao.team="Systems Team" \
      int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
      int.skao.application="Tango Runtime"
      
USER root

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    boost py3-distutils-extra python3 py3-pip boost-python3 make libzmq

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences    
COPY --from=buildenv /usr/local/bin/wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY --from=buildenv /usr/local/bin/retry /usr/local/bin/retry
COPY --from=buildenv /usr/local/lib/python3.9 /usr/local/lib/python3.9

COPY pip.conf /etc/pip.conf

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:/usr/lib

RUN mkdir -p /etc/ld.so.conf.d && \
    echo "include /etc/ld.so.conf.d/*.conf" > /etc/ld.so.conf && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/tango.conf && \
    echo "/usr/local/lib64" > /etc/ld.so.conf.d/tango.conf && \
    ldconfig /etc/ld.so.conf.d

RUN mkdir /venv && ln -s /usr/* /venv/ && ln -s /usr/bin/python3 /venv/bin/python && ln -s /usr/local/bin/itango3 /venv/bin/itango3

USER tango
ENV PATH="/home/tango/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"


ONBUILD COPY --chown=tango:tango . /app
ONBUILD COPY --from=buildenv /usr/local/bin/ /usr/local/bin/
ONBUILD WORKDIR /app
