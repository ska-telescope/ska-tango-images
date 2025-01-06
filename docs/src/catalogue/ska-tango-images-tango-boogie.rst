.. _ska-tango-images-tango-boogie:

=============================
ska-tango-images-tango-boogie
=============================

This image contains `boogie <https://gitlab.com/nurbldoff/boogie>`_.
``boogie`` is terminal UI replacement for ``jive``.

Summary
-------

Release |version| of ska-tango-images provides the |tango-boogie-imgver| tag of
the ska-tango-images-tango-boogie OCI image.

The image uses :ref:`ska-tango-images-tango-python` as a base image and so
provides the same features, in addition to the ``boogie`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - PyTango
     - |pytango-version|
   * - boogie
     - |boogie-version|
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

To launch the ``boogie`` connecting to ``TANGO_HOST`` run the following:

.. code-block:: bash
   :substitutions:

   docker run --rm -it --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-tango-boogie:|tango-boogie-imgver|

Press F10 to exit boogie.
