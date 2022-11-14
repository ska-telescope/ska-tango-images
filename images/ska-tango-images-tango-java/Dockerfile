#
# This Dockerfile builds Tango including Java apps and libraries in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies:9.3.5"
FROM $BUILD_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the Java GUI applications of the TANGO-controls framework" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango Java"

ENV JAVA_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/jre-8u221-linux-x64.tar.gz
ENV TANGO_DOWNLOAD_URL=https://gitlab.com/tango-controls/JTango/-/archive/9.7.0/JTango-9.7.0.tar.gz
ENV LOG4J=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/log4j-1.2.17.tar.gz


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        wget sudo libxrender1 libxtst6 libxi6 \
        build-essential curl file libmariadbclient-dev-compat pkg-config libmariadb3 python3

RUN mkdir /usr/java
WORKDIR /usr/java

RUN wget --no-check-certificate "$JAVA_DOWNLOAD_URL" -O java.tar.gz \
    && tar zxvf java.tar.gz \
    && update-alternatives --install /usr/bin/java java /usr/java/jre1.8.0_221/bin/java 0 \
    && update-alternatives --set java /usr/java/jre1.8.0_221/bin/java \
    && rm /usr/java/java.tar.gz

RUN mkdir -p /usr/src/tango
RUN mkdir -p /usr/share/man/man1
WORKDIR /usr/src/tango

RUN curl -fsSL -k "$TANGO_DOWNLOAD_URL" -o tango.tar.gz \
    && tar xf tango.tar.gz -C /usr/src/tango --strip-components=1 \
    && ./configure --with-zmq=/usr/local --with-omni=/usr/local --with-mysqlclient-prefix=/usr --enable-static=no \
    && make -C /usr/src/tango -j$(nproc) \
    && make -C /usr/src/tango install \
    && ldconfig \
    && rm -r /usr/src/tango

WORKDIR /usr/java

RUN wget --no-check-certificate "$LOG4J" -O log4j.tar.gz \
    && tar zxvf log4j.tar.gz \
    && mv apache-log4j-1.2.17/log4j-1.2.17.jar /usr/local/share/java/log4j-1.2.17.jar \
    && rm /usr/java/log4j.tar.gz

RUN useradd --create-home --home-dir /home/tango tango

RUN echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango \
    && chmod 0440 /etc/sudoers.d/tango

USER tango
