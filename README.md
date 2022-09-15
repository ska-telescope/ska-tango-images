# TANGO Docker containers

This project defines a set of Docker images and Charts files
that are useful for TANGO control system development.
See the documentation in the 'docs' folder for build and usage
instructions.


## Docker hierarchy and release tagging

When updating Dockerfiles, and especially the tags in the `.release` files,
it is useful to know the hierarchy.  All downstream images must have the release
tags updated.

The release tags should match the underlying dependencies used where possible.

- debian-buster-slim
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
- mariadb
  - tango-db/Dockerfile:FROM mariadb:10

If the Docker image tags change, then the related charts should also be updated:
- In the `charts` folder, update all the `values.yaml` files to use the new tags.
- If any of the `values.yaml` files changed, the corresponding `Chart.yaml` file
  must have the `version` field incremented.  Similarly for any dependent `Chart.yaml`
  files.  The `appVersion` field gets updated as well, if was in sync with the
  `version` field.

## `make-a-release`

There is a make target provided that is a guide that steps you through the process of making a release.  This will run the various sub-targets in the right sequence to ensure a complete release is done for OCI images and Helm Charts.

Run:
```
$ make make-a-release
```

The following is a sample flow of the guided release process:
```
This is a guild to creating a release of ska-tango-images, including OCI Images and Helm Charts.
 You  🔥MUST🔥 first have merged your Merge Request!!!
The steps are:
 * git checkout master && git pull
 * Select and bump OCI Image .release's
 * bump project .release  AND update Helm Chart release  AND the tango-util version dependency in tango-base
 * Commit .release and ANY outstanding changes, and set project git tag
 * Push changes and tag

 ✋ The current git status (outstanding) is:
 On branch master
Your branch is up-to-date with 'origin/master'.

nothing to commit, working tree clean
Do you wish to continue (you will be prompted at each step) [N/y]: y
❗ OK - lets build a release ...

Step 1: >> git checkout master && git pull
switching from branch: master to master
Do you wish to continue (you will be prompted at each step) [N/y]: y
 OK - ✨ lets switch to master and pull ...
Already on 'master'
Your branch is up-to-date with 'origin/master'.
Already up-to-date.

Step 2: Select and bump OCI Image .release's
 Tell me which of the following OCI_IMAGES_TO_PUBLISH list to bump patch release for: ska-tango-images-tango-dependencies ska-tango-images-tango-dependencies-alpine ska-tango-images-tango-db ska-tango-images-tango-cpp ska-tango-images-tango-cpp-alpine ska-tango-images-tango-java ska-tango-images-tango-java-alpine ska-tango-images-tango-rest ska-tango-images-pytango-builder ska-tango-images-pytango-builder-alpine ska-tango-images-tango-pogo ska-tango-images-tango-libtango ska-tango-images-tango-jive ska-tango-images-pytango-runtime ska-tango-images-pytango-runtime-alpine ska-tango-images-tango-admin ska-tango-images-tango-databaseds ska-tango-images-tango-test ska-tango-images-tango-dsconfig ska-tango-images-tango-itango ska-tango-images-tango-vnc ska-tango-images-tango-pytango ska-tango-images-tango-panic ska-tango-images-tango-panic-gui
Enter list here: ska-tango-images-tango-dependencies ska-tango-images-tango-dependencies-alpine

 You provided: ska-tango-images-tango-dependencies ska-tango-images-tango-dependencies-alpine
Do you wish to continue (you will be prompted at each step) [N/y]: y
 OK - ✨ bumping patch .release files ...
make[1]: Entering directory '/home/piers/git/public/ska-telescope/ska-tango-images'
make bump-patch-release RELEASE_CONTEXT_DIR=images/ska-tango-images-tango-dependencies;  make bump-patch-release RELEASE_CONTEXT_DIR=images/ska-tango-images-tango-dependencies-alpine;
make[2]: Entering directory '/home/piers/git/public/ska-telescope/ska-tango-images'
set-release: 9.3.7
make[2]: Leaving directory '/home/piers/git/public/ska-telescope/ska-tango-images'
make[2]: Entering directory '/home/piers/git/public/ska-telescope/ska-tango-images'
set-release: 0.2.4
make[2]: Leaving directory '/home/piers/git/public/ska-telescope/ska-tango-images'
make[1]: Leaving directory '/home/piers/git/public/ska-telescope/ska-tango-images'

Step 3: Bump project .release AND update Helm Chart release
Do you wish to continue (you will be prompted at each step) [N/y]: y
 OK - ✨ bumping patch on project .release file and updating Helm Charts ...
make[1]: Entering directory '/home/piers/git/public/ska-telescope/ska-tango-images'
set-release: 0.2.28
make[1]: Leaving directory '/home/piers/git/public/ska-telescope/ska-tango-images'
make[1]: Entering directory '/home/piers/git/public/ska-telescope/ska-tango-images'
helm-set-release: 0.2.28
make[1]: Leaving directory '/home/piers/git/public/ska-telescope/ska-tango-images'

 ✋ The updated git status (outstanding) is:
 On branch master
Your branch is up-to-date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   .release
	modified:   charts/ska-tango-base/Chart.yaml
	modified:   charts/ska-tango-util/Chart.yaml
	modified:   images/ska-tango-images-tango-dependencies-alpine/.release
	modified:   images/ska-tango-images-tango-dependencies/.release

no changes added to commit (use "git add" and/or "git commit -a")

 ✋ The git diff is:
 diff --git a/.release b/.release
index 6158cb3..f96ae41 100644
--- a/.release
+++ b/.release
@@ -1,2 +1,2 @@
-release=0.2.27
-tag=0.2.27
+release=0.2.28
+tag=0.2.28
diff --git a/charts/ska-tango-base/Chart.yaml b/charts/ska-tango-base/Chart.yaml
index 723d143..56a22e6 100644
--- a/charts/ska-tango-base/Chart.yaml
+++ b/charts/ska-tango-base/Chart.yaml
@@ -1,11 +1,11 @@
 apiVersion: v2
-appVersion: "1.0"
+appVersion: 0.2.28
 description: A Helm chart for deploying the TANGO base system on Kubernetes
 name: ska-tango-base
-version: 0.2.25
+version: 0.2.28
 icon: https://www.skatelescope.org/wp-content/uploads/2016/07/09545_NEW_LOGO_2014.png
 dependencies:
 - name: ska-tango-util
-  version: 0.2.14
+  version: 0.2.28
   repository: file://../ska-tango-util

diff --git a/charts/ska-tango-util/Chart.yaml b/charts/ska-tango-util/Chart.yaml
index e41b291..81892f7 100644
--- a/charts/ska-tango-util/Chart.yaml
+++ b/charts/ska-tango-util/Chart.yaml
@@ -2,8 +2,8 @@ apiVersion: v2
 description: A Helm chart library of utilities for TANGO deployents
 name: ska-tango-util
 type: library
-appVersion: 0.2.14
-version: 0.2.14
+appVersion: 0.2.28
+version: 0.2.28
 icon: https://www.skatelescope.org/wp-content/uploads/2016/07/09545_NEW_LOGO_2014.png
 maintainers:
 - name: Matteo Di Carlo
diff --git a/images/ska-tango-images-tango-dependencies-alpine/.release b/images/ska-tango-images-tango-dependencies-alpine/.release
index aad0434..7b0cabe 100644
--- a/images/ska-tango-images-tango-dependencies-alpine/.release
+++ b/images/ska-tango-images-tango-dependencies-alpine/.release
@@ -1,2 +1,2 @@
-release=0.2.3
-tag=0.2.3
+release=0.2.4
+tag=0.2.4
diff --git a/images/ska-tango-images-tango-dependencies/.release b/images/ska-tango-images-tango-dependencies/.release
index e35fea8..d893a90 100644
--- a/images/ska-tango-images-tango-dependencies/.release
+++ b/images/ska-tango-images-tango-dependencies/.release
@@ -1,2 +1,2 @@
-release=9.3.6
-tag=9.3.6
+release=9.3.7
+tag=9.3.7

Step 4: Commit .release and ANY outstanding changes, and set project git tag
Do you wish to continue (you will be prompted at each step) [N/y]: y
 OK - ✨ doing commit and tag ...
make[1]: Entering directory '/home/piers/git/public/ska-telescope/ska-tango-images'
0.2.28
git says you have the following outstanding changes:
  M .release
 M charts/ska-tango-base/Chart.yaml
 M charts/ska-tango-util/Chart.yaml
 M images/ska-tango-images-tango-dependencies-alpine/.release
 M images/ska-tango-images-tango-dependencies/.release
Do you wish to continue (will commit outstanding changes) [N/y]: y
OK - commiting changes...
[master c647c4f] bumped version to 0.2.28
 5 files changed, 11 insertions(+), 11 deletions(-)
0.2.28
make[1]: Leaving directory '/home/piers/git/public/ska-telescope/ska-tango-images'

Step 5: Push changes and tag
Do you wish to continue (you will be prompted at each step) [N/y]: y
 OK - ✨ doing push ...
make[1]: Entering directory '/home/piers/git/public/ska-telescope/ska-tango-images'
0.2.28
Enumerating objects: 25, done.
Counting objects: 100% (25/25), done.
Delta compression using up to 12 threads
Compressing objects: 100% (10/10), done.
Writing objects: 100% (13/13), 1.81 KiB | 462.00 KiB/s, done.
Total 13 (delta 6), reused 0 (delta 0), pack-reused 0
To gitlab.com:ska-telescope/ska-tango-images.git
   bf3ebe5..c647c4f  master -> master
Enumerating objects: 1, done.
Counting objects: 100% (1/1), done.
Writing objects: 100% (1/1), 152 bytes | 152.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0), pack-reused 0
To gitlab.com:ska-telescope/ska-tango-images.git
 * [new tag]         0.2.28 -> 0.2.28
make[1]: Leaving directory '/home/piers/git/public/ska-telescope/ska-tango-images'
🌟 All done! 🌟
```
