ARG CAR_OCI_REGISTRY_USERNAME
ARG CAR_OCI_REGISTRY_HOST

FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_USERNAME}/pytango-builder:9.3.3.1 as buildenv
FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_USERNAME}/pytango-runtime:9.3.3.1

RUN python3 -m pip install python-dsconfig==1.5.0

# Existing Helm charts assume tango-dsconfig starts in the root directory
WORKDIR /
