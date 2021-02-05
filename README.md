# TANGO Docker containers

This project defines a set of Docker images and Charts files
that are useful for TANGO control system development.
See the documentation in the 'docs' folder for build and usage
instructions.


## Docker hierarchy and release tagging

When updating Dockerfiles, and especially the tags in the `.release` files,
it is useful to know the hierarchy.  All downstream images must have the release
tags updated.

The release tags should match the underlying dependencies used.  E.g., for the
first release of cppTango 9.3.4-rc4, use the tag `9.3.4-rc4`.  If there are
subsequent modifications to a Dockerfile, but still using that cppTango release,
add a suffix, e.g., `9.3.4-rc4.1`.  Further changes would then incremenent that
suffix: `9.3.4-rc4.2`, etc.

- ubuntu
  - deploy/Dockerfile:FROM ubuntu:18.04
  - tango-builder/Dockerfile:FROM ubuntu:18.04
- debian-buster-slim
  - tango-dependencies/Dockerfile:FROM debian:buster-slim as buildenv
  - tango-dependencies/Dockerfile:FROM debian:buster-slim
    - tango-java/Dockerfile:FROM {nexus}/tango-dependencies
        - hdbpp_viewer/Dockerfile:FROM {nexus}/tango-java
        - tango-jive/Dockerfile:FROM {nexus}/tango-java
        - tango-pogo/Dockerfile:FROM {nexus}/tango-java
        - tango-rest/Dockerfile:FROM {nexus}/tango-dependencies as buildenv
        - tango-rest/Dockerfile:FROM {nexus}/tango-java
        - tango-vnc/Dockerfile:FROM {nexus}/tango-java
    - tango-cpp/Dockerfile:FROM {nexus}/tango-dependencies as buildenv
    - tango-cpp/Dockerfile:FROM debian:buster-slim
      - tango-archiver/Dockerfile:FROM {nexus}/tango-cpp
      - tango-libtango/Dockerfile:FROM {nexus}/tango-cpp
        - tango-admin/Dockerfile:FROM {nexus}/tango-libtango
        - tango-test/Dockerfile:FROM {nexus}/tango-libtango
        - tango-databaseds/Dockerfile:FROM {nexus}/tango-libtango
      - pytango-builder/Dockerfile:FROM {nexus}/tango-cpp
        - pytango-panic/Dockerfile:FROM {nexus}/pytango-builder as buildenv
        - pytango-panic-gui/Dockerfile:FROM {nexus}/pytango-builder as buildenv
        - pytango-runtime/Dockerfile:FROM {nexus}/pytango-builder as buildenv
        - pytango-runtime/Dockerfile:FROM {nexus}/tango-cpp
          - tango-dsconfig/Dockerfile:FROM {nexus}/pytango-builder as buildenv
          - tango-dsconfig/Dockerfile:FROM {nexus}/pytango-runtime
          - tango-itango/Dockerfile:FROM {nexus}/pytango-builder as buildenv
          - tango-itango/Dockerfile:FROM {nexus}/pytango-runtime
          - tango-pytango/Dockerfile:FROM {nexus}/pytango-builder as buildenv
          - tango-pytango/Dockerfile:FROM {nexus}/pytango-runtime
      - tango-starter/Dockerfile:FROM {nexus}/tango-cpp
- mariadb
  - tango-db/Dockerfile:FROM mariadb:10

If the Docker image tags change, then the related charts should also be updated:
- In the `charts` folder, update all the `values.yaml` files to use the new tags.
- If any of the `values.yaml` files changed, the corresponding `Chart.yaml` file
  must have the `version` field incremented.  Similarly for any dependent `Chart.yaml`
  files.  The `appVersion` field gets updated as well, if was in sync with the
  `version` field.
