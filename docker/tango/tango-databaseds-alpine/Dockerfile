ARG CAR_OCI_REGISTRY_HOST
FROM ${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-libtango-alpine:0.1.0

LABEL \
      author="Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the tango databaseds from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-db" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango Databaseds"

ENTRYPOINT ["/usr/local/bin/DataBaseds"]

CMD ["2", "-ORBendPoint", "giop:tcp::10000"]
