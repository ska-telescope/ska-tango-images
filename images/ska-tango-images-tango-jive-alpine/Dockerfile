ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-java-alpine:0.0.0"
FROM $BASE_IMAGE

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image includes the Jive GUI application of the TANGO-controls framework" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-jive" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango Jive"

ENTRYPOINT ["/usr/local/bin/jive"]
