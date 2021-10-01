ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="python:3.9.6-alpine3.14"
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-dependencies-alpine:0.2.2"
FROM $BUILD_IMAGE AS buildenv

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates libtool \
    file mariadb-connector-c-dev pkgconf-dev \
    python3-dev make czmq-dev autoconf automake \
    libffi-dev openssl-dev boost-dev bash

RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake
    

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango

## tar with tango libraries, version 9.3.4 
ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz
RUN curl -fsSL "$TANGO_DOWNLOAD_URL" -o tango.tar.gz \
    && tar xf tango.tar.gz -C /usr/src/tango --strip-components=1

## this tango version is old and and we need to change
## a few thingies under alpine to make it work, none of the following sed commands
## is needed for debian

## required to get log4tango to work
RUN sed -i '1s/^/#include <sys\/types.h>\n#include <bits\/alltypes.h>\n/' \
    lib/cpp/log4tango/include/log4tango/FileAppender.hh 

## lib/cpp/server requires two fixes
## this is very dangerous and can lead to the zombie apocalipse
RUN sed -i 's/SIGCLD/SIGCHLD/g' lib/cpp/server/dserversignal.cpp 
## this check was removed from the most recent cpptango version (after our 9.3.4),
## so we get rid of it since it is giving us an error
RUN sed -i '/if (auth_signal(signo) == false)/,+7d' lib/cpp/server/dserversignal.cpp

## the cppserver also requires two fixes
## fix include path for procfs
RUN sed -i 's/<procfs.h>/<sys\/procfs.h>/g' cppserver/starter/CheckProcessUtil.h 
## this gives error but it is for solaris, so just remove the lines!
RUN sed -i '/solaris/,+98d' cppserver/starter/CheckProcessUtil.cpp

RUN chmod a+x config/install-sh lib/cpp/log4tango/config/install-sh
## before we use autoconf we need to remove 4 lines from
## the configure.ac file, some issue with the check for sed
RUN sed -i '/SED_AC_WORKING($SED)/,+3d' configure.ac \
    && autoconf && ./configure --with-zmq=/usr/local --with-omni=/usr/local \
    --with-mysqlclient-prefix=/usr --enable-static=no 
## we can now make it
RUN make -C /usr/src/tango  -j$(nproc) 
RUN make -C /usr/src/tango install 
##RUN ldconfig

# Now, create the final image minus the tools and source code
FROM $BASE_IMAGE 
LABEL \
      author="Piers Harding <Piers.Harding@skao.int>" \
      description="This image illustrates build dependencies" \
      license="Apache2.0" \
      int.skao.team="Systems Team" \
      int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
      int.skao.application="Tango CPP"

# copy the built library dependencies from the builder stage
COPY --from=buildenv /usr/local /usr/local

RUN apk add --update --no-cache mariadb-connector-c musl-utils sudo bash

##RUN ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9

# create the user tango and add it to sudoers
RUN adduser -h /home/tango -D tango && \
    echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango

USER tango
