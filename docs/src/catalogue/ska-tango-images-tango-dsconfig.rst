.. _ska-tango-images-tango-dsconfig:

===============================
ska-tango-images-tango-dsconfig
===============================

This image contains ``json2tango`` provided by `dsconfig
<https://gitlab.com/MaxIV/lib-maxiv-dsconfig>`_.  ``json2tango`` allows loading
Tango configuration from a json file into a Tango database.

Summary
-------

Release |version| of ska-tango-images provides the |tango-dsconfig-imgver| tag of
the ska-tango-images-tango-dsconfig OCI image.

The image uses :ref:`ska-tango-images-tango-python` as a base image and so
provides the same features, in addition to the ``itango`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - dsconfig
     - |dsconfig-version|
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

To produce a JSON dump of the contents of a Tango database running at
``TANGO_HOST`` to the file ``tango-dump.json``:

.. code-block::
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
      |oci-registry|/ska-tango-images-tango-dsconfig:|tango-dsconfig-imgver| \
      python -m dsconfig.dump > tango-dump.json

To load the same JSON dump (found in the current directory) back into the Tango
database:

.. code-block::
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host -v .:/mnt:z \
      |oci-registry|/ska-tango-images-tango-dsconfig:|tango-dsconfig-imgver| \
      json2tango --write /mnt/tango-dump.json

