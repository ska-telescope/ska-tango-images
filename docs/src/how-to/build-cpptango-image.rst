.. _build-cpptango-image:

=========================================
How to build a Tango image using cppTango
=========================================

When building OCI images, it is recommended to use a separate build stage from
the runtime stage to avoid including build-time dependencies in the final image.

ska-tango-images provides :ref:`ska-tango-images-tango-cpp` as a build image for
cppTango-based applications.

For the runtime image it is recommended to use either
:ref:`ska-tango-images-tango-admin` or :ref:`ska-tango-images-tango-base`.
ska-tango-images-tango-admin provides the ``tango_admin`` utility which
is often useful to include in the image, however, if this utility is not
required ska-tango-images-tango-base is provided as a leaner alternative.

Dockerfile Template
-------------------

The following Dockerfile template can be used to build a C++ application linking
against ``libtango.so``, using the :ref:`ska-tango-images-tango-admin` base image:

.. code-block:: Dockerfile
   :substitutions:

   ARG BUILD_IMAGE=|oci-registry|/ska-tango-images-tango-cpp:|tango-cpp-imgver|
   ARG BASE_IMAGE=|oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver|
   FROM $BUILD_IMAGE as build

   <build and install application>

   FROM $BASE_IMAGE
   COPY --from=build </path/to/installed/application> /usr/local/bin

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

The ``libtango.so`` library can be found at ``/usr/local/lib/libtango.so`` in
both :ref:`ska-tango-images-tango-admin` and :ref:`ska-tango-images-tango-cpp`.
This will need to be found at both build-time and runtime, if using CMake to
build your C++ application, this can be achieved by passing
``-DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib`` to
``cmake`` at configure time.

.. warning::

   :ref:`ska-tango-images-tango-base` does not include ``libtango.so`` or any of
   its dependencies.  In addition to your Tango application, these must be
   copied into the runtime image with the following line in your Dockerfile:

   .. code-block::

      COPY --from=build /usr/local/lib/lib*.so* /usr/local/lib/

Example
-------

The following Dockerfile builds a `TangoTest
<https://gitlab.com/tango-controls/TangoTest>`_ image using
:ref:`ska-tango-images-tango-base` as a base image rather than
:ref:`ska-tango-images-tango-admin`, which is used by
:ref:`ska-tango-images-tango-test`.

.. code-block:: Dockerfile
   :substitutions:

   ARG BUILD_IMAGE=|oci-registry|/ska-tango-images-tango-cpp:|tango-cpp-imgver|
   ARG BASE_IMAGE=|oci-registry|/ska-tango-images-tango-base:|tango-base-imgver|
   FROM $BUILD_IMAGE as build

   RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        cmake \
        git

   RUN set -xe; \
       git clone --depth=1 --branch=|tangotest-version| --recursive -c advice.detachedHead=false \
           https://gitlab.com/tango-controls/TangoTest.git /usr/src/TangoTest;  \
       cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_INSTALL_RPATH=/usr/local/lib; \
       make  -j$(nproc) -Cbuild install

   FROM $BASE_IMAGE
   COPY --from=build /usr/local/lib/lib*.so* /usr/local/lib/
   COPY --from=build /usr/local/bin/TangoTest /usr/local/bin

   LABEL int.skao.image.team="Team Example" \
         int.skao.image.authors="an@example.com" \
         int.skao.image.url="https://gitlab.com/example" \
         description="This is just an example and these labels should be updated" \
         license="BSD-3-Clause"

To build and run an image using this example, copy the above into a file named
``Dockerfile`` and run the following commands from a terminal inside the same
directory:

.. code-block:: bash

    docker image build -t my-tango-test .
    docker run --env TANGO_HOST=$TANGO_HOST --net=host my-tango-test test

This will launch a TangoTest device server connecting to your TANGO_HOST.
