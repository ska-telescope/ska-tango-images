# TANGO OCI images

This project defines a set of Docker images and Charts files that are useful for
TANGO control system development. This README outlines how to build and test the
images, aimed at ska-tango-images developers. See the documentation in the
'docs' folder for usage instructions.

## Setup virtualenv

This repository uses poetry to manage test and documentation dependencies as
this fits in best with the .make infrastructure.  However, this repository
(currently) does not define a python module/package, as such, to install the
dependencies you must pass `--no-root` to poetry:

```
poetry install --no-root
```

## Docker hierarchy and release tagging

When updating Dockerfiles, and especially the tags in the `.release` files,
it is useful to know the hierarchy.  All downstream images must have the release
tags updated.

The release tags should match the underlying dependencies used where possible.

- {nexus}/ska-base / {nexus}/ska-build
  - tango-dependencies/Dockerfile:FROM {nexus}/ska-build AS build
  - tango-dependencies/Dockerfile:FROM {nexus}/ska-build
    - tango-base/Dockerfile:FROM {nexus}/ska-base
    - tango-cpp/Dockerfile:FROM {nexus}/tango-dependencies AS build
    - tango-cpp/Dockerfile:FROM {nexus}/ska-build
        - tango-admin/Dockerfile:FROM {nexus}/tango-cpp AS build
        - tango-admin/Dockerfile:FROM {nexus}/tango-base
          - tango-databaseds/Dockerfile:FROM {nexus}/tango-cpp AS build
          - tango-databaseds/Dockerfile:FROM {nexus}/tango-admin
          - hdbpp-cm/Dockerfile:FROM {nexus}/tango-cpp AS build
          - hdbpp-cm/Dockerfile:FROM {nexus}/tango-admin
          - hdbpp-es-timescaledb/Dockerfile:FROM {nexus}/tango-cpp AS build
          - hdbpp-es-timescaledb/Dockerfile:FROM {nexus}/tango-admin
          - tango-test/Dockerfile:FROM {nexus}/tango-cpp AS build
          - tango-test/Dockerfile:FROM {nexus}/tango-admin
          - tango-java/Dockerfile:FROM {nexus}/ska-build AS build
          - tango-java/Dockerfile:FROM {nexus}/tango-admin
            - tango-jive/Dockerfile:FROM {nexus}/tango-java
            - tango-pogo/Dockerfile:FROM {nexus}/tango-java
            - tango-rest/Dockerfile:FROM {nexus}/tango-java DEPRECATED
            - rest-server/Dockerfile:FROM {nexus}/tango-java
- {nexus}/ska-python / {nexus}/ska-build-python
  - ska-tango-images-tango-python:FROM ska-tango-images-tango-admin AS build
  - ska-tango-images-tango-python:FROM ska-python
    - tango-boogie/Dockerfile:FROM {nexus}/ska-build-python AS build
    - tango-boogie/Dockerfile:FROM {nexus}/ska-tango-images-tango-python
    - tango-dsconfig/Dockerfile:FROM {nexus}/ska-build-python AS build
    - tango-dsconfig/Dockerfile:FROM {nexus}/ska-tango-images-tango-python
    - tango-itango/Dockerfile:FROM {nexus}/ska-build-python AS build
    - tango-itango/Dockerfile:FROM {nexus}/ska-tango-images-tango-python
    - hdbpp-yaml2archiving/Dockerfile:FROM {nexus}/ska-build-python AS build
    - hdbpp-yaml2archiving/Dockerfile:FROM {nexus}/ska-tango-images-tango-python
- mariadb
  - tango-db/Dockerfile:FROM mariadb
- timescaledb
  - hdbpp-timescaledb/Dockerfile:FROM timescaledb

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

## Testing an image

To run all the tests (using local image tags) run:

```shell
make oci-tests
```

This will not build the images if they do not exist or are out of date.

You can specify the same commit sha as is used on the CI by exporting
`CI_COMMIT_SHORT_SHA` first, this will then pull the images from the CI:

```shell
export CI_COMMIT_SHORT_SHA=<copied from pipeline>
make oci-tests
```

You can also run the tests for an individual image with the `oci-test-<x>`
targets.  For example, to test ska-tango-images-tango-dsconfig:

```shell
make oci-test-tango-dsconfig
```

This will first build the image and all its dependencies if required.

## Gitlab CI

This repository has a generated .gitlab-ci.yml so that the dependency graph can
be determined from the Dockerfiles.

To regenerate the .gitlab-ci.yml, run the following and the commit the new
.gitlab-ci.yml.

```shell
make .gitlab-ci.yml
```

There is a job in the .gitlab-ci.yml that checks that this file is up-to-date.
It will fail the pipeline if this needs regenerating.

## Running documentation examples

When building locally, the documentation will generate examples which use the
"local" tags of the images.  This means if you have done a `make all` you should
be able to copy and paste the examples from the locally built documentation.
Unfortunately, running these examples is not yet automated.

The documentation can built locally by running:

```shell
make docs-build html
```

To view the locally built documentation run the python HTTP server from the
docs/build directory:

```shell
python -m http.server
```

The documentation will then be available at `0.0.0.0:8000` and any usage
examples can be copied from there and they should use the locally built images.

Some of the examples require a `TANGO_HOST` to run.  There is a docker compose
file at test/compose.yaml which will spin up a `TANGO_HOST` at
`localhost:10000`.  To use it run the following from the test directory:

```shell
docker compose up -d
export TANGO_HOST=localhost:10000
```

Similarly, any usage examples copied from the `doc-build` CI job output should
reference the `CI_COMMIT_SHORT_SHA` version of the images, meaning the examples
will use the version of the images built by that job.  To spin-up a `TANGO_HOST`
using the images built by the CI, you can copy the compose.yaml from the "How to
spin-up a Tango environment using Docker compose" page.
