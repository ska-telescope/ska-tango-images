.. _basic-docker-compose:

=======================================================
How to spin-up a Tango environment using Docker compose
=======================================================

`Docker compose <https://docs.docker.com/compose/>`_ and the images produced by
this repository can be used to spin-up a basic Tango environment for testing.
This howto will demonstrate a basic docker compose file you can use to startup
a ``TANGO_HOST``.  This docker compose file can easily be extended with more
containers to run additional Tango device servers.

First, save the following as ``compose.yaml``:

.. code-block:: yaml
   :substitutions:

   networks:
     tango-net:
       name: tango-net
       driver: bridge

   services:
     tango-db:
       image: |oci-registry|/ska-tango-images-tango-db:|tango-db-imgver|
       platform: linux/x86_64
       networks:
         - tango-net
       environment:
         - MARIADB_ROOT_PASSWORD=root
         - MARIADB_DATABASE=tango
         - MARIADB_USER=tango
         - MARIADB_PASSWORD=tango
       healthcheck:
         test: ["CMD", "healthcheck.sh", "--connect"]
         start_period: 10s
         interval: 10s
         timeout: 5s
         retries: 3

     tango-dbds:
       image: |oci-registry|/ska-tango-images-tango-databaseds:|tango-databaseds-imgver|
       platform: linux/x86_64
       networks:
         - tango-net
       ports:
         - "10000:10000"
       environment:
         - TANGO_HOST=localhost:10000
         - MYSQL_HOST=tango-db:3306
         - MYSQL_USER=tango
         - MYSQL_PASSWORD=tango
         - MYSQL_DATABASE=tango
       depends_on:
         tango-db:
           condition: service_healthy
       entrypoint: ''
       command:
         - DataBaseds
         - "2"
         - -ORBendPoint
         - giop:tcp::10000
       healthcheck:
         test: ["CMD", "/usr/local/bin/tango_admin", "--ping-database"]
         start_period: 10s
         interval: 10s
         timeout: 5s
         retries: 3

.. note::

  This uses docker's health check feature rather than orchestration scripts
  included from :ref:`ska-tango-images-tango-base`.  Using docker's health check
  is preferable as then docker will report the health of the services.  The
  orchestration scripts are provided in the images for backwards compatibility.


Second, to start the Tango environment, run the following from the directory
containing ``compose.yaml``:

.. code-block:: bash

   docker compose up -d

After a brief startup time, the Tango database should now be available at
``TANGO_HOST=localhost:10000``.

You can check that the database is available by running:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver| \
     --ping-database

The Tango environment can be stopped by running the following from the directory
containing compose.yaml:

.. code-block:: bash

   docker compose down
