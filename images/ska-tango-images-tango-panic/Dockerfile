ARG CAR_OCI_REGISTRY_HOST
ARG BASE_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder:9.3.6"
FROM $BASE_IMAGE

LABEL \
      author="Andrew Bolin <andrew.bolin@csiro.au>, Matteo Di Carlo <matteo.dicarlo@inaf.it>" \
      description="This image is the Panic application available from the TANGO-community" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-tango-panic" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="Tango Panic"

# # # NOTES
# - pip2 crashes if the package we want isn't in the SKA repo,
#     so we temporarily hide the SKA pip.conf
# - exim4 is used for email alerts (configuration to be applied by user)
# - Format of boost library name was apparently changed between 1.65 and 1.67,
#     so we make a symlink
# - panic uses python 2, but 'python' maps to python3 in our base image,
#     so we use sed to edit the PyAlarm launcher
ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN mv /etc/pip.conf /tmp/ska_pip_conf

RUN apt-get update && \
    apt-get -y install python2.7 \
        python-pip \
        exim4

RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_python27.so /usr/lib/x86_64-linux-gnu/libboost_python-py27.so && \
    pip2 install panic

RUN mv /tmp/ska_pip_conf /etc/pip.conf
RUN sed -i.original 's/python/python2/g' `which PyAlarm`

COPY aliases /etc/
COPY update-exim4.conf.conf /etc/exim4/
COPY entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
