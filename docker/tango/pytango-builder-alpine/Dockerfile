ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.2.3"
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
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    boost py3-distutils-extra python3 zlib-dev py3-pip boost-python3 boost-dev libzmq
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
RUN python3.10 -m pip install numpy==1.21.0
# WARNING DANGER WILL ROBINSON!!!!
# link python39 boost to 310 and flat
RUN ln -s /usr/lib/libboost_python39.so.1.76.0 /usr/lib/libboost_python310.so && \
    ln -s /usr/lib/libboost_python39.so.1.76.0 /usr/lib/libboost_python.so
# now install build requirements
COPY requirements.txt /requirements.txt
RUN python3.10 -m pip install -r /requirements.txt
RUN mkdir /venv && ln -s /usr/* /venv/  && ln -s /usr/local/bin/itango3 /venv/bin/itango3
