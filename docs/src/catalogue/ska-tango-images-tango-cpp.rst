.. _ska-tango-images-tango-cpp:

==========================
ska-tango-images-tango-cpp
==========================

Build image to be used for cppTango-based applications.

Summary
-------

Release |version| of ska-tango-images provides the |tango-cpp-imgver| tag of
the ska-tango-images-tango-cpp OCI image.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - cppTango
     - |cpptango-version|
   * - ZeroMQ
     - |zeromq-version|
   * - omniORB
     - |omniorb-version|

Usage
-----

ska-tango-images-tango-cpp includes software required to build Tango
applications based on cppTango.  Note that this image is not intended to be used
as the base of a runtime image.  It is recommended to copy the results of the
build process into a base image to create a dedicated runtime image. See
:ref:`build-cpptango-image` for details about how to build your own Tango
application images.

