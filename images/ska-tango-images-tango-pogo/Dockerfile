ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java:9.3.5"
FROM $BASE_IMAGE

LABEL \
    author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
    description="This image is the Pogo application available from the TANGO-community" \
    license="BSD-3-Clause" \
    registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-pogo" \
    org.skatelescope.team="Systems Team" \
    org.skatelescope.version="1.0.0" \
    int.skao.application="Tango Pogo"

USER root

ENV POGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/Pogo-9.6.31.jar

RUN apt-get update && \
    apt-get -y install wget
    # unattended-upgrades

# Apply security upgrades
# RUN unattended-upgrade

WORKDIR /usr/local/share/java

# Pogo is included in tango source distribution, but replace with a newer version
# Official source:  https://bintray.com/tango-controls/maven/Pogo/_latestVersion
RUN wget --no-check-certificate "$POGO_DOWNLOAD_URL" -O Pogo-9.6.31.jar \
    && ln -sf Pogo-9.6.31.jar Pogo.jar

USER tango

CMD ["/usr/local/bin/pogo"]

