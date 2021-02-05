Building the Docker images
==========================

The following Docker images are built by this project:

+--------------------+-------------------------------------------------------+
| Docker image       | Description                                           |
+====================+=======================================================+
| tango-dependencies | A base image containing TANGO's preferred version of  |
|                    | ZeroMQ plus the preferred, patched version of         |
|                    | OmniORB.                                              |
+--------------------+-------------------------------------------------------+
| tango-db           | A MariaDB image including TANGO database schema. Data |
|                    | is stored separately in a volume.                     |
+--------------------+-------------------------------------------------------+
| tango-cpp          | Core C++ TANGO libraries and applications.            |
+--------------------+-------------------------------------------------------+
| tango-libtango     | Same as tango-cpp.                                    |
+--------------------+-------------------------------------------------------+
| tango-pogo         | Image for running Pogo and displaying Pogo help. Pogo |
|                    | output can be persisted to a docker volume or to the  |
|                    | host machine.                                         |
+--------------------+-------------------------------------------------------+
| tango-jive         | The TANGO jive tool                                   |
+--------------------+-------------------------------------------------------+
| tango-java         | As per ska/tango-cpp, plus Java applications and      |
|                    | bindings.                                             |
+--------------------+-------------------------------------------------------+
| pytango-builder    | Extends ska/tango-cpp, adding PyTango Python          |
|                    | bindings and other tools for building python libraries|
+--------------------+-------------------------------------------------------+
| pytango-runtime    | Extends pytango-builder without any tools for         |
|                    | development.                                          |
+--------------------+-------------------------------------------------------+
| tango-pytango      | same as pytango-runtime.                              |
+--------------------+-------------------------------------------------------+
| tango-itango       | itango, a Python shell for interactive TANGO          |
|                    | sessions.                                             |
+--------------------+-------------------------------------------------------+
| tango-rest         | An image containing mtango-rest, which acts as a REST |
|                    | proxy to a TANGO system.                              |
+--------------------+-------------------------------------------------------+
| tango-vnc          | An image containing xfce4 and vnc in order to enable  | 
|                    | desktop application such as jive.                     |
+--------------------+-------------------------------------------------------+
| tango-admin        | The TANGO tango-admin tool.                           |
+--------------------+-------------------------------------------------------+
| tango-databaseds   | The TANGO databaseds device server.                   |
+--------------------+-------------------------------------------------------+
| tango-dsconfig     | The TANGO MAXIV tool for managing the tango-db        |
+--------------------+-------------------------------------------------------+
| tango-test         | The TANGO test device server.                         |
+--------------------+-------------------------------------------------------+
| tango-panic        | The TANGO panic tool                                  |
+--------------------+-------------------------------------------------------+
| tango-panic-gui    | The TANGO panic tool with xfce4 and vnc.              |
+--------------------+-------------------------------------------------------+

To build and register the images locally, from the root of this
repository execute:

.. code-block:: console

   cd docker
   # build and register TBC/tango-cpp, TBC/tango-jive, etc. locally
   make build

Optionally, you can register images to an alternative Docker registry
account by supplying the ``CAR_OCI_REGISTRY_HOST`` and
``CAR_OCI_REGISTRY_PREFIX`` Makefile variables, e.g.,

.. code-block:: console

   # build and register images as foo/tango-cpp, foo/tango-jive, etc.
   make CAR_OCI_REGISTRY_PREFIX=foo build

Pushing the images to a Docker registry
---------------------------------------

Push images to the default Docker registry located at https://docker.io by
using the ``make push`` target.

.. code-block:: console

   # push the images to the Docker registry, making them publicly
   # available as foo/tango-cpp, foo/tango-jive, etc.
   make CAR_OCI_REGISTRY_PREFIX=foo push

Images can also be pushed to a custom registry by specifying a
``CAR_OCI_REGISTRY_HOST`` Makefile argument during the ``make build``
and ``make push`` steps, e.g.,

.. code-block:: console

   # build and tag the images to a custom registry located at
   # http://test_registry:5000
   make CAR_OCI_REGISTRY_PREFIX=foo CAR_OCI_REGISTRY_HOST=my_registry.org:5000 build

   # Now push the images to the remote custom registry
   make CAR_OCI_REGISTRY_PREFIX=foo CAR_OCI_REGISTRY_HOST=my.registry.org:5000 push

