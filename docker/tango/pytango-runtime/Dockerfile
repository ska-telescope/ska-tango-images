#
# This Dockerfile creates a Docker image intended to be a base runtime for SKA
# python projects. This image should be used as an intermediate layer
# alongside the pytango-builder image.
#
ARG CAR_PYPI_REPOSITORY_URL
ARG CAR_OCI_REGISTRY_HOST
FROM ${CAR_OCI_REGISTRY_HOST}/ska-tango-images/pytango-builder:9.3.4 as buildenv

FROM ${CAR_OCI_REGISTRY_HOST}/ska-tango-images/tango-cpp:9.3.5
USER root
ENV PIP_INDEX_URL=${CAR_PYPI_REPOSITORY_URL}
# Permanently install Python and PyTango runtime dependencies:
#
# * libboost-python is required by PyTango;
# * make is required to manage execution of the tests inside the container
# * python3 is required as this image is intended for running Python Tango
#   devices.
#
RUN runtimeDeps='libboost-python1.67.0 \
		ca-certificates \
		make \
		curl \
		python3 \
		python3-distutils' \
    && DOCKERHOST=`awk '/^[a-z]+[0-9]+\t00000000/ { printf("%d.%d.%d.%d", "0x" substr($3, 7, 2), "0x" substr($3, 5, 2), "0x" substr($3, 3, 2), "0x" substr($3, 1, 2)) }' < /proc/net/route` \
    && /usr/local/bin/wait-for-it.sh --host=$DOCKERHOST --port=3142 --timeout=3 --strict --quiet -- echo "Acquire::http::Proxy \"http://$DOCKERHOST:3142\";" > /etc/apt/apt.conf.d/30proxy \
    && echo "Proxy detected on docker host - using for this build" || echo "No proxy detected on docker host" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get -y install --no-install-recommends $runtimeDeps \
    && rm -rf /var/lib/apt/lists/* /etc/apt/apt.conf.d/30proxy

# Copy across files that are used to help orchestrate container compositions
# and test execution sequences
COPY --from=buildenv /usr/local/bin/wait-for-it.sh /usr/local/bin/wait-for-it.sh
COPY --from=buildenv /usr/local/bin/retry /usr/local/bin/retry
COPY --from=buildenv /usr/local/lib/python3.7 /usr/local/lib/python3.7

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py
COPY pip.conf /etc/pip.conf

RUN mkdir /venv && ln -s /usr/* /venv/ && ln -s /usr/bin/python3 /venv/bin/python && ln -s /usr/local/bin/itango3 /venv/bin/itango3

USER tango
ENV PIP_INDEX_URL=${CAR_PYPI_REPOSITORY_URL}
ENV PATH="/home/tango/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}"

ONBUILD COPY --chown=tango:tango . /app
ONBUILD COPY --from=buildenv /usr/local/bin/ /usr/local/bin/
ONBUILD WORKDIR /app
