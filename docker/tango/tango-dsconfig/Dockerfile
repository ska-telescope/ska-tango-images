ARG CAR_OCI_REGISTRY_PREFIX
ARG CAR_OCI_REGISTRY_HOST

FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_PREFIX}/pytango-builder:9.3.3.3 as buildenv
FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_PREFIX}/pytango-runtime:9.3.3.3

RUN python3 -m pip install python-dsconfig==1.5.0

# Existing Helm charts assume tango-dsconfig starts in the root directory
WORKDIR /
