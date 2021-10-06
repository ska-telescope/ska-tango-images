ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE=alpine:3.14
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java-alpine:0.0.2"

FROM $BUILD_IMAGE AS buildenv

ENV MTANGOREST_DOWNLOAD_URL=https://github.com/tango-controls/rest-server/releases/download/rest-server-1.14/rest-server-1.14.jar

RUN apk add --no-cache ca-certificates curl 

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

RUN mkdir -p /usr/share/man/man1 \
    && apk add --no-cache  tomcat-native expat-dev \
    && python3 -m pip install --no-cache-dir supervisor==4.2.2

COPY tango_register_device.sh /usr/local/bin/

# Configure supervisord. Ensure supervisord.conf contains entries for your device!
COPY supervisord.conf /etc/supervisor/

# Start supervisor as daemon
CMD ["/usr/local/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]
