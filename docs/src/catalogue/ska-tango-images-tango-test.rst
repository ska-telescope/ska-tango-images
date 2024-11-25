.. _ska-tango-images-tango-test:

===========================
ska-tango-images-tango-test
===========================

This image contains `TangoTest
<https://gitlab.com/tango-controls/TangoTest>`_ built against `cppTango
<https://gitlab.com/tango-controls/cppTango>`_.  ``TangoTest`` is a test Tango
device server, showcasing the various features of a Tango device.

Summary
-------

Release |version| of ska-tango-images provides the |tango-test-imgver| tag of
the ska-tango-images-tango-test OCI image.

The image uses :ref:`ska-tango-images-tango-admin` as a base image and so
provides the same features, in addition to the ``TangoTest`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - TangoTest
     - |tangotest-version|
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

To launch the "test" instance of the TangoTest device server, connecting to
``TANGO_HOST`` run the following:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-test:|tango-test-imgver| \
     test

