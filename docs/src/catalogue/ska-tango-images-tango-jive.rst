.. _ska-tango-images-tango-jive:

===========================
ska-tango-images-tango-jive
===========================

This image contains `jive
<https://gitlab.com/tango-controls/jive>`_.  ``jive`` is a GUI which can
be used to inspect your Tango control system.

Summary
-------

Release |version| of ska-tango-images provides the |tango-jive-imgver| tag of
the ska-tango-images-tango-jive OCI image.

The image uses :ref:`ska-tango-images-tango-admin` as a base image and so
provides the same features, in addition to the ``jive`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - Jive
     - |tsd-jive-version|
   * - tango_admin
     - |tangoadmin-version|
   * - cppTango
     - |cpptango-version|
   * - ZeroMQ
     - |zeromq-version|
   * - omniORB
     - |omniorb-version|
   * - opentelemetry-cpp
     - |otel-version|

Usage Example
-------------

``jive`` is an X11 application and requires an X11 server to run.  The following
command will launch the ska-tango-images-tango-jive image using a Linux host's
X11 server and connect to ``TANGO_HOST``:

.. code-block:: bash
   :substitutions:

    docker run --security-opt label=type:container_runtime_t \
       --net=host --user $(id -u):$(id -g) \
       -e TANGO_HOST=$TANGO_HOST -e DISPLAY=$DISPLAY -e XAUTHORITY="/Xauthority" \
       -v /tmp/.X11-unix:/tmp/.X11-unix:z -v ${XAUTHORITY:-$HOME/.Xauthority}:/Xauthority:ro \
       --rm |oci-registry|/ska-tango-images-tango-jive:|tango-jive-imgver|

For running on macOS, you must have an XQuartz server running with the "Allow
connections from the network clients" checked and you must provide your host IP
address in the DISPLAY.  For example,

.. code-block:: bash
   :substitutions:

   MY_IP_ADDRESS=$(scutil --nwi | grep 'address' | head -n1 | cut -d':' -f2 | tr -d ' ')
   docker run --net=host --user $(id -u):$(id -g) \
       -e TANGO_HOST=$TANGO_HOST -e DISPLAY="${MY_IP_ADDRESS}:0" -e XAUTHORITY="/Xauthority" \
       -v /tmp/.X11-unix:/tmp/.X11-unix:z -v ${XAUTHORITY:-$HOME/.Xauthority}:/Xauthority:ro \
       --rm |oci-registry|/ska-tango-images-tango-jive:|tango-jive-imgver|

