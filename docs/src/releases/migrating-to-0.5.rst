================
Migrating to 0.5
================

This migration guide lists all the OCI images removed in the ska-tango-images
release 0.5.0.  Developers using these OCI images to build their own images will
need to update Dockerfiles. This guide provides alternative images that can be
used where possible.  This guide also provides information about how
ska-tango-images is going to handle breaking changes going forward.

In some cases, no alternative image is provided for a removed image.  If you are
relying on such an image, please get in touch with either Team Wombat (or email
`oci-support@skao.int` if external to SKAO) and we can consider re-adding the
image or adding a replacement for your use case.

Note, that the OCI images produced by ska-tango-images have their own version
number, see :ref:`changelog` for a list of image tags released with version
0.5.0 of ska-tango-images.

New interface definition for OCI images
---------------------------------------

Prior releases of ska-tango-images did not explicitly define the "interface" for
the OCI images produced, that is, there is no definition of what a user of the
image is allowed to rely on.  This makes it difficult to define what constitutes
a breaking change for these images.

The ska-tango-images 0.5.0 includes a :ref:`image-catalogue` which is a first
step to trying to define the interface for these images.  It is almost certainly
not complete.  Any changes to interfaces defined in this catalogue will be
considered breaking.  If you are relying on some behaviour of the existing images
which is not listed in :ref:`image-catalogue`, please contact Team Wombat (or email
`oci-support@skao.int`) and we can consider adding your use case to the
interface.

With the ska-tango-images 0.5.0 release all the existing OCI images have been
updated to use the images provided by `ska-base-images
<https://gitlab.com/ska-telescope/ska-base-images>`_.  This was intended to not
be a breaking change and has not broken the interface defined in the
:ref:`image-catalogue`.

Removed PyTango images
----------------------

As of the 0.5.0 release, the following images are no longer provided by ska-tango-images:

- ska-tango-images-pytango-builder
- ska-tango-images-pytango-runtime
- ska-tango-images-tango-pytango (alias for ska-tango-images-pytango-runtime)

Dockerfiles using of ska-tango-images-pytango-builder as a build image
should use ska-python-build as a build image instead. Uses of
ska-tango-images-pytango-runtime (and ska-tango-images-tango-pytango) should be
replaced with ska-tango-images-tango-python. The ska-python-build image is
provided by `ska-base-images <https://gitlab.com/ska-telescope/ska-base-images>`_.

Unlike the old ska-tango-images-pytango-runtime, the new
ska-tango-images-tango-python does not include PyTango.  Developers are now
expected to install the wheel of PyTango as a normal dependency when building
their own OCI images for PyTango applications.  See :ref:`build-pytango-image`
for guidelines on how to do this.

Removed ska-tango-images-tango-libtango
---------------------------------------

The ska-tango-images-tango-libtango is an alias for ska-tango-images-tango-cpp.
Uses of ska-tango-images-tango-libtango can be replaced with
ska-tango-images-tango-cpp without any additional changes.

Removed panic images
--------------------

The ska-tango-images-tango-panic and ska-tango-images-tango-panic-gui images are
no longer built by ska-tango-images.  There is currently no alternatives
provided, however, if you are using these images please get in touch with Team
Wombat (or email `oci-support@skao.int`) and we can consider re-adding the
images or providing alternatives.

Removed ska-tango-images-tango-vnc
----------------------------------

The ska-tango-images-tango-vnc image is no longer provided.  There is no plans
for ska-tango-images to provide an alternative.
