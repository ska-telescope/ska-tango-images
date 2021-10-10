ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.3.7"
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
RUN apk --update add --no-cache libstdc++ g++ \
    libsodium-dev zlib-dev boost-dev python3-dev py3-pip\
    bash make ca-certificates curl git
    
# setup pip ready for package installs
COPY pip.conf /etc/pip.conf
WORKDIR /app
COPY requirements.txt requirements.txt

## the --no-cache-dir may be removed if we wish for the builder
## to keep the python cache
RUN python3.9 -m pip --no-cache-dir install setuptools wheel \
# Install numpy manually before PyTango and other requirements to ensure we
# build PyTango with numpy support. 
    numpy==1.21.0 \
# now install build requirements
    && python3.9 -m pip --no-cache-dir install -r requirements.txt \
    && rm requirements.txt 
# do ldconfig stuff
RUN mkdir -p /etc/ld.so.conf.d \
    && echo "include /etc/ld.so.conf.d/*.conf" > /etc/ld.so.conf \
    && echo "/usr/local/lib" > /etc/ld.so.conf.d/tango.conf \
    && echo "/usr/local/lib64" > /etc/ld.so.conf.d/tango.conf \
    && ldconfig /etc/ld.so.conf.d \
# this was on the debian version
#    && mkdir /venv \
#    && ln -s /usr/* /venv/  
##    && ln -s /usr/local/bin/itango3 /venv/bin/itango3
