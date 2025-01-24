.. _ska-tango-images-hdbpp-timescaledb:

==================================
ska-tango-images-hdbpp-timescaledb
==================================

This image provides a `TimescaleDB <https://www.timescale.com/>`_ instance loaded with a
HDB++ archiving database table, provided by `hdbpp-timescale-project
<https://gitlab.com/tango-controls/hdbpp/hdbpp-timescale-project>`_. This
TimescaleDB instance can be used by :ref:`ska-tango-images-hdbpp-es-timescaledb`
to provide attribute archiving for your control system.

Summary
-------

Release |version| of ska-tango-images provides the |hdbpp-timescaledb-imgver| tag of
the ska-tango-images-tango-db OCI image.

The image uses the `TimescalbeDB docker image <https://hub.docker.com/r/timescale/timescaledb>`_ as
a base image, using the |timescaledb-version| tag.

The Tango table is built using the |hdbpp-timescale-project-version| commit of
the hdbpp-timescale-project.

Usage Example
-------------

To launch the database with a "postgres" user and a "tango" password, run the
following:

.. code-block::
   :substitutions:

   docker run --name archive-db -p 5432:5432 --detach --rm \
      --env POSTGRESS_PASSWORD=tango \
      |oci-registry|/ska-tango-images-hdbpp-timescaledb:|hdbpp-timescaledb-version|

The database will be available at the TCP port ``localhost:5432``.

The database can then be stopped with the following, when it will be
automatically removed:

.. code-block::

   docker stop archive-db

Note, any changes made to the database will be lost.
