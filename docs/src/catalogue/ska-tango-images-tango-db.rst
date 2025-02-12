.. _ska-tango-images-tango-db:

=========================
ska-tango-images-tango-db
=========================

This image provides a `MariaDB <https://mariadb.org/>`_ instance loaded with a
Tango database table, provided by `TangoDatabase
<https://gitlab.com/tango-controls/TangoDatabase>`_. This MariaDB instance can
be used by :ref:`ska-tango-images-tango-databaseds` to provide a ``TANGO_HOST``
for your control system.

Summary
-------

Release |version| of ska-tango-images provides the |tango-db-imgver| tag of
the ska-tango-images-tango-db OCI image.

The image uses the `MariaDB docker image <https://hub.docker.com/_/mariadb>`_ as
a base image, using the |mariadb-version| tag.

The Tango table is built using the |databaseds-version| release of
TangoDatabase.

Usage Example
-------------

To launch the database with a "tango" user and a "tango" password, run the
following:

.. code-block::
   :substitutions:

   docker run --name tango-db -p 3306:3306 --detach --rm \
      --env MYSQL_ROOT_PASSWORD=secret \
      --env MYSQL_PASSWORD=tango \
      --env MYSQL_USER=tango \
      --env MYSQL_DATABASE=tango \
      |oci-registry|/ska-tango-images-tango-db:|tango-db-imgver|

The database will be available at the TCP port ``localhost:3306``.

The database can then be stopped with the following, when it will be
automatically removed:

.. code-block::

   docker stop tango-db

Note, any changes made to the database will be lost.

