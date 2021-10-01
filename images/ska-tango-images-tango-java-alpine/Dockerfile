#
# This Dockerfile builds Tango including Java apps and libraries in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.0.0"
FROM $BUILD_IMAGE

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates libtool \
    file mariadb-connector-c-dev pkgconf-dev \
    python3-dev make czmq-dev autoconf automake \
    libffi-dev openssl-dev boost-dev bash dpkg sudo

RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake
    
ENV JAVA_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/jre-8u221-linux-x64.tar.gz
ENV LOG4J=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/log4j-1.2.17.tar.gz

RUN mkdir /usr/java
WORKDIR /usr/java
RUN wget --no-check-certificate "$JAVA_DOWNLOAD_URL" -O java.tar.gz \
    && tar zxvf java.tar.gz \
    && update-alternatives --install /usr/bin/java java /usr/java/jre1.8.0_221/bin/java 0 \
    && update-alternatives --set java /usr/java/jre1.8.0_221/bin/java \
    && rm /usr/java/java.tar.gz

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango

## tar with tango libraries, version 9.3.4 
ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz
RUN curl -fsSL "$TANGO_DOWNLOAD_URL" -o tango.tar.gz \
    && tar xf tango.tar.gz -C /usr/src/tango --strip-components=1 \
    && sed -i '1s/^/#include <sys\/types.h>\n#include <bits\/alltypes.h>\n/' \
    lib/cpp/log4tango/include/log4tango/FileAppender.hh \
    && sed -i 's/SIGCLD/SIGCHLD/g' lib/cpp/server/dserversignal.cpp \
    && sed -i '/if (auth_signal(signo) == false)/,+7d' lib/cpp/server/dserversignal.cpp \
    && sed -i 's/<procfs.h>/<sys\/procfs.h>/g' cppserver/starter/CheckProcessUtil.h \
    && sed -i '/solaris/,+98d' cppserver/starter/CheckProcessUtil.cpp \
    && chmod a+x config/install-sh lib/cpp/log4tango/config/install-sh \
    && autoupdate && sed -i '/SED_AC_WORKING($SED)/,+3d' configure.ac \
    && autoconf && ./configure --with-zmq=/usr/local --with-omni=/usr/local \
    --with-mysqlclient-prefix=/usr --enable-static=no \
    && make -C /usr/src/tango  -j$(nproc) \
    && make -C /usr/src/tango install \
    && rm -rf /usr/src/tango

WORKDIR /usr/java
RUN mkdir  /usr/local/share/java\
    && wget --no-check-certificate "$LOG4J" -O log4j.tar.gz \
    && tar zxvf log4j.tar.gz \
    && mv apache-log4j-1.2.17/log4j-1.2.17.jar /usr/local/share/java/log4j-1.2.17.jar \
    && rm /usr/java/log4j.tar.gz

RUN adduser -h /home/tango -D tango && \
    echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango
USER tango
