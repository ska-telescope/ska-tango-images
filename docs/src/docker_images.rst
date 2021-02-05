Building the Docker images
==========================

The following Docker images are built by this project:

+--------------------+-------------------------------------------------------+
| Docker image       | Description                                           |
+====================+=======================================================+
| pytango-builder    | Extends ska/tango-cpp, adding PyTango Python          |
|                    | bindings and other tools for building python libraries|
+--------------------+-------------------------------------------------------+
| pytango-runtime    | Extends pytango-builder without any tools for         |
|                    | development.                                          |
+--------------------+-------------------------------------------------------+
| tango-admin        | The TANGO tango-admin tool.                           |
+--------------------+-------------------------------------------------------+
| tango-cpp          | Core C++ TANGO libraries and applications.            |
+--------------------+-------------------------------------------------------+
| tango-databaseds   | The TANGO databaseds device server.                   |
+--------------------+-------------------------------------------------------+
| tango-db           | A MariaDB image including TANGO database schema. Data |
|                    | is stored separately in a volume.                     |
+--------------------+-------------------------------------------------------+
| tango-dependencies | A base image containing TANGO's preferred version of  |
|                    | ZeroMQ plus the preferred, patched version of         |
|                    | OmniORB.                                              |
+--------------------+-------------------------------------------------------+
| tango-dsconfig     | The TANGO MAXIV tool for managing the tango-db        |
+--------------------+-------------------------------------------------------+
| tango-itango       | itango, a Python shell for interactive TANGO          |
|                    | sessions.                                             |
+--------------------+-------------------------------------------------------+
| tango-java         | As per ska/tango-cpp, plus Java applications and      |
|                    | bindings.                                             |
+--------------------+-------------------------------------------------------+
| tango-jive         | The TANGO jive tool                                   |
+--------------------+-------------------------------------------------------+
| tango-libtango     | Same as tango-cpp.                                    |
+--------------------+-------------------------------------------------------+
| tango-panic        | The TANGO panic tool                                  |
+--------------------+-------------------------------------------------------+
| tango-panic-gui    | The TANGO panic tool with xfce4 and vnc.              |
+--------------------+-------------------------------------------------------+
| tango-pogo         | Image for running Pogo and displaying Pogo help. Pogo |
|                    | output can be persisted to a docker volume or to the  |
|                    | host machine.                                         |
+--------------------+-------------------------------------------------------+
| tango-pytango      | same as pytango-runtime.                              |
+--------------------+-------------------------------------------------------+
| tango-rest         | An image containing mtango-rest, which acts as a REST |
|                    | proxy to a TANGO system.                              |
+--------------------+-------------------------------------------------------+
| tango-test         | The TANGO test device server.                         |
+--------------------+-------------------------------------------------------+
| tango-vnc          | An image containing xfce4 and vnc in order to enable  | 
|                    | desktop application such as jive.                     |
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
   
Building with alternatives to Docker
------------------------------------

You can use a daemon-less unpriveleged alternative to Docker to build container images using the dockerfiles hosted in this project by setting the ``IMAGE_BUILDER`` Makefile variable. This alternative image builder must be fully compatible with ``docker build`` options. Currently, Img and Podman were tested and they work without any major issues.

To use, e.g., Img:

.. code-block:: console

   # build and register images as TBC/tango-cpp, TBC/tango-jive, etc.
   make IMAGE_BUILDER=img build

For more information about IMG, including installation:

https://github.com/genuinetools/img

For more information about Podman:

https://github.com/containers/podman 



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

If your images were built with alternatives to Docker like Img or Podman do not forget to set the ``IMAGE_BUILDER`` variable accordingly.

