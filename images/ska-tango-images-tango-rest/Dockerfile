ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java:local"
FROM $BASE_IMAGE

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-rest/Dockerfile" \
      int.skao.application="Tango REST"

USER root

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        supervisor \
        ssl-cert \
        libtcnative-1; \
    rm -rf /var/lib/apt/lists/*

COPY tango_register_device.sh /usr/local/bin/
COPY supervisord.conf /etc/supervisor/conf.d/

USER tango

CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]
