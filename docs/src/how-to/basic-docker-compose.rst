.. _basic-docker-compose:

=======================================================
How to spin-up a Tango environment using Docker compose
=======================================================

`Docker compose <https://docs.docker.com/compose/>`_ and the images provided by
ska-tango-images can be used to spin-up a basic Tango environment for testing
and experimentation.

This how-to will demonstrate a basic docker compose file you can use to startup
a ``TANGO_HOST`` and show how to start native Tango device servers to use the
``TANGO_HOST`` as well as how to add additional services to the docker compose
file to start additional device servers.

Starting a basic Tango environment
----------------------------------

- Step 1: Save the following as :download:`compose.yaml
  <../../gen/how-to-basic-docker-compose/compose.yaml>`:

.. literalinclude:: ../../gen/how-to-basic-docker-compose/compose.yaml
   :language: yaml

.. note::

  This uses docker's health check feature rather than orchestration scripts
  included from :ref:`ska-tango-images-tango-base`.  Using docker's health check
  is preferable as then docker will report the health of the services.  The
  orchestration scripts are provided in the images for backwards compatibility.

- Step 2: To start the Tango environment, run the following from the directory
  containing ``compose.yaml``:

.. code-block:: bash

   docker compose up -d

After a brief startup time, the Tango database device server should now be
available at ``TANGO_HOST=localhost:10000``.  Exporting that environment
variable will allow Tango tools to find the newly spun-up Tango environment.

You can check that the database is available by running the following
``tango_admin`` command.  It will not output anything on stdout but a non-zero
exit code means there is a problem:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver| \
     --ping-database

.. tip::

   A local version of ``tango_admin`` will also work here, you don't have to use
   the :ref:`ska-tango-images-tango-admin` OCI image.

.. warning::

   With tango_admin 1.24 the above command has a default timeout of 1200s and it
   does not output anything if it cannot connect to the device.  This happens,
   for example, if you have not set the `TANGO_HOST` environment variable.

Starting a native Tango device
------------------------------

The steps in this section describe how to start a device server natively, while
using the Tango database device server started above.  These steps assume we
have the following (uninteresting) pytango device server saved as
``MyDeviceServer.py``:

.. code-block:: python

   from tango.server import Device, run

   class MyDevice(Device):
       pass

   if __name__ == '__main__':
       run((MyDevice,))


- Step 1: Add an instance of the device server (with name my_instance) to the
  Tango database using ``tango_admin``:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver| \
     --add-server MyDeviceServer/my_instance MyDeviceClass domain/family/member


- Step 2: Start the device server instance on your local host.  For this python
  example, this will require that you have a python environment with ``pytango``
  already installed:

.. code-block:: bash
   :substitutions:

   python MyDeviceServer.py my_instance

Adding an additional Tango device to the docker compose file
------------------------------------------------------------

The steps in this section describe how to add a ``TangoTest`` device with device
name ``sys/tg_test/2`` to docker compose file, using the
:ref:`ska-tango-images-tango-test` OCI image. See :ref:`build-cpptango-image` or
:ref:`build-pytango-image` for how to build such a container for your own device
server.

- Step 1: Add an instance of the device server (with name ``my_instance``) to
  the database at startup using ``tango_admin`` by adding the following to the
  ``service`` object in your ``compose.yaml`` file:

.. code-block:: yaml
   :substitutions:

     load-tango-config:
       image: |oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver|
       platform: linux/x86_64
       networks:
         - tango-net
       environment:
         - TANGO_HOST=tango-dbds:10000
       depends_on:
         tango-dbds:
           condition: service_healthy
       command:
        - "--add-server"
        - "TangoTest/my_instance"
        - "TangoTest"
        - "sys/tg_test/2"

.. note::

   The Tango database defined in :ref:`ska-tango-images-tango-db` already
   includes a ``TangoTest`` device server instance (called ``test``) which
   starts a device called ``sys/tg_test/1``.  If you just want a ``TangoTest``
   device to play around with, you can skip this step.  We are adding the new
   instance above for demonstration purposes only.

.. tip::

   If you have lots of devices to add, or properties to add for your device, it
   might be easier to use :ref:`ska-tango-images-tango-dsconfig` to load the
   configuration from a JSON file, rather than issuing lots of ``tango_admin``
   commands.  See :ref:`hdbpp-with-docker-compose` for an example of doing this.

..
  _TODO: Add a how-to for using dsconfig like above.

- Step 2: Add a ``service`` to start the Tango device server, which depends on
  this ``load-tango-config`` service:

.. code-block:: yaml
   :substitutions:

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
         load-tango-config:
           condition: service_completed_successfully
       healthcheck:
         test: ["CMD", "sh", "-c", "/usr/local/bin/tango_admin --ping-device sys/tg_test/2 || exit 1"]
         start_period: 10s
         interval: 500ms
         timeout: 1s
         retries: 3
       command:
         - "my_instance"

- Step 3: Start the new environment:

.. code-block:: bash

   docker compose up -d

You can check that the ``sys/tg_test/2`` instance of ``TangoTest`` is running by
using ``tango_admin``:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-admin:|tango-admin-imgver| \
     --ping-device sys/tg_test/2

This will not output anything on stdout, however, a non-zero exit code will
indicate a problem.

Stopping the Tango environment
------------------------------

The Tango environment can be stopped by running the following from the directory
containing compose.yaml:

.. code-block:: bash

   docker compose down

Any changes made to the Tango database will be lost once the docker container is
stopped. To have the data persist, either mount a local directory to the
/var/lib/mysql directory of the tango-db image; or use
:ref:`ska-tango-images-tango-dsconfig` to load a configuration at startup.   See
the `Docker Volumes documentation
<https://docs.docker.com/engine/storage/volumes/>`_ for details about mounting a
local directory; or see :ref:`hdbpp-with-docker-compose` for an example of using
:ref:`ska-tango-images-tango-dsconfig` to load a configuration at startup

..
  _TODO: Add how-tos for both of the above peristence methods.

