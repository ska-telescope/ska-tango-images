ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-cpp-alpine:0.0.0"
FROM $BASE_IMAGE

LABEL \
      author="Piers Harding <Piers.Harding@skao.int>" \
      description="This image illustrates build dependencies" \
      license="Apache2.0" \
      int.skao.team="Systems Team" \
      int.skao.website="https://gitlab.com/ska-telescope/sdi/ska-ser-containerisation-and-orchestration" \
      int.skao.application="Tango Builder"

USER root
# pkgconfig needs to find these
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:/usr/lib

# Install build time dependencies
# boost-dev and libstdc++ are fundamental dependencies
RUN apk --update add --no-cache libstdc++ \
    g++ \
    libsodium-dev \
    libffi-dev \
    zlib-dev \
    boost \
    boost-dev \
    bash \
    make \
    ca-certificates \
    tzdata \
    cargo \
    curl \
    git

# Python is installed from https://github.com/docker-library/python/blob/master/3.9/alpine3.15/Dockerfile
# as using apk packages cause dependency issues

ENV GPG_KEY E3FF2839C048B25C084DEBE9B26995E310250568
ENV PYTHON_VERSION 3.9.13

RUN set -eux; \
    \
    apk add --no-cache --virtual .build-deps \
    gnupg \
    tar \
    xz \
    \
    bluez-dev \
    bzip2-dev \
    dpkg-dev dpkg \
    expat-dev \
    findutils \
    gcc \
    gdbm-dev \
    libc-dev \
    libffi-dev \
    libnsl-dev \
    libtirpc-dev \
    linux-headers \
    make \
    ncurses-dev \
    openssl-dev \
    pax-utils \
    readline-dev \
    sqlite-dev \
    tcl-dev \
    tk \
    tk-dev \
    util-linux-dev \
    xz-dev \
    zlib-dev \
    ; \
    \
    wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"; \
    wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"; \
    GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"; \
    gpg --batch --verify python.tar.xz.asc python.tar.xz; \
    command -v gpgconf > /dev/null && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" python.tar.xz.asc; \
    mkdir -p /usr/src/python; \
    tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; \
    rm python.tar.xz; \
    \
    cd /usr/src/python; \
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    ./configure \
    --build="$gnuArch" \
    --enable-loadable-sqlite-extensions \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --enable-shared \
    --with-system-expat \
    --without-ensurepip \
    ; \
    nproc="$(nproc)"; \
    make -j "$nproc" \
    # set thread stack size to 1MB so we don't segfault before we hit sys.getrecursionlimit()
    # https://github.com/alpinelinux/aports/commit/2026e1259422d4e0cf92391ca2d3844356c649d0
    EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000" \
    LDFLAGS="-Wl,--strip-all" \
    ; \
    make install; \
    \
    cd /; \
    rm -rf /usr/src/python; \
    \
    find /usr/local -depth \
    \( \
    \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
    -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
    \) -exec rm -rf '{}' + \
    ; \
    \
    find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
    | tr ',' '\n' \
    | sort -u \
    | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    | xargs -rt apk add --no-network --virtual .python-rundeps \
    ; \
    apk del --no-network .build-deps; \
    \
    python3 --version

# make some useful symlinks that are expected to exist ("/usr/local/bin/python" and friends)
RUN set -eux; \
    for src in idle3 pydoc3 python3 python3-config; do \
    dst="$(echo "$src" | tr -d 3)"; \
    [ -s "/usr/local/bin/$src" ]; \
    [ ! -e "/usr/local/bin/$dst" ]; \
    ln -svT "$src" "/usr/local/bin/$dst"; \
    done

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 22.0.4
# https://github.com/docker-library/python/issues/365
ENV PYTHON_SETUPTOOLS_VERSION 58.1.0
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/5eaac1050023df1f5c98b173b248c260023f2278/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 5aefe6ade911d997af080b315ebcb7f882212d070465df544e1175ac2be519b4

RUN set -eux; \
    \
    wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
    echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum -c -; \
    \
    export PYTHONDONTWRITEBYTECODE=1; \
    \
    python get-pip.py \
    --disable-pip-version-check \
    --no-cache-dir \
    --no-compile \
    "pip==$PYTHON_PIP_VERSION" \
    "setuptools==$PYTHON_SETUPTOOLS_VERSION" \
    ; \
    rm -f get-pip.py; \
    \
    pip --version

ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages
# setup pip ready for package installs
COPY pip.conf /etc/pip.conf
WORKDIR /app
COPY requirements.txt requirements.txt

# Install numpy manually before PyTango and other requirements to ensure we
# build PyTango with numpy support.
RUN python3.9 -m pip install --prefix=/usr/local wheel numpy==1.21.0 \
# now install build requirements
    && python3.9 -m pip install --prefix=/usr/local -r requirements.txt \
# this should be commented if we wish for the builder
# to keep the python cache
    && python3.9 -m pip cache purge

# do ldconfig stuff
RUN mkdir -p /etc/ld.so.conf.d \
    && echo "include /etc/ld.so.conf.d/*.conf" > /etc/ld.so.conf \
    && echo "/usr/local/lib" > /etc/ld.so.conf.d/tango.conf \
    && echo "/usr/local/lib64" > /etc/ld.so.conf.d/tango.conf \
    && ldconfig /etc/ld.so.conf.d \
# this was on the debian version
    && mkdir /venv \
    && ln -s /usr/* /venv/  \
    && ln -s /usr/local/bin/itango3 /venv/bin/itango3 \
    && ln -s /usr/bin/python3 /venv/bin/python 
