ARG CAR_OCI_REGISTRY_HOST
ARG BUILDER_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies:9.3.4"
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java:9.3.4"

FROM $BUILDER_IMAGE AS buildenv

ENV MTANGOREST_DOWNLOAD_URL=https://github.com/tango-controls/rest-server/releases/download/rest-server-1.14/rest-server-1.14.jar

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get -y install ca-certificates curl libtcnative-1 --no-install-recommends

RUN mkdir -p /usr/local/lib/tango

WORKDIR /usr/local/lib/tango

RUN curl -fsSL "$MTANGOREST_DOWNLOAD_URL" -o mtangorest.jar

FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the tango-rest application available from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-rest" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango REST"

COPY --from=buildenv /usr/local/lib/tango/mtangorest.jar /usr/local/lib/tango/mtangorest.jar

USER root

RUN mkdir -p /usr/share/man/man1

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get -y install supervisor libtcnative-1 --no-install-recommends

RUN ln -s /usr/lib/x86_64-linux-gnu/libtcnative-1.so /usr/lib/libtcnative-1.so

RUN rm -rf /var/lib/apt/lists/* /etc/apt/apt.conf.d/30proxy

COPY tango_register_device.sh /usr/local/bin/

# Configure supervisord. Ensure supervisord.conf contains entries for your device!
COPY supervisord.conf /etc/supervisor/conf.d/

# Start supervisor as daemon
CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]
