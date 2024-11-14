.. _ska-tango-images-tango-base:

===========================
ska-tango-images-tango-base
===========================

Base image to be used for cppTango-based applications, built with the
:ref:`ska-tango-images-tango-cpp` image.

Summary
-------

Release |version| of ska-tango-images provides the |tango-base-imgver| tag of
the ska-tango-images-tango-base OCI image.

This image is based on the ska-base:|skabase-version| image.

The image provides:

- system dependencies required to run cppTango-based applications
- a "tango" user with sudo privileges
- ``wait-for-it.sh`` and ``retry`` orchestration scripts

Usage as a Base image
---------------------

ska-tango-images-tango-base contains all the system dependencies required to run
an application built with :ref:`ska-tango-images-tango-cpp`.  cppTango-based
applications built with this build image can be copied into a image based on
ska-tango-images-tango-base to produce a lean runtime image for the application.
See :ref:`build-cpptango-image` for details about how to build your own Tango
application images.

Runtime application images using ska-tango-images-tango-base as a base image
will run as a "tango" user by default.  This user has sudo privileges.

In addition, the runtime application image will contain two orchestration
scripts, ``retry`` and ``wait-for-it.sh``, to aid with starting Tango device
servers.

``retry`` Usage
---------------

The ``retry`` script allows retrying launching a process until it succeeds,
sleeping in between each attempt.

The script supports either a constant sleep time between attempts or a random
sleep time using an exponential backoff algorithm.::

  Usage: retry [options] -- execute command
      -h, -?, --help
      -v, --verbose                    Verbose output
      -t, --tries=#                    Set max retries: Default 10
      -s, --sleep=secs                 Constant sleep amount (seconds)
      -m, --min=secs                   Exponential Backoff: minimum sleep amount (seconds): Default 0.3
      -x, --max=secs                   Exponential Backoff: maximum sleep amount (seconds): Default 60
      -f, --fail="script +cmds"        Fail Script: run in case of final failure

Example
*******

The :ref:`ska-tango-images-tango-test` image is based on
ska-tango-images-tango-base and so includes the ``retry`` script.  To repeatedly
attempt to restart the device server until the ``TANGO_HOST`` is available, run
the following:

.. code-block:: bash
   :substitutions:

   docker run --rm --net=host --env TANGO_HOST=$TANGO_HOST --entrypoint=retry \
      |oci-registry|/ska-tango-images-tango-test:|tango-test-imgver| \
      --tries=20 --sleep=1 TangoTest test

``wait-for-it.sh`` Usage
------------------------

The ``wait-for-it.sh`` script allows waiting for a TCP port to be available
before launching a process.::

  Usage:
      wait-for-it.sh host:port [-s] [-t timeout] [-- command args]
      -h HOST | --host=HOST       Host or IP under test
      -p PORT | --port=PORT       TCP port under test
                                  Alternatively, you specify the host and port as host:port
      -s | --strict               Only execute subcommand if the test succeeds
      -q | --quiet                Don't output any status messages
      -t TIMEOUT | --timeout=TIMEOUT
                                  Timeout in seconds, zero for no timeout
      -- COMMAND ARGS             Execute command with args after the test finishes

Example
*******

The :ref:`ska-tango-images-tango-databaseds` image is based on
ska-tango-images-tango-base and so includes the ``wait-for-it.sh`` script.

To demonstrate this, we first setup a tango-db instance with the following:

.. code-block:: bash
   :substitutions:

   docker run --name tango-db -p 3306:3306 --detach --rm \
      --env MYSQL_ROOT_PASSWORD=secret \
      --env MYSQL_PASSWORD=tango \
      --env MYSQL_USER=tango \
      --env MYSQL_DATABASE=tango \
      |oci-registry|/ska-tango-images-tango-db:|tango-db-imgver|

This MariaDB instance will be available at TCP port 127.0.0.1:3306. Note that
"localhost" will not work because MariaDB will try to use the UNIX socket over
the TCP port, which is not available inside the container.

To wait for the MariaDB instance to be available before trying to restart the
`Datasebaseds` device server run the following:

.. code-block:: bash
   :substitutions:

   docker run --rm --net=host \
      --env MYSQL_HOST=127.0.0.1:3306 \
      --env MYSQL_DATABASE=tango \
      --env MYSQL_USER=tango \
      --env MYSQL_PASSWORD=tango \
      --entrypoint=wait-for-it.sh \
      |oci-registry|/ska-tango-images-tango-databaseds:|tango-databaseds-imgver| \
      --host=127.0.0.1 --port=3306 --timeout=60 -- Databaseds 2 -ORBendPoint giop:tcp::10000

To stop the MariaDB instance we started above:

.. code-block:: bash
   :substitutions:

   docker stop tango-db

