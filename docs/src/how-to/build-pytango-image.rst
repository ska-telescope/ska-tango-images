.. _build-pytango-image:

========================================
How to build a Tango image using PyTango
========================================

When building OCI images, it is recommended to use a separate build stage from
the runtime stage to avoid including build-time dependencies in the final image.

`ska-base-image <https://github.com/ska-telescope/ska-base-image>`_ provides
ska-build-python as a build image for python-based applications and can be used
for building PyTango-based application images.

For the runtime image it is recommended to use
:ref:`ska-tango-images-tango-python`. ska-tango-images-tango-python provides the
``tango_admin`` utility which is often useful to include in the image.

Dockerfile Template
-------------------

It is recommended to install your application into a python virtual environment
in the build image, then copy this environment across to the runtime image.
This can be done with the following skeleton:

.. code-block:: Dockerfile
   :substitutions:

   ARG BUILD_IMAGE=artefact.skao.int/ska-build-python:0.1.1
   ARG BASE_IMAGE=|oci-registry|/ska-tango-images-tango-python:|tango-python-imgver|
   FROM $BUILD_IMAGE as build

   ENV VIRTUAL_ENV=/app
   RUN set -xe; \
       apt-get update; \
       apt-get install -y --no-install-recommends \
           python3-venv; \
       python3 -m venv $VIRTUAL_ENV
   ENV PATH="$VIRTUAL_ENV/bin:$PATH"

   <install application into $VIRTUAL_ENV>

   FROM $BASE_IMAGE

   ENV VIRTUAL_ENV=/app
   ENV PATH="$VIRTUAL_ENV/bin:$PATH"

   COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV

   LABEL int.skao.image.team=<my-team> \
         int.skao.image.authors=<author> \
         int.skao.image.url=<gitlab url> \
         description=<description> \
         license=<license>

.. note::

   It is recommended to provide BUILD_IMAGE and BASE_IMAGE arguments rather than
   hard-coding them directly.  These arguments can be used by tools such as the
   `SKA Tango Test Bench <https://gitlab.com/ska-telescope/ska-tango-test-bench>`_ to
   test out different versions of build and base images.

Example
-------

The following Dockerfile builds a `dsconfig
<https://gitlab.com/MaxIV/lib-maxiv-dsconfig>`_ image, similar to
:ref:`ska-tango-images-tango-dsconfig`:

.. code-block:: Dockerfile
   :substitutions:

   ARG BUILD_IMAGE=artefact.skao.int/ska-build-python:|skabuildpython-version|
   ARG BASE_IMAGE=|oci-registry|/ska-tango-images-tango-python:|tango-python-imgver|
   FROM $BUILD_IMAGE as build

   ENV VIRTUAL_ENV=/app
   RUN set -xe; \
       apt-get update; \
       apt-get install -y --no-install-recommends \
           python3-venv; \
       python3 -m venv $VIRTUAL_ENV
   ENV PATH="$VIRTUAL_ENV/bin:$PATH"

   RUN pip install --no-cache-dir dsconfig==|dsconfig-version|

   FROM $BASE_IMAGE

   ENV VIRTUAL_ENV=/app
   ENV PATH="$VIRTUAL_ENV/bin:$PATH"

   COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV

   LABEL int.skao.image.team="Team Example" \
         int.skao.image.authors="an@example.com" \
         int.skao.image.url="https://gitlab.com/example" \
         description="This is just an example and these labels should be updated" \
         license="BSD-3-Clause"

To build and run an image using this example, copy the above into a file named
``Dockerfile`` and run the following commands from a terminal inside the same
directory:

.. code-block:: shell

    docker image build -t my-dsconfig .
    docker run -it my-dsconfig

This will place you in an interactive terminal for the container, which will
have the dsconfig command line tools such as json2tango installed.
