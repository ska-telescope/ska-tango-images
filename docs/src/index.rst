.. skeleton documentation master file, created by
   sphinx-quickstart on Thu May 17 15:17:35 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

SKA OCI Images
=================

This project defines a set of OCI images for TANGO control system development.

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

.. toctree::
  :titlesonly:
  :caption: Releases

  releases/changelog
