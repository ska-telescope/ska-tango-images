.. _ska-tango-images-tango-pogo:

===========================
ska-tango-images-tango-pogo
===========================

This image contains `pogo
<https://gitlab.com/tango-controls/pogo>`_.  ``pogo`` is a GUI to configure a
device server and generate code to implement it.

The image uses :ref:`ska-tango-images-tango-admin` as a base image and so
provides the same features, in addition to the ``pogo`` entry point.

Summary
-------

Release |version| of ska-tango-images provides the |tango-pogo-imgver| tag of
the ska-tango-images-tango-pogo OCI image.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - Pogo
     - |tsd-pogo-version|
   * - JTango
     - |tsd-jtango-version|
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

``pogo`` is an X11 application and requires an X11 server to run.  The following
command will launch the ska-tango-images-tango-pogo image using a Linux host's
X11 server and mount the current directory in /mnt.  You can then navigate
to your xmi files under the /mnt directory.

.. code-block:: bash
   :substitutions:

   docker run --security-opt label=type:container_runtime_t \
       --net=host --user $(id -u):$(id -g) -v .:/mnt:Z \
       -e DISPLAY=$DISPLAY -e XAUTHORITY="/Xauthority" \
       -v /tmp/.X11-unix:/tmp/.X11-unix:z -v ${XAUTHORITY:-$HOME/.Xauthority}:/Xauthority:ro \
       --rm |oci-registry|/ska-tango-images-tango-pogo:|tango-pogo-imgver|

For running on macOS, you must have an XQuartz server running with the "Allow
connections from the network clients" checked and you must provide your host IP
address in the DISPLAY.  For example,

.. code-block:: bash
   :substitutions:

   MY_IP_ADDRESS=$(scutil --nwi | grep 'address' | head -n1 | cut -d':' -f2 | tr -d ' ')
   docker run --net=host --user $(id -u):$(id -g) -v .:/mnt:Z \
       -e DISPLAY="${MY_IP_ADDRESS}:0" -e XAUTHORITY="/Xauthority" \
       -v /tmp/.X11-unix:/tmp/.X11-unix:z -v ${XAUTHORITY:-$HOME/.Xauthority}:/Xauthority:ro \
       --rm |oci-registry|/ska-tango-images-tango-pogo:|tango-pogo-imgver|
