.. _rest-with-docker-compose:

==========================================================================
How to spin-up a Tango environment with a REST server using Docker compose
==========================================================================

`Docker compose <https://docs.docker.com/compose/>`_ and the images produced by
this repository can be used to spin-up a Tango environment with a
TangoRestServer so that you can inspect your Tango devices via a REST API.

This how-to provides an example docker compose file you can use to startup the
TangoRestServer along with a TangoTest device which can be used for
experimentation.

Create the docker compose configuration
---------------------------------------

This section describes the files you need to create in order to start the HDB++
instance.  The docker compose file will use
:ref:`ska-tango-images-tango-dsconfig` to configure the Tango database.

- Step 1: Save the following as ``compose.yaml``:

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
         start_interval: 500ms
         timeout: 1s
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
       entrypoint: Databaseds
       command:
         - "2"
         - -ORBendPoint
         - giop:tcp::10000
       healthcheck:
         test: ["CMD", "/usr/local/bin/tango_admin", "--ping-database"]
         start_period: 10s
         start_interval: 500ms
         timeout: 1s
         retries: 3

     load-tango-config:
       image: |oci-registry|/ska-tango-images-tango-dsconfig:|tango-dsconfig-imgver|
       platform: linux/x86_64
       networks:
         - tango-net
       environment:
         - TANGO_HOST=tango-dbds:10000
       volumes:
         - ./:/mnt:z
       depends_on:
         tango-dbds:
           condition: service_healthy
       entrypoint: "bash"
       command:
         - "-c"
         - "json2tango --write /mnt/tango.json || [ $$? -eq 2 ]"

     tango-test:
       image: |oci-registry|/ska-tango-images-tango-test:|tango-test-imgver|
       platform: linux/x86_64
       networks:
         - tango-net
       environment:
         - TANGO_HOST=tango-dbds:10000
       depends_on:
         tango-dbds:
           condition: service_healthy
       healthcheck:
         test: ["CMD", "/usr/local/bin/tango_admin", "--ping-device", "sys/tg_test/1"]
         start_period: 10s
         start_interval: 500ms
         timeout: 1s
         retries: 3
       command:
         - "test"

     tango-rest:
       image: |oci-registry|/ska-tango-images-rest-server:|rest-server-imgver|
       platform: linux/x86_64
       networks:
         - tango-net
       environment:
         - TANGO_HOST=tango-dbds:10000
       ports:
         - "8080:8080"
       depends_on:
         tango-dbds:
           condition: service_healthy
         load-tango-config:
           condition: service_completed_successfully
       healthcheck:
         test: ["CMD", "/usr/local/bin/tango_admin", "--ping-device", "sys/rest/0"]
         start_period: 10s
         start_interval: 500ms
         timeout: 1s
         retries: 3
       command:
         - "rest"

- Step 2: Create the configuration file for
  :ref:`ska-tango-images-tango-dsconfig`  by saving the following file as
  ``tango.json`` in the same directory as your ``compose.yaml``:

.. code-block:: json

    {
        "servers": {
            "TangoRestServer": {
                "rest": {
                    "TangoRestServer": {
                        "sys/rest/0": {
                            "properties": {
                                "TANGO_DB": ["tango://tango-dbds:10000/sys/database/2"],
                                "TOMCAT_PORT": ["8080"],
                                "TOMCAT_AUTH_METHOD": ["plain"]
                            }
                        }
                    }
                }
            }
        }
    }

Start the REST device server
----------------------------

To start the Tango environment, run the following from the directory
containing ``compose.yaml``:

.. code-block:: bash

   docker compose up -d

After a brief startup time, the Tango database should now be available at
``TANGO_HOST=localhost:10000`` and the REST server should be available at
``localhost:8080``.  The REST server requires HTTP plain authentication using
the user "tango-cs" and the password "tango".

Test the REST server
--------------------

You can query the REST server using curl, for example, to get information about
the TangoTest device included in the docker compose file:

.. code-block:: bash

    URL="http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/sys/tg_test/1"
    curl -s -u "tango-cs:tango" $URL | python3 -m json.tool

.. note::

   Depending on your system configuration, it might take a while for the REST
   server to start listening to requests.  The above command might fail if you
   run it very quickly after ``docker compose up -d`` has returned.

Which should output something like the following:

.. code-block:: bash

  {
      "name": "sys/tg_test/1",
      "info": {
          "last_exported": "4th February 2025 at 16:13:56",
          "last_unexported": "?",
          "name": "sys/tg_test/1",
          "ior": <some very long IOR>,
          "version": "5",
          "exported": true,
          "pid": 1,
          "server": "TangoTest/test",
          "hostname": "20c2056213e6",
          "classname": "unknown",
          "is_taco": false
      },
      "attributes": "http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/sys/tg_test/1/attributes",
      "commands": "http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/sys/tg_test/1/commands",
      "pipes": "http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/sys/tg_test/1/pipes",
      "properties": "http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/sys/tg_test/1/properties",
      "state": "http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/sys/tg_test/1/state",
      "_links": {
          "_self": "http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/sys/tg_test/1",
          "_parent": "http://localhost:8080/tango/rest/rc4/hosts/tango-dbds/10000/devices/"
      }
  }

Stopping the Tango environment
------------------------------

The Tango environment and archiver can be stopped by running the following from the directory
containing ``compose.yaml``:

.. code-block:: bash

   docker compose down
