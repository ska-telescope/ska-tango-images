# TANGO Docker containers

This project defines a set of Docker images and Charts files
that are useful for TANGO control system development.
See the documentation in the 'docs' folder for build and usage
instructions.

## Deprecation alerts

As of release 0.3.23 **tango-panic images will no longer be maintained** as these don't support python3.

## Docker hierarchy and release tagging

When updating Dockerfiles, and especially the tags in the `.release` files,
it is useful to know the hierarchy.  All downstream images must have the release
tags updated.

The release tags should match the underlying dependencies used where possible.

- ubuntu:22.04
  - tango-dependencies/Dockerfile:FROM ubuntu:22.04 as buildenv
  - tango-dependencies/Dockerfile:FROM ubuntu:22.04
    - tango-java/Dockerfile:FROM {nexus}/tango-dependencies
      - tango-jive/Dockerfile:FROM {nexus}/tango-java
      - tango-pogo/Dockerfile:FROM {nexus}/tango-java
      - tango-rest/Dockerfile:FROM {nexus}/tango-dependencies as buildenv
      - tango-rest/Dockerfile:FROM {nexus}/tango-java
      - tango-vnc/Dockerfile:FROM {nexus}/tango-java
    - tango-cpp/Dockerfile:FROM {nexus}/tango-dependencies as buildenv
    - tango-cpp/Dockerfile:FROM ubuntu:22.04
      - tango-libtango/Dockerfile:FROM {nexus}/tango-cpp
        - tango-admin/Dockerfile:FROM {nexus}/tango-libtango
        - tango-test/Dockerfile:FROM {nexus}/tango-libtango
        - tango-databaseds/Dockerfile:FROM {nexus}/tango-libtango
      - pytango-builder/Dockerfile:FROM {nexus}/tango-cpp
        - pytango-runtime/Dockerfile:FROM {nexus}/pytango-builder as buildenv
        - pytango-runtime/Dockerfile:FROM {nexus}/tango-cpp
          - tango-dsconfig/Dockerfile:FROM {nexus}/pytango-builder as buildenv
          - tango-dsconfig/Dockerfile:FROM {nexus}/pytango-runtime
          - tango-itango/Dockerfile:FROM {nexus}/pytango-builder as buildenv
          - tango-itango/Dockerfile:FROM {nexus}/pytango-runtime
          - tango-pytango/Dockerfile:FROM {nexus}/pytango-builder as buildenv
          - tango-pytango/Dockerfile:FROM {nexus}/pytango-runtime
- mariadb
  - tango-db/Dockerfile:FROM mariadb:10

## Building an image

To build all the images locally, run

```shell
make all
```

This will make sure that the images are built in the correct order and tag all
the images with "local".  These "local" tags are used as the default tags for
each of the dependency images.

To build an image and all it's dependencies use one of the `oci-build-<X>` make
targets. For example, to build ska-tango-images-tango-cpp run

```shell
make oci-build-tango-cpp
```

This will first build ska-tango-images-tango-dependencies and then
ska-tango-images-tango-cpp, using the ska-tango-images-tango-dependencies as the
build image.

These Makefile rules use files in `build/receipts` to keep track of which images
have been built and if they need updating.  This is a little fragile as the
receipts are not the actual artifacts we are interested in, so care
must be taken by the user that the receipts and the actual images do not get out
of sync.  If in doubt, you can run the following to remove all the receipts

```shell
make clean
```

If you want to force a particular image and all its dependencies to be built you
can remove the image's receipt and then run

```shell
make oci-build-<image-slug>
```

The Makefiles inspect the Dockerfiles to work out dependencies, so they do not
need updating when the dependency graph changes.

To build an image using dependencies that are pulled from the CI with a particular
tag use the following:

```shell
export CI_COMMIT_SHORT_SHA=<copied-from-pipeline>
make oci-build-with-deps OCI_IMAGE=ska-tango-images-<image-slug>
```

This will run exactly the same command as is run on the CI.  It will not tag the
resulting image with local.
