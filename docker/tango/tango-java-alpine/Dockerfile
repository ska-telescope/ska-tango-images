#
# This Dockerfile builds Tango including Java apps and libraries in an
# intermediate image, then creates a release image containing the compiled
# binaries.
#
ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE=${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.3.0
FROM $BASE_IMAGE AS buildenv

FROM $BASE_IMAGE
ENV LOG4J=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/log4j-1.2.17.tar.gz
ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz

# Install build time dependencies
RUN apk add --update --no-cache make bash sudo \
    libsodium-dev libstdc++ mariadb-connector-c-dev \
    && apk add  --no-cache --virtual mydeps git cmake \
    curl openssl ca-certificates \
    java-cacerts wget autoconf automake libtool g++ 

RUN apk --no-cache add \
    openjdk8-jre-base \
    libstdc++

# copy the built library dependencies from the builder stage
COPY --from=buildenv /usr/local /usr/local

RUN mkdir -p /usr/src/tango /usr/share/man/man1 /usr/java 
WORKDIR /usr/src/tango

## tar with tango libraries, version 9.3.4 
RUN curl -fsSL "$TANGO_DOWNLOAD_URL" -o tango.tar.gz \
    && tar xf tango.tar.gz -C /usr/src/tango --strip-components=1 \
## this tango version is old and and we need to change
## a few thingies under alpine to make it work, none of the following sed commands
## is needed for debian
## required to get log4tango to work
    && sed -i '1s/^/#include <sys\/types.h>\n#include <bits\/alltypes.h>\n/' \
    lib/cpp/log4tango/include/log4tango/FileAppender.hh \
## lib/cpp/server requires two fixes
## this is very dangerous and can lead to the zombie apocalipse
    && sed -i 's/SIGCLD/SIGCHLD/g' lib/cpp/server/dserversignal.cpp \
## this check was removed from the most recent cpptango version (after our 9.3.4),
## so we get rid of it since it is giving us an error
    && sed -i '/if (auth_signal(signo) == false)/,+7d' lib/cpp/server/dserversignal.cpp \
## the cppserver also requires two fixes
## fix include path for procfs
   && sed -i 's/<procfs.h>/<sys\/procfs.h>/g' cppserver/starter/CheckProcessUtil.h \
## this gives error but it is for solaris, so just remove the lines!
   && sed -i '/solaris/,+98d' cppserver/starter/CheckProcessUtil.cpp \
   && chmod a+x config/install-sh lib/cpp/log4tango/config/install-sh \
## enable java in configure.ac
   && sed -i '/TANGO_JAVA_ENABLED/i enable_java=yes' configure.ac \
## before we use autoconf we need to remove 4 lines from
## the configure.ac file, some issue with the check for sed
   && sed -i '/SED_AC_WORKING($SED)/,+3d' configure.ac \
   && autoconf && ./configure --with-zmq=/usr/local --with-omni=/usr/local \
    --with-mysqlclient-prefix=/usr --enable-static=no \
## we can now make it
   && make -C /usr/src/tango  -j$(nproc) \
   && make -C /usr/src/tango install \
   && rm -rf /usr/src/tango 
    
##RUN ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9
WORKDIR /usr/java

RUN wget --no-check-certificate "$LOG4J" -O log4j.tar.gz \
    && tar zxvf log4j.tar.gz \
    && mv apache-log4j-1.2.17/log4j-1.2.17.jar /usr/local/share/java/log4j-1.2.17.jar \
    && rm /usr/java/log4j.tar.gz && rm -rf apache-log4j-1.2.17 \
#  create the user tango and add it to sudoers
    && adduser -h /home/tango -s /bin/bash -D tango \
    && echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango && apk del mydeps


USER tango

