.. _ska-tango-images-tango-admin:

============================
ska-tango-images-tango-admin
============================

This image contains `tango_admin
<https://gitlab.com/tango-controls/tango_admin>`_ built against `cppTango
<https://gitlab.com/tango-controls/cppTango>`_.  ``tango_admin`` allows you to
administer your Tango control system from the command line.

Summary
-------

Release |version| of ska-tango-images provides the |tango-admin-imgver| tag of
the ska-tango-images-tango-admin OCI image.

The image uses :ref:`ska-tango-images-tango-base` as a base image and so
provides the same features, in addition to the ``tango_admin`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
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

To attempt to ping your Tango database available on ``TANGO_HOST``:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver| \
     --ping-database

As the ``tango_admin`` utility is very useful when dealing with different Tango
applications, the
:substitution-code:`|oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver|`
can also be used as a base image when building other application images.  This
is the case for most of the application images provided by ska-tango-images. See
:ref:`build-cpptango-image` for details about how to build your own cppTango
application images.
