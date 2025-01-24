.. _ska-tango-images-hdbpp-yaml2archiving:

=====================================
ska-tango-images-hdbpp-yaml2archiving
=====================================

This image contains `yaml2archving
<https://gitlab.com/tango-controls/hdbpp/yaml2archiving>`_.  ``yaml2archving``
can be use to configure your HDB++ archiving configuration.

Summary
-------

Release |version| of ska-tango-images provides the |hdbpp-yaml2archiving-imgver| tag of
the ska-tango-images-hdbpp-yaml2archiving OCI image.

The image uses :ref:`ska-tango-images-tango-python` as a base image and so
provides the same features, in addition to the ``yaml2archiving`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - PyTango
     - |pytango-version|
   * - yaml2archiving
     - |yaml2archiving-version|
   * - tango_admin
     - |tangoadmin-version|
   * - cppTango
     - |cpptango-version|
   * - ZeroMQ
     - |zeromq-version|
   * - omniORB
     - |omniorb-version|

Usage Example
-------------

To load archiving configuration from ``archive.yaml`` run the following:

.. code-block::
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host -v .:/mnt:z \
      |oci-registry|/ska-tango-images-hdbpp-yaml2archiving:|hdbpp-yaml2archiving-imgver| \
      --write /mnt/archive.yaml

See `yaml2archving <https://gitlab.com/tango-controls/hdbpp/yaml2archiving>`_
for more information about the format for the ``archive.yaml`` file.
