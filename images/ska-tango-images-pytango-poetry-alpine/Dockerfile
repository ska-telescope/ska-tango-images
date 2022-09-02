ARG CAR_OCI_REGISTRY_HOST
ARG BUILD_IMAGE="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-builder-alpine:0.0.0"
ARG BASE_IMAGE="alpine:3.15"

FROM $BUILD_IMAGE AS buildenv
FROM $BASE_IMAGE

LABEL \
      author="Malte Marquarding <malte.marquarding@csiro.au>" \
      description="This image includes poetry and pre-build tango dependencies" \
      license="BSD-3-Clause" \
      registry="${CAR_OCI_REGISTRY_HOST}/ska-tango-images-pytango-poetry-alpine" \
      org.skatelescope.team="Systems Team" \
      org.skatelescope.version="1.0.0" \
      int.skao.application="PyTango run time package"
      
# Install run-time dependencies for poetry, tango and friends
RUN apk add --update --no-cache sudo curl bash ca-certificates \
    boost1.77-python3 make libsodium pkgconfig

# get poetry, tango and friends
COPY --from=buildenv /usr/local /usr/local
# get prebuilt tango and boost wheels to be used in poetry
COPY --from=buildenv /wheels /wheels

# make image smaller by removing cruft
# omniidl live in /usr/local/lib/python3.9 but isn't used
RUN find /usr/local -name '\*.a' -delete && rm /usr/local/bin/Data* && \
    rm -rf /usr/local/lib/python3.9


# tango user stuff
RUN adduser -h /home/tango -s /bin/bash -D tango \
    && echo "tango ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tango
USER tango
WORKDIR /home/tango
RUN poetry config repositories.skao https://artefact.skao.int/repository/pypi-internal/simple && \
    poetry config virtualenvs.create false
# poetry's non-virtualenv user install directory
ENV PATH=/home/tango/.local/bin:${PATH}

ONBUILD COPY --chown=tango:tango . /app
ONBUILD WORKDIR /app

RUN echo "use 'poetry add /wheels/*.whl' to use tango in your poetry project"
