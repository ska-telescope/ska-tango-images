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

- Step 1: Save the following as :download:`compose.yaml
  <../../gen/how-to-rest-with-docker-compose/compose.yaml>`:

.. literalinclude :: ../../gen/how-to-rest-with-docker-compose/compose.yaml
   :language: yaml

- Step 2: Create the configuration file for
  :ref:`ska-tango-images-tango-dsconfig`  by saving the following file as
  :download:`tango.json <../../gen/how-to-rest-with-docker-compose/tango.json>`:
  in the same directory as your ``compose.yaml``:

.. literalinclude :: ../../gen/how-to-rest-with-docker-compose/tango.json
   :language: json

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
