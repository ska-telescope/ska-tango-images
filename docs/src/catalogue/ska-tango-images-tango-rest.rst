.. _ska-tango-images-tango-rest:

===========================
ska-tango-images-tango-rest
===========================

This image contains `TangoRestServer
<https://github.com/tango-controls/rest-server>`_.  ``TangoRestServer`` is a web
sever which exposes your Tango control system via a REST API.

.. warning::

   This image is deprecated and will not recieve another release.  Please use
   :ref:`ska-tango-images-rest-server` instead.

Summary
-------

Release |version| of ska-tango-images provides the |tango-rest-imgver| tag of
the ska-tango-images-tango-rest OCI image.

The image uses :ref:`ska-tango-images-tango-admin` as a base image and so
provides the same features, in addition to the ``TangoRestServer`` application.

This image uses supervisord to spawn the ``TangoRestServer``.

Included Software
*****************

.. list-table::
   :header-rows: 1

   * - Package
     - Version
   * - TangoRestServer
     - |tsd-rest-version|
   * - tango_admin
     - |tangoadmin-version|
   * - cppTango
     - |cpptango-version|
   * - ZeroMQ
     - |zeromq-version|
   * - omniORB
     - |omniorb-version|
   * - opentelemetry-cpp
     - |otel-version|

Usage Example
-------------

To launch the "rest" instance of the TangoRestServer device server, connecting to
``TANGO_HOST=localhost:10000`` run the following:

.. code-block:: bash
   :substitutions:

   docker run --rm --env TANGO_HOST=localhost:10000 --net=host \
     --detach --name tango-rest \
     |oci-registry|/ska-tango-images-tango-rest:|tango-rest-imgver|

This will launch a REST server listening on port 8080, to check that this is
working run the following curl command:

.. code-block:: bash

    URL="http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/sys/rest/0"
    curl -s -u "tango-cs:tango" $URL | python -m json.tool

Which should output something like the following:

.. code-block::

    {
        "name": "sys/rest/0",
        "info": {
            "last_exported": "?",
            "last_unexported": "?",
            "name": "sys/rest/0",
            "ior": "nada",
            "version": "nada",
            "exported": false,
            "pid": 0,
            "server": "TangoRestServer/rest",
            "hostname": "nada",
            "classname": "unknown",
            "is_taco": false
        },
        "attributes": "http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/sys/rest/0/attributes",
        "commands": "http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/sys/rest/0/commands",
        "pipes": "http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/sys/rest/0/pipes",
        "properties": "http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/sys/rest/0/properties",
        "state": "http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/sys/rest/0/state",
        "_links": {
            "_self": "http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/sys/rest/0",
            "_parent": "http://localhost:8080/tango/rest/rc4/hosts/localhost/10000/devices/"
        }
    }


The REST server can be stopped with:

.. code-block:: bash

     docker stop tango-rest
