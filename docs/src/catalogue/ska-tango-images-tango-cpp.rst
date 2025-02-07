.. _ska-tango-images-tango-cpp:

==========================
ska-tango-images-tango-cpp
==========================

Build image to be used for cppTango-based applications.

Summary
-------

Release |version| of ska-tango-images provides the |tango-cpp-imgver| tag of
the ska-tango-images-tango-cpp OCI image.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - cppTango
     - |cpptango-version|
   * - ZeroMQ
     - |zeromq-version|
   * - omniORB
     - |omniorb-version|
   * - opentelemetry-cpp
     - |otel-version|

Usage
-----

ska-tango-images-tango-cpp includes software required to build Tango
applications based on cppTango.  Note that this image is not intended to be used
as the base of a runtime image.  It is recommended to copy the results of the
build process into a base image to create a dedicated runtime image. See
:ref:`build-cpptango-image` for details about how to build your own Tango
application images.

A list of the system runtime dependencies required to run applications linked to
``libtango.so`` can be found in ``/runtime_deps.txt``.  To install these
libraries into your runtime image, add the following to your Dockerfile, which
assumes your build stage based on ska-tango-images-tango-cpp is called 'build':

.. code-block:: Dockerfile

  COPY --from=build /runtime_deps.txt /runtime_deps.txt
  RUN set -xe; \
      apt-get update; \
      xargs apt-get install -y --no-install-recommends < /runtime_deps.txt; \
      rm -rf /var/lib/apt/lists/*

This has been done already in :ref:`ska-tango-images-tango-base`, so is not
required if you are using this, or :ref:`ska-tango-images-tango-admin` as a base
runtime image.
