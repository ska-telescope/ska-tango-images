ARG DOCKER_REGISTRY_USER
ARG DOCKER_REGISTRY_HOST

FROM ${DOCKER_REGISTRY_HOST}/${DOCKER_REGISTRY_USER}/ska-python-buildenv:9.3.3.1 as buildenv
FROM ${DOCKER_REGISTRY_HOST}/${DOCKER_REGISTRY_USER}/ska-python-runtime:9.3.3.1

RUN python3 -m pip install python-dsconfig==1.5.0

COPY json2tango .
ENV PATH /app:$PATH
