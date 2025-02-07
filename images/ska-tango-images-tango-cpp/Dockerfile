ARG SKABUILD_VERSION
ARG BUILD_IMAGE="artefact.skao.int/ska-build:${SKABUILD_VERSION}"

FROM $BUILD_IMAGE AS build_system_deps
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libc-ares-dev \
        libcurl4-openssl-dev \
        libjpeg8-dev \
        libre2-dev \
        libssl-dev \
        libzstd-dev \
        nlohmann-json3-dev; \
    rm -rf /var/lib/apt/lists/*; \
    echo libc-ares2 >> /runtime_deps.txt; \
    echo libcurl4   >> /runtime_deps.txt; \
    echo libjpeg8   >> /runtime_deps.txt; \
    echo libre2-9   >> /runtime_deps.txt; \
    echo libssl3    >> /runtime_deps.txt; \
    echo libzstd1   >> /runtime_deps.txt

FROM build_system_deps AS build_tools
ARG DEBIAN_FRONTEND=noninteractive

RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        cmake \
        curl \
        file \
        git \
        libtool \
        pkg-config \
        unzip; \
    rm -rf /var/lib/apt/lists/*

FROM build_tools AS build_zmq
ARG ZEROMQ_VERSION

ENV ZEROMQ_DOWNLOAD_URL="https://github.com/zeromq/libzmq/archive/v${ZEROMQ_VERSION}.tar.gz"

RUN mkdir /usr/src/zeromq
WORKDIR /usr/src/zeromq
RUN set -xe; \
    curl -kfsSL "$ZEROMQ_DOWNLOAD_URL" -o zeromq.tar.gz; \
    tar xf zeromq.tar.gz -C /usr/src/zeromq --strip-components=1; \
    ./autogen.sh; \
    ./configure --enable-static=no; \
    make -C /usr/src/zeromq -j$(nproc); \
    make -C /usr/src/zeromq install

FROM build_zmq AS build_cppzmq
ARG CPPZMQ_VERSION

ENV CPPZMQ_DOWNLOAD_URL="https://github.com/zeromq/cppzmq/archive/v${CPPZMQ_VERSION}.tar.gz"

RUN mkdir /usr/src/cppzmq
WORKDIR /usr/src/cppzmq
RUN set -xe; \
    curl -kfsSL "$CPPZMQ_DOWNLOAD_URL" -o cppzmq.tar.gz; \
    tar xf cppzmq.tar.gz -C /usr/src/cppzmq --strip-components=1; \
    cmake -Bbuild -S. -DCPPZMQ_BUILD_TESTS=OFF; \
    cmake --build build --target install

FROM build_tools AS build_omniorb
ARG OMNIORB_VERSION

ENV OMNIORB_DOWNLOAD_URL="https://sourceforge.net/projects/omniorb/files/omniORB/omniORB-${OMNIORB_VERSION}/omniORB-${OMNIORB_VERSION}.tar.bz2/download"

RUN mkdir /usr/src/omniorb
WORKDIR /usr/src/omniorb
RUN set -xe; \
    curl -kfsSL "$OMNIORB_DOWNLOAD_URL" -o omniorb.tar.bz2; \
    tar xf omniorb.tar.bz2 -C /usr/src/omniorb --strip-components=1; \
    ./configure --enable-static=no --disable-longdouble; \
    make -C /usr/src/omniorb -j$(nproc); \
    make -C /usr/src/omniorb install

FROM build_tools AS build_abseil
ARG ABSEIL_VERSION

ENV ABSEIL_DOWNLOAD_URL="https://github.com/abseil/abseil-cpp/archive/refs/tags/${ABSEIL_VERSION}.tar.gz"

RUN mkdir /usr/src/abseil
WORKDIR /usr/src/abseil
RUN set -xe; \
    curl -kfsSL "$ABSEIL_DOWNLOAD_URL" -o abseil.tar.gz; \
    tar xf abseil.tar.gz -C /usr/src/abseil --strip-components=1; \
    cmake -S. -Bbuild \
      -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_RPATH=/usr/local/lib \
      -DABSL_ENABLE_INSTALL=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON \
      -DABSL_PROPAGATE_CXX_STD=ON; \
    make -Cbuild -j$(nproc) install; \
    rm -r /usr/src/abseil

FROM build_abseil AS build_protobuf
ARG PROTOBUF_VERSION

ENV PROTOBUF_DOWNLOAD_URL="https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_VERSION}.tar.gz"

RUN mkdir /usr/src/protobuf
WORKDIR /usr/src/protobuf
RUN set -xe; \
    curl -kfsSL "$PROTOBUF_DOWNLOAD_URL" -o protobuf.tar.gz; \
    tar xf protobuf.tar.gz -C /usr/src/protobuf --strip-components=1; \
    cmake -S. -Bbuild \
      -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_RPATH=/usr/local/lib \
      -Dprotobuf_ABSL_PROVIDER=package \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON \
      -Dprotobuf_BUILD_EXAMPLES=OFF; \
    make -Cbuild -j$(nproc) install; \
    rm -r /usr/src/protobuf

FROM build_protobuf AS build_grpc
ARG GRPC_VERSION

ENV GRPC_DOWNLOAD_URL="https://github.com/grpc/grpc/archive/refs/tags/v${GRPC_VERSION}.tar.gz"

RUN mkdir /usr/src/grpc
WORKDIR /usr/src/grpc
RUN set -xe; \
    curl -kfsSL "$GRPC_DOWNLOAD_URL" -o grpc.tar.gz; \
    tar xf grpc.tar.gz -C /usr/src/grpc --strip-components=1; \
    cmake -S. -Bbuild \
      -DgRPC_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_RPATH=/usr/local/lib \
      -DgRPC_ABSL_PROVIDER=package -DgRPC_CARES_PROVIDER=package \
      -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_RE2_PROVIDER=package \
      -DgRPC_SSL_PROVIDER=package -DgRPC_ZLIB_PROVIDER=package \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON \
      -DgRPC_INSTALL=ON; \
    make -Cbuild -j$(nproc) install; \
    rm -r /usr/src/grpc

FROM build_grpc AS build_otel
ARG OTEL_VERSION
ARG OTEL_PROTO_VERSION

ENV OTEL_DOWNLOAD_URL="https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v${OTEL_VERSION}.tar.gz"
ENV OTEL_PROTO_DOWNLOAD_URL="https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v${OTEL_PROTO_VERSION}.tar.gz"

RUN mkdir /usr/src/otel
RUN mkdir /usr/src/otel-proto
WORKDIR /usr/src/otel
RUN set -xe; \
    curl -kfsSL "$OTEL_PROTO_DOWNLOAD_URL" -o otel-proto.tar.gz; \
    tar xf otel-proto.tar.gz -C /usr/src/otel-proto --strip-components=1; \
    curl -kfsSL "$OTEL_DOWNLOAD_URL" -o otel.tar.gz; \
    tar xf otel.tar.gz -C /usr/src/otel --strip-components=1; \
    cmake -S. -Bbuild \
      -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_RPATH=/usr/local/lib -DOPENTELEMETRY_INSTALL=ON \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=ON \
      -DOTELCPP_PROTO_PATH=/usr/src/otel-proto \
      -DWITH_OTLP_GRPC=ON -DWITH_OTLP_HTTP=ON -DWITH_ABSEIL=ON \
      -DWITH_BENCHMARK=OFF -DWITH_EXAMPLES=OFF -DWITH_FUNC_TESTS=OFF; \
    make -Cbuild -j$(nproc) install; \
    rm -r /usr/src/otel

FROM build_tools AS build_tango
ARG TANGOIDL_VERSION
ARG CPPTANGO_VERSION

COPY --from=build_cppzmq /usr/local /usr/local
COPY --from=build_omniorb /usr/local /usr/local
COPY --from=build_otel /usr/local /usr/local

RUN mkdir -p /usr/src/idl
WORKDIR /usr/src/idl
RUN set -xe; \
    git clone --depth=1 --branch=${TANGOIDL_VERSION} -c advice.detachedHead=false \
        https://gitlab.com/tango-controls/tango-idl.git /usr/src/idl; \
    cmake -B /usr/src/idl/build -DCMAKE_INSTALL_PREFIX=/usr/local/ /usr/src/idl; \
    cmake --build /usr/src/idl/build  -j$(nproc) --target install

RUN mkdir -p /usr/src/tango
WORKDIR /usr/src/tango
RUN set -xe; \
    git clone --depth=1 --branch=${CPPTANGO_VERSION} --recurse-submodules --shallow-submodules \
        -c advice.detachedHead=false https://gitlab.com/tango-controls/cppTango.git /usr/src/tango; \
    cmake -S. -Bbuild \
        -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON \
        -DTANGO_USE_TELEMETRY=ON -DTANGO_TELEMETRY_USE_HTTP=ON -DTANGO_TELEMETRY_USE_GRPC=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
    cmake --build /usr/src/tango/build -j$(nproc) --target install

FROM build_system_deps AS final
ARG DEBIAN_FRONTEND=noninteractive

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.authors="oci-support@skao.int" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-cpp/Dockerfile" \
      description="Build image for building cppTango applications" \
      license="BSD-3-Clause"

COPY --from=build_tango /usr/local /usr/local
