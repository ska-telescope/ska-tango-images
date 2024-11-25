.. _ska-tango-images-tango-itango:

=============================
ska-tango-images-tango-itango
=============================

This image contains `itango <https://gitlab.com/tango-controls/itango>`_.
``itango`` is a python interpreter with `PyTango
<https://gitlab.com/tango-controls/pytango>`_ integration, which can be used for
investigating your Tango control system.

Summary
-------

Release |version| of ska-tango-images provides the |tango-itango-imgver| tag of
the ska-tango-images-tango-itango OCI image.

The image uses :ref:`ska-tango-images-tango-python` as a base image and so
provides the same features, in addition to the ``itango`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - iTango
     - |itango-version|
   * - tango_admin
     - |tangoadmin-version|
   * - cppTango
     - |cpptango-version|
   * - ZeroMQ
     - |zeromq-version|
   * - omniORB
     - |omniorb-version|

Usage Example
-------------

To launch the ``itango`` connecting to ``TANGO_HOST`` run the following:

.. code-block:: bash
   :substitutions:

   docker run --rm -it --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-itango:|tango-itango-imgver|

