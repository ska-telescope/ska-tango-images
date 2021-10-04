ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.3.4"
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
RUN apk add --update --no-cache curl libstdc++ g++\
    openssl ca-certificates libsodium-dev \
    boost py3-distutils-extra zlib-dev py3-pip boost-python3 boost-dev libzmq bash
    
RUN apk add --no-cache --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git make
    
# setup pip ready for package installs
COPY pip.conf /etc/pip.conf
RUN pip3 install setuptools \
    wheel
    
WORKDIR /app

# pkgconfig needs to find these
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig

# Install numpy manually before PyTango and other requirements to ensure we
# build PyTango with numpy support. 
RUN python3.9 -m pip install numpy==1.21.0

# now install build requirements
COPY requirements.txt /requirements.txt
RUN python3.9 -m pip install -r /requirements.txt

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:/usr/lib

RUN mkdir -p /etc/ld.so.conf.d && \
    echo "include /etc/ld.so.conf.d/*.conf" > /etc/ld.so.conf && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/tango.conf && \
    echo "/usr/local/lib64" > /etc/ld.so.conf.d/tango.conf && \
    ldconfig /etc/ld.so.conf.d

RUN mkdir /venv && ln -s /usr/* /venv/  && ln -s /usr/local/bin/itango3 /venv/bin/itango3
