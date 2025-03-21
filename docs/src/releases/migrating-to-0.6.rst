================
Migrating to 0.6
================

This migration guide lists the breaking changes and issues that developers might
encounter when updating to the OCI images released in ska-tango-images 0.6.0.
This provides alternatives for developers using those images.

Note, that the OCI images produced by ska-tango-images have their own version
number, see :doc:`changelog` for a list of image tags released with version
0.6.0 of ska-tango-images.

tango_admin 1.24 incompatibilities
----------------------------------

The command line interface of the tango_admin 1.24 utility has changed compared
to the 1.17 version from previous ska-tango-images releases.

Notably, tango_admin now exits with a non-zero exit code when called without
arguments.  This exposes a bug in older versions of the ska-tango-utils helm
chart which is fixed with the 0.4.12 release.  Before updating any device server
images to use :ref:`ska-tango-images-tango-python`:0.2.0 or
:ref:`ska-tango-images-tango-admin`:1.24.0 be sure to first update your usage of
the ska-tango-utils and ska-tango-base charts to at least 0.4.12.

Removed ska-tango-images-tango-dependencies
-------------------------------------------

The image ska-tango-images-tango-dependencies has been removed.  This image was
never advertised and is considered by ska-tango-images as an implementation
detail, however, if you were using this image for some reason, you can find all
the same dependencies in the :ref:`ska-tango-images-tango-cpp` image.

.. _migration-0-6-removed-tangotest:

Removed TangoTest from ska-tango-images-tango-java
--------------------------------------------------

The ska-tango-images-tango-java:10.0.0 image no longer contains
``TangoTest``. ``TangoTest`` is not a java application and its inclusion in
ska-tango-images-tango-java is an historical accident.  Use the
:ref:`ska-tango-images-tango-test` image instead, which provides ``TangoTest``
as an entry point.

Notably, the ska-tango-base chart (version 0.4.15 and earlier) uses
ska-tango-images-tango-java as the image for ``deviceServers.tangotest``, using
the ``TangoTest`` binary.  If you wish to override the image used by
``deviceServers.tangotest`` from ska-tango-images-tango-java to an image
provided by this release then you must override it with
ska-tango-images-tango-test:3.10.0.

Deprecated ska-tango-images-tango-java
--------------------------------------

The ska-tango-images-tango-java is an implementation detail of how the images
are built (i.e. it does not appear in the catalogue) and will be removed in a
future version of ska-tango-images, as such this image can be considered
deprecated.  Uses of this image should be replaced with uses of the Java
application specific images:

    - :ref:`ska-tango-images-tango-jive`
    - :ref:`ska-tango-images-tango-pogo`
    - :ref:`ska-tango-images-rest-server`

As noted in :ref:`migration-0-6-removed-tangotest` uses of ``TangoTest`` from
ska-tango-images-tango-java should be replaced with
:ref:`ska-tango-images-tango-test`.


Deprecated ska-tango-images-tango-rest
--------------------------------------

The :ref:`ska-tango-images-tango-rest` image has been deprecated in favor of
:ref:`ska-tango-images-rest-server`.  The new
:ref:`ska-tango-images-rest-server` provides ``TangoRestServer`` as an entry
point, inline with other device server images, as opposed to using supervisord
to launch the device server.  The ska-tango-images-tango-rest:1.22.1 will be the
final release of this image.

See :ref:`rest-with-docker-compose` for details about deploying the
new image.
