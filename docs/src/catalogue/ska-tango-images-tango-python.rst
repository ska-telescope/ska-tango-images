.. _ska-tango-images-tango-python:

=============================
ska-tango-images-tango-python
=============================

Base image to be used for pytango-based applications, built with the
ska-python-build image.

Summary
-------

Release |version| of ska-tango-images provides the |tango-python-imgver| tag of
the ska-tango-images-tango-base OCI image.

This image is based on the ska-python:|skapython-version| image.

The image provides:

- a "tango" user with sudo privileges
- ``wait-for-it.sh`` and ``retry`` orchestration scripts
- ``tango_admin``

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - tango_admin
     - |tangoadmin-version|
   * - cppTango
     - |cpptango-version|
   * - ZeroMQ
     - |zeromq-version|
   * - omniORB
     - |omniorb-version|

Base image
----------

ska-tango-images-tango-python contains all the system dependencies required to run
a built with ska-python-build.  PyTango-based applications
built with this build image can be copied into a image based on
ska-tango-images-tango-python to produce a lean runtime image for the application.
See :ref:`build-pytango-image` for details about how to build your own Tango
application images.

Runtime application images using ska-tango-images-tango-base as a base image
will run as a "tango" user by default.  This user has sudo privileges.

In addition, the runtime application image will contain orchestration scripts to
aid with starting Tango device servers.  See :ref:`ska-tango-images-tango-base`
for usage of these orchestration scripts.
