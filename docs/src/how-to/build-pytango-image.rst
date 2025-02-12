.. _build-pytango-image:

========================================
How to build a Tango image using PyTango
========================================

When building OCI images, it is recommended to use a separate build stage from
the runtime stage to avoid including build-time dependencies in the final image.

`ska-base-images <https://gitlab.com/ska-telescope/ska-base-images>`_ provides
ska-build-python as a build image for python-based applications and can be used
for building PyTango-based application images.

For the runtime image it is recommended to use
:ref:`ska-tango-images-tango-python`. ska-tango-images-tango-python provides the
``tango_admin`` utility which is often useful to include in the image.

Dockerfile Template
-------------------

It is recommended to install your application into a python virtual environment
in the build image, then copy this environment across to the runtime image.

For PyTango applications that can be installed via pip, this can be done with
the following skeleton:

.. code-block:: Dockerfile
   :substitutions:

   ARG BUILD_IMAGE=artefact.skao.int/ska-build-python:|skabuildpython-version|
   ARG BASE_IMAGE=|oci-registry|/ska-tango-images-tango-python:|tango-python-imgver|
   FROM $BUILD_IMAGE AS build

   ENV VIRTUAL_ENV=/app
   RUN set -xe; \
       apt-get update; \
       apt-get install -y --no-install-recommends \
           python3-venv; \
       python3 -m venv $VIRTUAL_ENV
   ENV PATH="$VIRTUAL_ENV/bin:$PATH"

   # install application into $VIRTUAL_ENV

   # We don't want to copy pip into the runtime image
   RUN pip uninstall -y pip

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

Dockerfile Template for poetry applications
-------------------------------------------

To build an image containing a local application managed by poetry, you could
use the following skeleton to have poetry install the application into the
virtual environment:

.. code-block:: Dockerfile
   :substitutions:

   ARG BUILD_IMAGE=artefact.skao.int/ska-build-python:|skabuildpython-version|
   ARG BASE_IMAGE=|oci-registry|/ska-tango-images-tango-python:|tango-python-imgver|
   FROM $BUILD_IMAGE AS build

   ENV VIRTUAL_ENV=/app \
       POETRY_NO_INTERACTION=1 \
       POETRY_VIRTUALENVS_IN_PROJECT=1

   RUN set -xe; \
       apt-get update; \
       apt-get install -y --no-install-recommends \
           python3-venv; \
       python3 -m venv $VIRTUAL_ENV; \
       mkdir /build; \
       ln -s $VIRTUAL_ENV /build/.venv
   ENV PATH=$VIRTUAL_ENV/bin:$PATH

   WORKDIR /build

   # We install the dependencies and the application in two steps so that the
   # dependency installation can be cached by the OCI image builder.  The
   # important point is to install the dependencies _before_ we copy in src so
   # that changes to the src directory to not result in needlessly reinstalling the
   # dependencies.

   # Installing the dependencies into /app here relies on the .venv symlink created
   # above.  We use poetry to install the dependencies so that we can pass
   # `--only main` to avoid installing dev dependencies.  This option is not
   # available for pip.
   COPY pyproject.toml poetry.lock* ./
   RUN poetry install --only main --no-root --no-directory

   # The README.md here must match the `tool.poetry.readme` key in the
   # pyproject.toml otherwise the `pip install` step below will fail.
   COPY README.md ./
   COPY src ./src

   # We use pip to install the application because `poetry install` is
   # equivalent to `pip install --editable` which creates symlinks to the src
   # directory, whereas we want to copy the files.
   RUN pip install --no-deps .

   # We don't want to copy pip into the runtime image
   RUN pip uninstall -y pip

   FROM $BASE_IMAGE

   ENV VIRTUAL_ENV=/app
   ENV PATH="$VIRTUAL_ENV/bin:$PATH"

   COPY --from=build $VIRTUAL_ENV $VIRTUAL_ENV

   LABEL int.skao.image.team=<my-team> \
         int.skao.image.authors=<author> \
         int.skao.image.url=<gitlab url> \
         description=<description> \
         license=<license>

Example
-------

The following Dockerfile builds a `dsconfig
<https://gitlab.com/MaxIV/lib-maxiv-dsconfig>`_ image, similar to
:ref:`ska-tango-images-tango-dsconfig`, except without pinning the versions:

.. code-block:: Dockerfile
   :substitutions:

   ARG BUILD_IMAGE=artefact.skao.int/ska-build-python:|skabuildpython-version|
   ARG BASE_IMAGE=|oci-registry|/ska-tango-images-tango-python:|tango-python-imgver|
   FROM $BUILD_IMAGE AS build

   ENV VIRTUAL_ENV=/app
   RUN set -xe; \
       apt-get update; \
       apt-get install -y --no-install-recommends \
           python3-venv; \
       python3 -m venv $VIRTUAL_ENV
   ENV PATH="$VIRTUAL_ENV/bin:$PATH"

   RUN pip install --no-cache-dir dsconfig

   # We don't want to copy pip into the runtime image
   RUN pip uninstall -y pip

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

.. code-block:: bash

    docker image build -t my-dsconfig .
    docker run -it my-dsconfig

This will place you in an interactive terminal for the container, which will
have the dsconfig command line tools such as json2tango installed.

