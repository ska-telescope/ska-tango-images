.. skeleton documentation master file, created by
   sphinx-quickstart on Thu May 17 15:17:35 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

SKA OCI Images
==============

This project defines a set of OCI images for TANGO control system development.
Each OCI image has an independent version, unrelated to the version of
ska-tango-images itself. These version numbers loosely based on the "principle
upstream package" they provide, for example, the
:ref:`ska-tango-images-tango-admin` image's version number is based on the
version of ``tango_admin`` which is installed.  If a new version of the image is
released without updating the principle upstream package then the patch version
number will be bumped.

This means that for each image the major and minor version numbers will match
the version number of the principle upstream package and the patch version will
always be greater than or equal to the patch version of the principle upstream
package.

In general the principle upstream package can be inferred from the name of the
image, the only exception to this is :ref:`ska-tango-images-tango-itango`, which has
``PyTango`` as its principle upstream package and not ``itango``.

See the `change log <releases/changelog.html>`_ for a (abridged) bill of materials
for all the images released with a particular release.  See the
:ref:`image-catalogue` below for more details on what each image provides.

Helm Charts
-----------

Historically, ska-tango-images provided two helm charts called ``ska-tango-base``
and ``ska-tango-util``. These charts have been moved to the `ska-tango-charts
<https://developer.skao.int/projects/ska-tango-charts/>`_ repository and are no
longer provided here.

.. toctree::
  :maxdepth: 1
  :caption: How-To Guides

  how-to/basic-docker-compose
  how-to/build-cpptango-image
  how-to/build-pytango-image
  how-to/rest-with-docker-compose
  how-to/hdbpp-with-docker-compose

.. _image-catalogue:
.. toctree::
  :maxdepth: 1
  :caption: OCI Image Catalogue

  catalogue/ska-tango-images-tango-base
  catalogue/ska-tango-images-tango-cpp
  catalogue/ska-tango-images-tango-admin
  catalogue/ska-tango-images-tango-db
  catalogue/ska-tango-images-tango-databaseds
  catalogue/ska-tango-images-tango-test
  catalogue/ska-tango-images-tango-python
  catalogue/ska-tango-images-tango-dsconfig
  catalogue/ska-tango-images-tango-itango
  catalogue/ska-tango-images-tango-boogie
  catalogue/ska-tango-images-tango-jive
  catalogue/ska-tango-images-tango-pogo
  catalogue/ska-tango-images-tango-rest
  catalogue/ska-tango-images-rest-server
  catalogue/ska-tango-images-hdbpp-timescaledb
  catalogue/ska-tango-images-hdbpp-cm
  catalogue/ska-tango-images-hdbpp-es-timescaledb
  catalogue/ska-tango-images-hdbpp-yaml2archiving

.. toctree::
  :titlesonly:
  :caption: Releases

  releases/migrating-to-0.5
  releases/migrating-to-0.6
  releases/changelog
