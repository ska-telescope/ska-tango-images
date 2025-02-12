.. _ska-tango-images-tango-databaseds:

=================================
ska-tango-images-tango-databaseds
=================================

This image contains ``Databaseds``, provided by `TangoDatabase
<https://gitlab.com/tango-controls/TangoDatabase>`_, and built against `cppTango
<https://gitlab.com/tango-controls/cppTango>`_.  ``Databaseds`` provides a
``TANGO_HOST`` for your control system.

Summary
-------

Release |version| of ska-tango-images provides the |tango-databaseds-imgver| tag of
the ska-tango-images-tango-databaseds OCI image.

The image uses :ref:`ska-tango-images-tango-admin` as a base image and so
provides the same features, in addition to the ``Databaseds`` entry point.

For backwards compatibility, the image also includes a ``DataBaseds`` symlink to
the ``Databaseds`` binary.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - TangoDatabase
     - |databaseds-version|
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

ska-tango-images-tango-databaseds requires a MariaDB database loaded with a
Tango database table.  This can be provided by the
:ref:`ska-tango-images-tango-db` image.  To start a Databaseds instance
connecting to a MariaDB instance available at ``localhost:3306`` with username
"tango" and password "tango", run the following:


.. code-block:: bash
   :substitutions:

   docker run --rm --net=host \
      --env MYSQL_HOST=127.0.0.1:3306 \
      --env MYSQL_DATABASE=tango \
      --env MYSQL_USER=tango \
      --env MYSQL_PASSWORD=tango \
      |oci-registry|/ska-tango-images-tango-databaseds:|tango-databaseds-imgver| \
      2 -ORBendPoint giop:tcp::10000
