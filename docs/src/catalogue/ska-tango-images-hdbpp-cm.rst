.. _ska-tango-images-hdbpp-cm:

=========================
ska-tango-images-hdbpp-cm
=========================

This image contains `hdbpp-cm
<https://gitlab.com/tango-controls/hdbpp/hdbpp-cm>`_ built against `cppTango
<https://gitlab.com/tango-controls/cppTango>`_.  ``hdbpp-cm`` provides the
configuration manager device server for `HDB++
<https://tango-controls.readthedocs.io/en/latest/tools-and-extensions/archiving/HDB++.html>`_.

Summary
-------

Release |version| of ska-tango-images provides the |hdbpp-cm-imgver| tag of
the ska-tango-images-hdbpp-cm OCI image.

The image uses :ref:`ska-tango-images-tango-admin` as a base image and so
provides the same features, in addition to the ``hdb++cm-srv`` entry point.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - hdbpp-cm
     - |hdbpp-cm-version|
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

To launch the "1" instance of the hdbpp-cm device server, connecting to
``TANGO_HOST`` run the following:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=$TANGO_HOST --net=host \
     |oci-registry|/ska-tango-images-hdbpp-cm:|hdbpp-cm-imgver| \
     1

