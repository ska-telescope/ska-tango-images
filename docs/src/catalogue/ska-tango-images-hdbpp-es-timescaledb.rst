.. _ska-tango-images-hdbpp-es-timescaledb:

=====================================
ska-tango-images-hdbpp-es-timescaledb
=====================================

This image contains `hdbpp-es
<https://gitlab.com/tango-controls/hdbpp/hdbpp-es>`_ built against `cppTango
<https://gitlab.com/tango-controls/cppTango>`_ and `libhdpp-timescale
<https://gitlab.com/tango-controls/hdbpp/libhdbpp-timescale>`_.  ``hdbpp-es`` provides the
event subscriber device server for `HDB++
<https://tango-controls.readthedocs.io/en/latest/tools-and-extensions/archiving/HDB++.html>`_.
The version provided by this images stores archive data in a `TimescaleDB <https://www.timescale.com/>`_
database.

Summary
-------

Release |version| of ska-tango-images provides the |hdbpp-es-timescaledb-imgver| tag of
the ska-tango-images-hdbpp-es-timescale OCI image.

The image uses :ref:`ska-tango-images-tango-admin` as a base image and so
provides the same features, in addition to the ``hdb++es-srv`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - hdbpp-es
     - |hdbpp-es-version|
   * - libhdbpp
     - |libhdbpp-version|
   * - libhdbpp-timescale
     - |libhdbpp-timescale-version|
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

To launch the "1" instance of the hdbpp-es device server, connecting to
``TANGO_HOST`` run the following:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-hdbpp-es-timescaledb:|hdbpp-es-timescaledb-imgver| \
     1

