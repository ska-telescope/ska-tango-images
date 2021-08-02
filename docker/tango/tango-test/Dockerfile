ARG CAR_OCI_REGISTRY_HOST
FROM ${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-libtango:9.3.5

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the tango-test application available from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-test" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango TEST"

ENTRYPOINT ["/usr/local/bin/TangoTest"]
