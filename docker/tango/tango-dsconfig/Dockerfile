ARG CAR_OCI_REGISTRY_HOST

FROM ${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder:9.3.9 as buildenv
FROM ${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-runtime:9.3.9

RUN python3 -m pip install python-dsconfig==1.5.0

# Existing Helm charts assume tango-dsconfig starts in the root directory
WORKDIR /
