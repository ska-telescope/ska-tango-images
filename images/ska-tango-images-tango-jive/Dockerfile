ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java:local"
FROM $BASE_IMAGE

LABEL int.skao.image.team="Team Wombat" \
      int.skao.image.url="https://gitlab.com/ska-telescope/ska-tango-images" \
      int.skao.image.source="images/ska-tango-images-tango-jive/Dockerfile" \
      int.skao.application="Tango Jive" \
      description="Contains the jive application from the Tango controls collaboration" \
      license="BSD-3-Clause"

ENTRYPOINT ["/usr/local/bin/jive"]
