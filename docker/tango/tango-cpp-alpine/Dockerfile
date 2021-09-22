ARG BASE_IMAGE="python:3.8.10-alpine3.13"
FROM $BASE_IMAGE AS buildenv

ENV TANGO_DOWNLOAD_URL=https://artefact.skao.int/repository/raw-internal/ska-tango-images/libraries/tango-9.3.4.tar.gz

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY retry.sh /usr/local/bin/retry.sh

# Install build time dependencies
RUN apk add --update --no-cache curl \
    openssl ca-certificates \
    file mariadb-connector-c-dev pkgconf-dev \
    g++ python3-dev make czmq-dev python \
    libffi-dev openssl-dev boost-dev
    
RUN apk add --virtual build-dependencies \
    build-base alpine-sdk \
    linux-headers \
    git cmake

# build and install libzmq at v4.2.0
RUN git clone -b v4.2.0 --depth 1 https://github.com/zeromq/libzmq /libzmq && \
    cmake -B /libzmq/build -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_DRAFTS=OFF -DWITH_DOC=OFF -DZMQ_BUILD_TESTS=OFF /libzmq  && \
    make -C /libzmq/build install

# build and install cpp zmq at v4.2.3
RUN git clone -b v4.2.3 --depth 1 https://github.com/zeromq/cppzmq.git /cppzmq && \
    cmake -B /cppzmq/build -DCPPZMQ_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=/usr/local /cppzmq && \
    make -C /cppzmq/build install
    
# build and install omniORB at 4.2.4
RUN curl -L https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2/download -o /omniORB.tar.bz2 && \
    mkdir /omniORB && \
    tar xaf /omniORB.tar.bz2 --strip-components=1 -C /omniORB && \
    cd /omniORB && \
    ./configure --prefix=/usr/local/ && \
    make && \
    make install

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango
RUN curl -fsSL "$TANGO_DOWNLOAD_URL" -o tango.tar.gz \
    && tar xf tango.tar.gz -C /usr/src/tango --strip-components=1 \
    && ./configure --with-zmq=/usr/local --with-omni=/usr/local --with-mysqlclient-prefix=/usr --enable-static=no \
    && make -C /usr/src/tango -j$(nproc) \
    && make -C /usr/src/tango install \
    && ldconfig \
    && rm -r /usr/src/tango
    
# Now, create the final image minus the tools and source code
ARG BASE_IMAGE="python:3.8.10-alpine3.13"
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

RUN apk add --update --no-cache libmariadb3 mariadb-connector-c musl-utils sudo

RUN ln -s /usr/local/lib/libtango.so.9.4.0 /usr/local/lib/libtango.so.9

RUN adduser -h /home/tango -D tango
RUN echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango \
    && chmod 0440 /etc/sudoers.d/tango
    
USER tango

