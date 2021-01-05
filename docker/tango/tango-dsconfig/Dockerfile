ARG DOCKER_REGISTRY_USER
ARG DOCKER_REGISTRY_HOST
FROM ${DOCKER_REGISTRY_HOST}/${DOCKER_REGISTRY_USER}/tango-cpp:9.3.4-rc7

USER root

RUN runtimeDeps='libboost-python1.67.0 \
		build-essential \
        ca-certificates \
		make \
		curl \
        libboost-python-dev \
        pkg-config \
        git \
		python3 \
        python3-dev \
		python3-distutils' \
    && DOCKERHOST=`awk '/^[a-z]+[0-9]+\t00000000/ { printf("%d.%d.%d.%d", "0x" substr($3, 7, 2), "0x" substr($3, 5, 2), "0x" substr($3, 3, 2), "0x" substr($3, 1, 2)) }' < /proc/net/route` \
    && /usr/local/bin/wait-for-it.sh --host=$DOCKERHOST --port=3142 --timeout=3 --strict --quiet -- echo "Acquire::http::Proxy \"http://$DOCKERHOST:3142\";" > /etc/apt/apt.conf.d/30proxy \
    && echo "Proxy detected on docker host - using for this build" || echo "No proxy detected on docker host" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get -y install --no-install-recommends $runtimeDeps \
    && rm -rf /var/lib/apt/lists/* /etc/apt/apt.conf.d/30proxy

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
COPY pip.conf /etc/pip.conf

RUN python3 -m pip install wheel numpy==1.16.6

RUN python3 -m pip install --extra-index-url https://nexus.engageska-portugal.pt/repository/pypi/simple python-dsconfig==1.5.0

COPY json2tango .
ENV PATH $PATH:/json2tango
# RUN chmod +x ./json2tango.sh if needed
