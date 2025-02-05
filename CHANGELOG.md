# Changelog

## unrelease

### Breaking Changes

- WOM-517: Remove TangoTest from ska-tango-images-tango-java

### Other Changes

- WOM-517: Add ska-tango-images-rest-server
- WOM-517: Fix the supervisord script for ska-tango-images-tango-rest
- WOM-567: Align TangoDatabase version for ska-tango-images-tango-db and
ska-tango-images-tango-dbds, moving to InnoDB backend.
- WOM-612: Add HDB++ images
- WOM-612: Fix copying library symlinks into ska-tango-images-tango-admin

### Added images

- ska-tango-images-hdbpp-cm
- ska-tango-images-hdbpp-timescaledb
- ska-tango-images-hdbpp-es-timescaledb
- ska-tango-images-hdbpp-yaml2archiving
- ska-tango-images-rest-server

### Deprecated images

- ska-tango-images-tango-rest

## [0.5.1]

### Changes

- WOM-601: Update poetry example to actually install the application
- WOM-601: No longer include `pip` in python runtime image virtual environments
- WOM-603: Pin numpy version to version 1
- WOM-606: Fix ska-tango-images-tango-databaseds example

### Published Images

- ska-tango-images-tango-boogie:0.1.1
  + Boogie commit 0613475efe44583e3cf724478ef6326e75a52493
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + NumPy 1.26.4
  + omniORB 4.3.1
  + PyTango 9.5.0
  + ska-base 0.1.0
  + ska-build 0.1.1
  + ska-build-python 0.1.1
  + ska-python 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-dsconfig:1.7.2
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + dsconfig 1.7.1
  + NumPy 1.26.4
  + omniORB 4.3.1
  + PyTango 9.5.0
  + ska-base 0.1.0
  + ska-build 0.1.1
  + ska-build-python 0.1.1
  + ska-python 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-itango:9.5.2
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + itango 0.1.9
  + NumPy 1.26.4
  + omniORB 4.3.1
  + PyTango 9.5.0
  + ska-base 0.1.0
  + ska-build 0.1.1
  + ska-build-python 0.1.1
  + ska-python 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4

## [0.5.0]

### Changes

- WOM-512, WOM-513, WOM-568, WOM-570: Add user facing documentation
- WOM-461: Add Boogie OCI image
- WOM-459, WOM-516: Refactor OCI image hierarchy to use ska-base-image
- WOM-467: Add tests for OCI images
- WOM-485: Remove charts, now available at ska-tango-charts

### Published Images

- ska-tango-images-tango-admin:1.17.1
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + omniORB 4.3.1
  + ska-base 0.1.0
  + ska-build 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-base:0.1.0
  + ska-base 0.1.0
- ska-tango-images-tango-boogie:0.1.0
  + Boogie commit 0613475efe44583e3cf724478ef6326e75a52493
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + omniORB 4.3.1
  + PyTango 9.5.0
  + ska-base 0.1.0
  + ska-build 0.1.1
  + ska-build-python 0.1.1
  + ska-python 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-cpp:9.5.1
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + omniORB 4.3.1
  + ska-build 0.1.1
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-databaseds:5.22.2
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + omniORB 4.3.1
  + ska-base 0.1.0
  + ska-build 0.1.1
  + tango_admin 1.17
  + TangoDatabase 5.22
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-db:11.0.3
  + MariaDB docker image 11.0.2-jammy
  + SQL DB from TangoDatabase 5.16
- ska-tango-images-tango-dependencies:9.5.1
  + cppZMQ 4.8.1
  + omniORB 4.3.1
  + ska-build 0.1.1
  + ZeroMQ 4.3.4
- ska-tango-images-tango-dsconfig:1.7.1
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + dsconfig 1.7.1
  + omniORB 4.3.1
  + PyTango 9.5.0
  + ska-base 0.1.0
  + ska-build 0.1.1
  + ska-build-python 0.1.1
  + ska-python 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-itango:9.5.1
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + itango 0.1.9
  + omniORB 4.3.1
  + PyTango 9.5.0
  + ska-base 0.1.0
  + ska-build 0.1.1
  + ska-build-python 0.1.1
  + ska-python 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-java:9.5.1
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + Java applications from TangoSourceDistribution 9.5.0
  + log4j 1.2.17
  + omniORB 4.3.1
  + ska-base 0.1.0
  + ska-build 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + TangoTest 3.8
  + ZeroMQ 4.3.4
- ska-tango-images-tango-jive:7.36.1
  + ATK 9.3.28
  + ATK Panel 5.11
  + ATK Tuning 4.8
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + Jive 7.36
  + JTango 9.6.6
  + log4j 1.2.17
  + omniORB 4.3.1
  + ska-base 0.1.0
  + ska-build 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + TangoTest 3.8
  + ZeroMQ 4.3.4
- ska-tango-images-tango-pogo:9.8.1
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + JTango 9.6.6
  + log4j 1.2.17
  + omniORB 4.3.1
  + Pogo 9.8.0
  + ska-base 0.1.0
  + ska-build 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + TangoTest 3.8
  + ZeroMQ 4.3.4
- ska-tango-images-tango-python:0.1.0
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + omniORB 4.3.1
  + ska-base 0.1.0
  + ska-build 0.1.1
  + ska-python 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + ZeroMQ 4.3.4
- ska-tango-images-tango-rest:1.22.0
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + JTango 9.6.6
  + log4j 1.2.17
  + omniORB 4.3.1
  + ska-base 0.1.0
  + ska-build 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + TangoRestServer 1.22
  + TangoTest 3.8
  + ZeroMQ 4.3.4
- ska-tango-images-tango-test:3.8.1
  + cppTango 9.5.0
  + cppZMQ 4.8.1
  + omniORB 4.3.1
  + ska-base 0.1.0
  + ska-build 0.1.1
  + tango_admin 1.17
  + tango_idl 5.1.2
  + TangoTest 3.8
  + ZeroMQ 4.3.4

## [0.3.8]

### Jira Tickets

- ST-1174 - 

## [0.3.2]

### Jira Tickets



### Commits

- bumped version to 0.3.2

## [0.3.1]

### Jira Tickets

- ST-970
- ST-974
- ST-966


### Commits

- bumped version to 0.3.1
- Merge branch 'st-970-add-image-tests' into 'master'
- ST-970: try try again
- ST-970: add gnu tar to tigango-alpine
- ST-970: add python to java-alpine
- ST-970: add tango-rest-alpine
- ST-970: add python3-dev to runtime
- Merge branch 'st-974-publish-charts' into 'master'
- ST-970: remove importlib from itango requirements
- ST-970: add pythonpath to itango-alpine
- ST-970: fix runtime
- ST-970: fix the runtime
- ST-970: fix runtime-alpine image
- ST-970: fix runtime-alpine image
- ST-970: fix runtime-alpine image
- ST-970: fix db
- ST-970: fix tangodb
- ST-970: fix pipeline for db-alpine
- Merge branch 'st-970-add-image-tests' of https://gitlab.com/ska-telescope/ska-tango-images into st-970-add-image-tests
- ST-970: update alpine images
- ST-970: db-alpine should be built after cpp-alpine
- ST-970: remove wrong folder
- ST-970: enable tests
- ST-970: update alpine images
- ST-970: update alpines
- ST-974: Bumped up the helm chart versions Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- Merge branch 'st-974-tango-util-readiness-liveness-probes' into 'master'
- ST-974: Handle undefined annotations tag in values.yaml file Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-974: Fixed the pipeline for the failing docs-pages job Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-974: Commented out the duplicated 'global' key Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-974: Removed the command generated from the entrypoint tag Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-974: Fixed the probes' ping commands to execute successfully
- ST-974: Fixed generation of probe's command for multidevices - Included the entrypoint generation when the tag is present in the values.yaml file. - Updated the tests.
- ST-974: Removed redundant print statements
- ST-974: Fix generation of the probe command string generation
- ST-974: Set the initialDelaySeconds parameter to default value 0
- ST-974: Update sub-modules
- ST-974: Updated tests to handle cases where the livenessProbe/readinessProbe tag is not specified Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-974: Added the chart_test target and test-chart-templates job in the Makefile and gitlab, respectively Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-974: Added tests to ensure correct generation of probes Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-974: Added support for liveness and readiness probes for tango-util Co-authored-by: Abhijeet Deolalikar <abhijeet_deolalikar@persistent.com>
- ST-966: makefile submodule with master branch

## [0.0.123]

### Jira Tickets

- ST-966
- ST-933
- ST-915


### Commits

- ST-966: Trigger Pipeline
- ST-966: branch name fix
- ST-966: make directory branch on st-940, changelog template job added
- Merge branch 'st-933-publish-raw-packages'
- ST-933: tangodb image reverted
- ST-933: uncomment ci jobs for merge request
- St-933: change raw template ref to master
- ST-933: clean raw artifacts
- ST-933: update makefile submodule
- Merge branch 'st-915-add-java' into 'master'
- ST-915: bum java-alpine
- Merge branch 'st-915-add-cpp-family' into 'master'
- ST-915: bump libtango and its children
- Merge branch 'st-915-add-cpp-family' into 'master'
- ST-915: bump itango-alpine
- Merge branch 'st-915-add-cpp-family' into 'master'
- ST-915: bump dsconfig-alpine
- Merge branch 'st-915-add-cpp-family' into 'master'
- ST-915: bump runtime-alpine
- ST-915: bump builder-alpine
- ST-915: bump builder-alpine
- Merge branch 'st-915-add-cpp-family' into 'master'
- ST-915: bump cpp-alpine
- Merge branch 'st-915-add-cpp-family' into 'master'
- ST-915: bump dependencies-alpine
- ST-933: Trigger Build
- ST-933: package raw debug
- ST-933: submodule update
- ST-933: update make submodule and bug fixes
- St-933: rmeove pipeline jobs to make debug simpler
- ST-933: add submodule
- Merge remote-tracking branch 'origin/st-915-reorganise-structure' into st-933-publish-raw-packages
- ST-933: smaller raw test files
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: add release file
- ST-933: Trigger Build
- ST-933: Trigger Build
- ST-933: clone test
- ST-933: raw include path fix
- ST-933: Trigger Build
- ST-933: remove test job
- ST-933: comment unnecessary jobs for testing
- ST-933: file name fix
- ST-933: ref fix
- ST-933: add ref to include job
- ST-933: test raw publish job
- ST 933 remove one version of tango
- ST-933: created raw directory with dependencies

## [0.2.30]

### Jira Tickets

- ST-915


### Commits

- bumped version to 0.2.30
- Merge branch 'st-915-fix-pub-check' into 'master'
- ST-915: reenable all stages
- ST-915: update .make
- ST-915: update .make
- ST-915: fix pre-pub check

## [0.2.29]

### Jira Tickets

- ST-915


### Commits

- bumped version to 0.2.29
- Merge branch 'st-915-update-make' into 'master'
- ST-915: correct rc handling
- ST-915: describe make-a-release

## [0.2.28]

### Jira Tickets

- ST-915


### Commits

- bumped version to 0.2.28
- Merge branch 'st-915-update-make' into 'master'
- ST-915: update .make, add messages
- Merge branch 'st-915-version-for-utils' into 'master'
- ST-915: bump version of utils used in tango base
- Merge branch 'st-915-wrong-version' into 'master'
- ST-915: get the correct VERSION
- Merge branch 'st-915-missing-helm-dep' into 'master'
- ST-915: bad copy paste
- ST-915: update missing helm dep for utils
- Merge branch 'st-915-update-make' into 'master'
- ST-915: update .make
- Merge branch 'st-915-wrong-helm-target' into 'master'
- ST-915: wrong helm set release target
- Merge branch 'st-915-update-make' into 'master'
- ST-915: add git status
- ST-915: update .make
- Merge branch 'st-915-update-make' into 'master'
- ST-915: update .make
- Merge branch 'st-915-make-a-release' into 'master'
- ST-915: make a release helper
- Merge branch 'st-915-no-test-on-master' into 'master'
- ST-915: fix detached pipeline
- ST-915: retrigger pipeline
- ST-915: add make-a-release target
- ST-915: update .make
- ST-915: no test on master merge

## [0.2.27]

### Jira Tickets

- ST-915


### Commits

- bumped version to 0.2.27
- Merge branch 'st-915-update-make' into 'master'
- ST-915: update make
- Merge branch 'st-915-correct-tag-build' into 'master'
- ST-915: update .make
- ST-915: fix release in tag commit message
- Merge branch 'st-915-add-images-to-publish' into 'master'
- ST-915: remove images again as they are not available
- ST-915: add images to publish
- Merge branch 'st-915-add-java' into 'master'
- ST-915: add jive-alpine
- ST-915: halve image size
- Merge branch 'st-915-add-java' into 'master'
- ST-915: use mock version for builder
- ST-915: bump java-alpine version
- ST-915: add java-alpine
- Merge branch 'st-915-add-java' into 'master'
- ST-915: add java-alpine
- Merge branch 'st-915-fix-database' into 'master'
- ST-915: use tango source 9.3.4 to build cpp-alpine

## [0.2.26]

### Jira Tickets

- ST-915


### Commits

- bumped version to 0.2.26-dirty
- Merge branch 'st-915-update-make-remove-debug' into 'master'
- ST-915: add publish step
- ST-915: update .make
- ST-915: generate values.yaml
- ST-915: generate values before test
- ST-915: auto-generate charts/ska-tango-base/values.yaml
- ST-915: build on tag and update .make
- ST-915: switch to "merge_request_event"
- ST-915: update .make to remove debugging

## [ska-tango-images-0.2.25]

### Jira Tickets

- ST-915
- ST-909
- ST-901
- ST-835
- ST-828
- ST-834
- ST-833
- AT-47
- ST-811
- SKA-811
- ST-812
- ST-796
- ST-758
- ST-703
- ST-725
- ST-639
- MCCS-307
- ST-625
- ST-581
- ST-562
- ST-569
- ST-515


### Commits

- bumped to version 0.2.25
- Merge branch 'st-915-update-make-and-release' into 'master'
- ST-915: test pre-pull of image to build
- ST-915: update make
- Merge branch 'st-909-set-initial-release' into 'master'
- ST-909: set the initial .release
- Merge branch 'st-915-reorganise-structure' into 'master'
- ST-915: dummy htmlcov report dir
- ST-915: fix relative dirs in test
- ST-915: remove linting from test
- ST-915: fix tar strip
- ST-915: fix tests - strip leading dirs
- ST-915: remove alpine from tests and deployment
- ST-915: enable publish steps
- Merge remote-tracking branch 'origin/st-915-reorganise-structure' into st-915-reorganise-structure
- ST-915: debugging tests
- Merge branch 'st-915-reorganise-structure' of https://gitlab.com/ska-telescope/ska-tango-images into st-915-reorganise-structure
- ST-915: bump versions
- ST-915: set registry and tags
- ST-915: update .make
- ST-915: move test directories
- ST-915: need to point to the Makefile
- Merge remote-tracking branch 'origin/st-915-reorganise-structure' into st-915-reorganise-structure
- ST-915: add back in tests
- ST-915: bump versions in cpp-alpine
- Merge branch 'st-915-reorganise-structure' of https://gitlab.com/ska-telescope/ska-tango-images into st-915-reorganise-structure
- ST-915: bump dependencies-alpine version
- ST-915: update all step rules
- ST-915: readd FORCE_REBUILD
- ST-915: testing only push events
- ST-915: testing only changes rules
- ST-915: change if rules for push and mr event only
- ST-915: Revert mr event update
- ST-915: disable for mr events
- ST-915: delete when:never as it makes it omitted always
- ST-915: test if rules
- ST-915: if syntax broken
- ST-915: switch to rules
- ST-915: force rebuild of all images, and reenable tests
- ST-915: mssing ${VERS}
- ST-915: debug vars
- ST-915: test dynamic versions
- ST-915: dynamically grap base/build versions
- ST-915: update .make
- ST-915: reenable  only:s
- sST-915: fix alpine pytango builder/runtime version refs
- ST-915: update .make
- ST-915: add build_5
- ST-915: wrong .release for pytango-runtime
- ST-915: wrong version pytango-builder-alpine
- ST-915: wrong version of cpp-alpine
- ST-915: remove old make structure
- ST-915: add build_4
- ST-915: add in build_3
- ST-915: do all build_2
- ST-915: do all build_1
- ST-915: switch to context .release file
- ST-915: update .make
- ST-915: add .release
- ST-915: different login
- ST-915: add docker login
- ST-915: add project name to registry
- ST-915: switch to master on templates
- ST-915: remove sudo from Dockerfile
- ST-915: use .make oci-lint
- ST-901: update .make and disable lint
- ST-901: switch to https clone for .make
- ST-901: change submodule strategy
- ST-915: remove only changes
- ST-915: focus on dependencies
- ST-915: reorganise build steps
- ST-915: add stage build_5
- ST-915: add pages stage
- ST-915: adjust stages
- ST-915: fix template ref
- ST-915: add in alpine rework
- ST-915: basic restructure
- ST-915: rename individual image sub dirs
- ST-915: restructure for standard layout
- ST-915: add .make submodule
- Merge branch 'st-915-dependencies' into 'master'
- ST-915: install cpp zmq at v4.7.1
- ST-915: add src folder
- ST-915: revert cpp-alpine to docker 3.8
- ST-915: add tango dependencies alpine
- Merge branch 'st-835' into 'master'
- ST-835: fix linting
- ST-835: revert itango-alpine inclusion
- ST-828: fix pytango version in itango-alpine dockerfile
- ST-835: small change to force publishing image
- ST-835: add itango-alpine to pipeline
- ST-835: add itango-alpine
- ST-835: change versions
- ST-835: fix permissions
- ST-835: update versions
- ST-835: update versions
- ST-835: update versions
- ST-835: update versions
- ST-835: update versions
- ST-835: fix
- ST-835: add a few more links
- ST-835: add sudo package to tango-cpp-alpine
- ST-835: add tango to sudoers in tango-cpp-alpine
- ST-835: add missing lines to tango-cpp-alpine
- ST-835: try python 3.10 again
- ST-835: revert to python 3.8
- ST-835: revert changes
- ST-835: update builder version
- ST-835: rm env variable for CAR_PYPI_REPOSITORY_URL from dockerfiles
- ST-835: create pytango runtime alpine image
- ST-835: update alpine image
- ST-835: fix wrong name for requirements file
- ST-835: fix wrong name for tango-cpp-alpine, it was missing tango
- ST-835: check if scripts are running fine by using another pytango-builder image
- ST-835: check if scripts are running fine by using another pytango-builder image
- ST-835: revert changes
- ST-835: add missing car arg for pytango-builder-alpine
- ST-835: add missing car arg for pytango-builder-alpine
- ST-835: update pip.conf file for pytango-builder-alpine
- ST-835: update pipeline to create pytango-builder-alpine
- ST-835: small change to cpp-alpine
- ST-835: update pipeline to create cpp-alpine
- ST-835: create tango-cpp-alpine folder with dockerfile
- Merge branch 'st-834' into 'master'
- ST-834: change name for panic gui
- ST-834: Restore DISPLAY environment variable
- ST-834: Add tango-panic-gui bulild step
- ST-833: delete not needed file
- ST-833: panic and pogo
- ST-833: docs update
- ST-833: missing panic
- ST-833: change version
- ST-833: bump versions
- ST-833: bump versions
- st-833 more images
- ST-834: bump chart version
- st-834 bump charts version
- st-834 bump versions
- st-834 add labels
- ST-834: refactor tango-rest
- st-834 refactor tangodb
- Merge branch 'sp-1106' into 'master'
- AT-47: fixed umbrella Chart.yaml
- AT-47: updated ska-tango-base chart version
- AT-47: ska- prefix in all template files
- ST_860 bug fix .local
- Merge branch 'st-811-migration' into 'master'
- ST-811: fix jive image
- ST-811: change call to template
- ST-811: change name for template definition
- ST-811: fix
- ST-811: revert ska-tango-util changes in the templates
- ST-811: fix
- ST-811: fix
- ST-811: fix
- ST-811: fix
- ST-811: revert change
- ST-811: chande tango-base into ska-tango-base
- ST-811: chande tango-base into ska-tango-base
- ST-811: fix
- ST-811: fix
- ST-811: revert folder name change
- ST-811: fix
- ST-811: fix
- ST-811: fix
- ST-811: fix
- SKA-811: fix
- ST-811: fix
- ST-811: fix
- ST-811: fix
- ST-811: fix makefile for new tango-base folder name
- ST-811: mv chart folders to new names
- ST-811: fix tango rest interface test
- ST-811: fix db test
- ST-811: change to ska-tango-base
- ST-811: change to ska-tango-base
- ST-811: change to ska-tango-base
- ST-811: rename tango-util as ska-tangp-util
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: fix charts
- ST-811: update versions
- ST-811: fix dsconfig
- ST-812: fix dsconfig
- ST-812: try try again
- ST-811: fix dsconfig
- ST-811: fix dsconfig
- ST-811: fix dsconfig
- ST-811: fix dsconfig
- ST-811: fix dsconfig
- ST-811: fix dsconfig
- ST-811: fix dsconfig
- ST-811: fix pip.conf
- ST-811: fix pip.conf
- ST-811: fix pip.conf
- ST-811: fix pip.conf
- ST-811: fix versions of images in charts
- ST-811: fix dockerfile for pytango-runtime
- ST-811: change dockerfiles to use new images
- ST-811: fix dockerfile for tango-rest
- ST-811: remove prefix from dockerfiles
- ST-811: fix dockerfiles for dsconfig, itango and pytango
- ST-811: fix dockerfile for pytango-runtime
- ST-811: build new pytango-builder
- Merge branch 'st-811-migration' of https://gitlab.com/ska-telescope/ska-tango-images into st-811-migration
- ST-811: remove prefix from makefile
- ST-811: add ska-* prefix to artifacts - 1st round fix
- Merge branch 'st-811-migration' of gitlab.com:ska-telescope/ska-tango-images into st-811-migration
- ST-811: rename pytango-builder image
- ST-811: add ska-* prefix to artifacts - 1st round
- add ska-* prefix to artifacts - 1st round
- ST-811: push new pytango versions
- ST-811: add arg to docker build
- ST-811: add arg to docker build
- ST-811: set env also for user tango in pytango dockerfiles
- ST-811: change index-url for two pytango images so they use group variables
- ST-811: version update
- ST-811: values.yml fix
- ST-811: chart image regestry fix & update charts' version
- ST-811: update base images
- ST-811: same fix, 2nd attempted
- ST-811: car host url fix
- ST-811: change images' version and migrate to new CAR
- Merge branch 'fix-tango-util' into 'master'
- itango version
- first commit
- Merge branch 'st-796-2' into 'master'
- ST-796: new docker image
- Merge branch 'ST-796' into 'master'
- ST-796: ref to branch
- bump tango-base version
- fix tango-dsconfig
- change docker builder version
- Merge branch 'propagate-signals' into 'master'
- bump version following change in retry
- Use consistent prefix in new function names
- fix version
- tango-pytango version
- more fixes
- fix version for tango-dep
- revert and change semver
- revert and change semver
- bump version semver
- bump version chart tango-base
- change tango-base tags
- version beta a for testing
- Propagate SIGINT/SIGTERM to child processes
- ST-758: fix exit code
- ST-758: fix typo
- ST-758: fix itango image
- ST-758: change image tag
- Merge branch 'st-758' into 'master'
- ST-758: change image version
- ST-758: fix local build
- ST-758: fist commit
- Merge branch 'st-703-fix-retry' into 'master'
- ST-703: move lint after test
- ST-703: fix report name
- ST-703: fix report path
- ST-703: fix typo
- ST-703: create build dir
- ST-703: update on image
- ST-703: trigger pipeline
- ST-703: fix linting
- Merge branch 'st-703-fix-retry' into 'master'
- ST-703: fix default tango host
- ST-703: fix config name
- ST-703: update names
- ST-703: instance as string
- ST-703: remove coalesce warning
- ST-703: gitignore
- ST-703: fixes
- ST-703: fixes
- ST-703: multiple retry options
- ST-703: fix dsconfig
- ST-703: timeout (120s) for kubectl wait
- ST-703: fix
- ST-703: remove coalesce warning
- ST-703: revert to old version
- ST-703: revert to retry max
- ST-703: change versions
- ST-703: first commit
- Merge branch 'st-703-refactor-tango-util' into 'master'
- ST-703: few changes
- Merge branch 'st-703-refactor-tango-util' of gitlab.com:ska-telescope/ska-tango-images into st-703-refactor-tango-util
- ST-703: add documentation  tango-example template
- Merge branch 'st-703-refactor-tango-util' of https://gitlab.com/ska-telescope/ska-tango-images into st-703-refactor-tango-util
- ST-703: debug parameter as port number
- ST-703: add documention about dsconfig
- Merge branch 'st-725-udate-release-versions' into 'master'
- ST-725: update tango-panic and tango-panic-gui dockerfiles
- ST-703: increase timeout for mysql db
- ST-703: fixes on retry
- ST-703: fixes and patches
- ST-725: updating the versions
- ST-703: fix publish job
- Merge branch 'st-703-refactor-tango-util' into 'master'
- ST-725: updating old nexus variables
- ST-725: update the dockerfiles with latest release versions
- ST-725: update release versions of docker images
- Merge branch 'st-703-refactor-tango-util' of https://gitlab.com/ska-telescope/ska-tango-images into st-703-refactor-tango-util
- ST-703: add class properties tag
- ST-703: correct the license text
- ST-703: refactor to entrypoints
- Merge branch 'st-725-pin-ipython' into 'master'
- ST-725: updated the required versions of itango and ipython in requirements.txt for pytango buider
- ST-725: small fix
- ST-725: update requirements.txt
- ST-725: Pin ipython in pytango build environment
- ST-703: add ci-metrics job
- ST-703: change retry pattern
- ST-703: add documentation
- ST-703: changes after talk with FO/PO
- ST-703: split multidevice template
- ST-703: Remove ifconfig file
- ST-703: bump versions
- ST-703: refactor values file for tango-base
- ST-703: re-add command and name
- ST-703: working, fixes after test
- ST-703: fix attribute properties
- ST-703: add multideviceds
- Merge branch 'st-639-fix-broken-links' into 'master'
- ST-639: change hyperlink to anchor link
- ST-639: fix broken links on dev portal
- Merge branch 'mccs-307-deviceserver-node' into 'master'
- new versions
- MCCS-307: need to specify nodes where hardware is connected by deviceserver
- Merge branch 'at6-700-noretry' into 'master'
- at6-700 optional device server retry
- Merge branch 'st-625-delete-vscode' into 'master'
- ST-625: update chart version
- ST-625: delete vscode related resources
- Merge branch 'st-625-delete-vscode-latest' into 'master'
- ST-625: update dependency
- ST-625: delete vscode and define vnc version
- Merge branch 'st-581-update-readme' into 'master'
- Merge branch 'update-ingress-api-version' into 'master'
- ST-581: update README and documentation to include podman and img
- Merge branch 'master' into update-ingress-api-version
- ST-581: sort document table entries
- ST-581: fix table format
- ST-581: bug fixes on master - new versions
- Merge branch 'st-581-car'
- st-581 fix type tango-db
- ST-581: include retry in runtime
- truncuate test runner name due to k8s restrictions
- update version
- tango-base version 14
- ST-581: from master
- updates docs
- ST-581: fix doc
- remove archiver from charts
- ST-581: fix long name
- Merge branch 'st-581-car' of https://gitlab.com/ska-telescope/ska-tango-images into st-581-car
- ST-581: add IMAGE_BUILDER option for make build and make push
- Merge branch 'st-581-car' of https://gitlab.com/ska-telescope/ska-tango-images into st-581-car
- ST-581: fix pytest-bdd version
- ST-581: update DIRS image list
- ST-581: remove other libraries
- ST-581: no need for oet
- ST-581: fix typo
- ST-581: reduce name of testing pod
- ST-581: no wait for jobs - no archiver
- ST-581: fix test
- ST-581: fix index-url
- ST-581: move to new image
- ST-581: fix typo
- ST-581: revert to tango-builder
- st-581 switch to pytango-builder
- fix url pypi
- Merge branch 'dsconfig-wait' into 'master'
- st-581 change index url
- add timeout
- add timeout parameter
- ST-581: move to new CAR
- remove latest tag
- ST-581: print env
- ST-581: try another order
- fix docker login
- ST-581: fix env name
- ST-581: change ska-docker prefix
- st-581 first commit
- ST-625: fix version
- delete Dzianis from reviewers for MRs
- update ingress version to stable
- version and test fix
- first commit
- Merge branch 'ST-569-update-ingress' into 'master'
- new versions
- Merge branch 'master' into 'ST-569-update-ingress'
- Merge branch 'mccs-331-update-to-pytango-9.3.3' into 'master'
- [MCCS-331] pytango 9.3.3 has extra dependencies
- change to nginx
- Revert "[MCCS-331] update to pytango 9.3.3"
- [MCCS-331] update to pytango 9.3.3
- ST-562: update versions
- update makefile
- ST-562: update ingresses
- ST-562: remove hostname
- ST-562: added nginx ingress
- ST-569: ingress update
- Merge branch 'add-kubectl-wait' into 'master'
- Add retry
- Merge branch 'ST-515-safe-instance-name' into 'master'
- ST-515: - Make instance names k8s safe
- fix tango-rest
- fix archiver version
- Add retry to wait for host
- ping-device not check-device
- make configuration fast
- Attribute to archive into values
- Merge branch 'bug-fixing-for-ST-515-and-docker-images-creation' into 'master'
- Resolve ST-515 "Bug fixing for  and docker images creation"

### Reverts
- [MCCS-331] update to pytango 9.3.3

## [0.2.3]

### Jira Tickets

- ST-515


### Commits

- ST-515: fixes
- Merge branch 'ST-515-updates-on-tango-util' into 'master'
- ST-515: coalesce and tpl of values

## [0.2.2]

### Jira Tickets

- ST-456
- ST-500
- ST-1241
- ST-474
- ST-473
- AT6-520
- ST-289
- ST-260


### Commits

- update tango-rest
- increase timeout
- increase timeout
- fix sleep function
- it looks the server isn't ready: adding few retry
- fix
- Merge branch 'st-456-sh-syntax-error' into 'master'
- ST-456: - fix bourne shell syntax error
- Merge branch 'st-456-numpy-rest' into 'master'
- Merge branch 'st-456-fix-documentation' into 'master'
- ST-456: increased tango-base & ska-docker chart version numbers
- ST-456: quiet installs?
- ST-456: previous chart versions seem to be needed for tests
- ST-456: fix path
- ST-456: attempt to fix https://gitlab.com/ska-telescope/ska-docker/-/jobs/768408037#L56
- ST-456: less verbose pip install
- ST-500: updated chart version number
- ST-456: upgraded REST tests
- Merge branch 'st-456-numpy-rest' of gitlab.com:ska-telescope/ska-docker into st-456-numpy-rest
- ST-456: Request sent using run_context
- fix on ingress
- ST-456: attempted curl REST interface test
- ST-456: added type checking for SCALAR attrs
- ST-456: update docs folder documentation
- ST-456: remove docker-compose.yml files and update README files
- Merge branch 'st-456-refactor-tests' into 'master'
- ST-456: done for now. TODO: get tests working with latest vscode image and xfail itango test
- ST-456: undid the && fix
- ST-456: tracing exit status more clearly
- ST-456: unskipped test for itango
- ST-456: bubble up exit status fix
- ST-456: echo status inside post-deployment/Makefile
- ST-456: refactored device_running and tango-commands into single feature, changed Makefile to try to output exit status
- ST-456: fine-tune scenario name
- ST-456: Slight modification - still not very truthful but more acceptable
- ST-456: Added spectrum tests and other scenarios inherited from itango test suite
- ST-456: added scenario for testing itango session but marking it skipped - not working. Also renamed a feature file for testing tools
- ST-456: switched out shell runner for k8srunner and added push to each build job
- Merge branch 'master' into st-456-refactor-tests
- Merge branch 'ST-456-upgrade-kubectl' into 'st-456-refactor-tests'
- Merge branch 'ST-476-subcharts-architecture' into 'master'
- Resolve ST-476 "Subcharts architecture"
- ST-456: Upgraded kubectl to latest and increased version number to 0.4.3 - to test k8s build & push
- ST-456: try k8srunner tag for deploy image build
- ST-456: made an insignificant change in the deploy folder
- ST-456: build deploy image using k8s runner
- ST-456: Removed docker-compose test jobs
- Update tango-db.feature
- ST-456: small fixes
- ST-456: removed logging for passing tests
- ST-456: Fix archiver bdd test file
- ST-456: Fix the reference to the scenario in bdd test as per the feature file
- Merge branch 'st-1241-publish-charts' into 'master'
- Merge remote-tracking branch 'origin/st-456-refactor-tests' into st-456-refactor-tests
- Merge branch 'master' into 'st-1241-publish-charts'
- Merge branch 'add-templating-for-env-vars' into 'master'
- fix tango-util version
- update chart version, publishing
- add environment variable templating
- Improve function naming
- yMerge branch 'st-456-refactor-tests' of gitlab.com:ska-telescope/ska-docker into st-456-refactor-tests
- Pytest BDD for tango-db is done
- template variable
- test different approaches for templating
- ST-456: added tango-admin test to ping database & skipped failing tests
- ST-456: Create bdd test cases for device_running and archiver
- ST-456: created boilerplate test_archiver.py
- ST-456: finished tango-cpp first two tests
- Broken test
- ST-456: marked as fixture
- ST-456: added RunContext via conftest.py in order to use DeviceProxy as in skampi. Not working yet
- ST-456: upgraded .gitignore. Tests not yet working
- ST-456: Create feature files device_running.feature and archiver.feature and add scenarios to them
- ST-456: First commit - not working yet
- ST-1241: publish stage instead of publish_chart
- ST-1241: switched to including CI job from templates directory
- Removed unnecessary make package step
- Hotfix: update deploy version used in Helm publish_chart job
- ST-474: fix kube-namespace
- Merge branch 'st-473-update-helm' into 'master'
- ST-473: Upgraded Helm on the deploy and vscode images
- ST-474: clean up job not needed
- Merge branch 'ST-474-chart-proto-with-config-data-model' into 'master'
- Resolve ST-474 "Chart proto with config data model"
- Merge branch 'update-cpp-tango-9.3.4rc7' into 'master'
- Add more common Python packages to buildenv
- Update tango-cpp to TangoSourceDistribution 9.3.4-rc7
- Merge branch 'AT6-520' into 'master'
- AT6-520: add PANIC (tango alarm system) images
- updated release to 0.2.7
- added base requirements to be installed
- updated pre installled extensions
- Merge branch 'fix-hdbpp-viewer-build' into 'master'
- Get hdbpp_viewer files from nexus
- Merge branch 'update-cpp-pytango-pip' into 'master'
- Tick releases for cpptango, pytango and general updates
- Update PyTango from 9.3.1 to 9.3.2
- Update tango-cpp to TangoSourceDistribution 9.3.4-rc4
- Fix build_tango-vnc dependencies
- Add system-wide pip.conf including nexus as index
- Use module invocation for pip
- Install latest version of pip
- Changed to `DEBIAN_FRONTEND="noninteractive"`
- Pin deploy Dockerfile to ubuntu:18.04
- Add docker hierarchy to readme
- Merge branch 'xhost-note' into 'master'
- Merge branch 'master' into xhost-note
- fix
- add note about xhost setting required on Linux for GUIs
- add bash-autocompletion
- changed place for placing extensions
- upddate release for build in vscode server
- added basic extensions to vscode (commented out)
- tango-vscode removed oet
- Merge branch 'update-pogo-to-9.6.31' into 'master'
- Update Pogo to v9.6.31 in tango-pogo Docker image
- removed pipfile
- Merge branch 'pip-upgrade-buildenv' into 'master'
- Pip upgrade buildenv
- Merge branch 'ST-352' into 'master'
- Merge branch 'tjuerges/ska-docker-Update_Darwin_network_tools' into 'master'
- Changed the version to 1.2.5.1 to follow a 4 level versioning
- Reverted the python-dsconfig to 1.2.5 since it does not exist.
- version updated to 1.2.6
- Update tango-archiver makefile to be more robust with macos catalina.
- Update json2tango
- Fixes ST-352
- Update Darwin network tools that detect local network config
- vscode new release
- workdir /app
- Merge branch 'tango-community-manual-merge' into 'master'
- Tango community manual merge
- Merge branch 'update-pogo-9.6.28' into 'master'
- Tick release for tango-java
- Update Pogo to v9.6.28 in tango-java Docker image
- Merge branch 'upgrade-helm' into 'master'
- Upgrade helm version to 3
- cleaning archiver images
- refactor tango-archiver
- fix
- Merge branch 'master' of https://gitlab.com/ska-telescope/ska-docker
- [ST-305] add tango-vnc
- Merge branch 'story_AT1-433' into 'master'
- story_AT1-433: Changes in hdbpp viewer's script.
- [ST-305] tango-vnc
- [ST-289] add packages
- Merge branch 'SAR-64/upgrade-kubectl' into 'master'
- Build and release new ska-docker/deploy image
- [st-289] increment version
- [ST-289] add packages
- Merge branch 'story_AT1-422' into 'master'
- story_AT1-422: Resolved review comments.
- story_AT1-422: Resolved review comments.
- story_AT1-422:Update README file.
- story_AT1-422: Add readme file for archiver implementation.
- Merge branch 'install-git-in-python-buildenv' into 'master'
- story_AT1-422:Add readme files for mariadb, hdbpp-viewer and tango-archiver.
- story_AT1-422:Add readme files for mariadb, hdbpp-viewer and tango-archiver.
- Merge branch 'story_AT1-365' into 'master'
- Install git in ska-python-buildenv
- story_AT1-365: Resolve comments on merge request.
- story_AT1-365: Changes in docker compose.
- Merge branch 'master' of https://gitlab.com/ska-telescope/ska-docker into story_AT1-365
- fix
- story_AT1-365:
- story_AT1-365:
- Merge branch 'master' of https://gitlab.com/ska-telescope/ska-docker into story_AT1-365
- story_AT1-365:
- story_AT1-365:
- story_AT1-365: Changes in docker compose.
- story_AT1-365:
- story_AT1-365:
- story_AT1-365:
- story_AT1-365:
- story_AT1-365:
- story_AT1-365:
- story_AT1-365: Changes in docker file.
- story_AT1-365: Change Makefile.
- story_AT1-365: Changes in archiver.yml file.
- Merge branch 'master' of https://gitlab.com/ska-telescope/ska-docker
- ST-289: vscode ssh
- story_AT1-365: Changes in docker file.
- story_AT1-365: Changes in dockerfile.
- story_AT1-365: Changes in gitlab-ci.yml file.
- story_AT1-365: Add hdbpp viewer scripts.
- Merge branch 'master' of https://gitlab.com/ska-telescope/ska-docker into story_AT1-365
- Fix: do not install pip into --user context
- Merge branch 'SAR-55/update-pip' into 'master'
- Install pip via get-pip.py
- story_AT1-365: Added devices.json file in archiver.
- story_AT1-365: Changes in gitlab-ci.yml.
- story_AT1-365: Added test framework for archiver in gitlab-ci.yml file.
- story_AT1-365: Added files for hdbpp viewer docker image.
- Merge branch 'story_AT1-366' into 'master'
- story_AT1-366: Resolve comments on merge request 1
- Merge branch 'master' of https://gitlab.com/ska-telescope/ska-docker into story_AT1-366
- Merge branch 'SAR-36/pytest-dependencies' into 'master'
- Update reference to pytest requirements;
- Merge branch 'SAR-36/fix-deploy-image' into 'master'
- Install pytest into python3 site packages
- Merge branch 'SAR-36/add-pytest-to-deploy-image' into 'master'
- Install python3 and pip requirements
- Bump deploy image versions
- Merge branch 'SAR-36/helm-plugins' into 'master'
- Install helm plugins into deploy base image
- Merge branch 'SAR-36/chart-testing-tool' into 'master'
- Initialise helm
- Add chart-testing tool to deploy image
- story_AT1-366: Added files in mariadb and tango-archiver folder.
- story_AT1-366:Updated master merged into branch.
- add vscode to the push
- story_AT1-366:Added makefile and release file in mariaDB folder to created 0.1.0 tag of mariaDB.
- add tango-vscode
- Merge branch 'story-AT1-328' of https://gitlab.com/ska-telescope/ska-docker into story-AT1-328
- added code owners
- story-AT1-328: Initial edits
- Merge branch 'master' of https://github.com/ska-telescope/ska-docker
- improvements
- Merge pull request #13 from ska-telescope/build_tango_with_numpy
- Change release versions
- Install numpy before PyTango Refresh pipfiles to use latest numpy and pytango distributions
- st-248 fix
- st-248 add image for deployment speed up
- add numpy array test for rw attribute
- refactor test
- add test for numpy spectrym data type
- st-260 fix tango-rest and increase version
- st-260 fix tango-db release
- st-260 fix docker folder
- st-260 tango-rest update
- st-260 tango-rest
- ST-260: change to folder ska-docker
- Merge branch 'master' of https://github.com/ska-telescope/ska-docker
- ST-260: version 0.2.1 for push

## [0.2.1]

### Jira Tickets

- ST-260


### Commits

- ST-260: tango 9.3.3 add distutils
- Update .gitlab-ci.yml
- install distutils
- tango rest manual test
- itango build
- Merge pull request #12 from ska-telescope/upgrade-to-buster
- fix

## [0.2.0]

### Jira Tickets

- ST-226
- ST-221
- ST-205
- ST-139


### Commits

- Merge pull request #10 from ska-telescope/upgrade-to-buster
- Merge branch 'master' into upgrade-to-buster
- tar in nexus
- move to tango 9.3.3
- Merge pull request #11 from ska-telescope/update-gitlab-ci-vars
- Update .gitlab-ci.yml
- ST-226: fix on docker file
- fix rest test
- ST-221: problem with rest test
- ST-221: test rest with docker-executor
- ST-221: output for test
- ST-221: restart all pipeline
- ST-221: use shell runner
- ST-221: start pipeline
- ST-221: pipeline changed
- ST-221: add push version
- ST-221: new minor release
- bumped to version 0.2.0
- ST-221: fix tango-dsconfig, disable pipeline
- ST-221: fix tango-dsconfig
- Update Dockerfiles to build with buster
- ST-205: add docker image for dsconfig
- Merge pull request #8 from ska-telescope/ST-139-include-k8s-configuration
- ST-139: alignement with ST-144
- ST-139: alignement with ST-144
- ST-139: fix readme
- ST-139: added test for helm chart
- ST-139: add documentation k8s
- ST-139: add k8s configuration

## 0.1.0

### Jira Tickets

- ST-123
- ST-96
- ST-81
- ST-61
- SP-81
- ST-58
- ST-43
- ST-45


### Commits

- Merge pull request #6 from ska-telescope/new-registry
- new registry
- Do not match inet6 addresses on MacOS
- ST-123: explicitly add copyright reference and apache 2 license
- ST-123: fix licenses in ska-docker
- Extract NETWORK_MODE as a configurable parameter Add prototype 'attach' make target
- Merge remote-tracking branch 'origin/master'
- Run in --net=host mode on Linux so that services appear locally and not on a container network
- ST-96: add documentation badge
- Merge remote-tracking branch 'origin/master'
- ST-81: upload to docker registry ska-registry.av.it.pt fix typo on .env
- ST-81: upload to docker registry ska-registry.av.it.pt try2
- ST-81: upload to docker registry ska-registry.av.it.pt
- Do not require an image rebuild to export Pipfile.lock
- Add piplock makefile targets to python projects
- Update Pipfile.lock for itango project
- Change test target from python runtime to python build environment
- Delete old tango-python test
- Fix error in CI config
- Optimise image size and compile time by using intermediate images. Use apt cache if detected on host machine.
- force pull of latest image for itango tests
- Source itango from the virtual environment in the new 'ska-python'-derived image
- Merge remote-tracking branch 'origin/master'
- Use ska-python base image for ipython rather than deprecated tango-python images
- Remove build definitions from docker-compose definitions
- add retry:2
- add documentation on how to login to the registry
- use token
- .
- .
- .
- .
- .
- Fix indent problem in CI configuration file
- Delete container_name definitions for the test services to avoid container name collisions
- re-enable 'only execute on file changes' for CI test execution
- .
- .
- .
- Use Docker executor for CI tests to avoid service name collisions for parallel tests
- Do not use persistent volumes for tango db so database starts from pristine state
- Use shell executor throughout.
- Do not push images with git commit hashes
- Use docker executor instead of docker-machine
- Add .release file to tango-docker image build
- Do not use Docker cache when building images on CI server
- tango-builder cannot depend on any other image, so make it a CI shell executor
- build tango-builder image first as it is a requirement of all builds
- Fix tests so that they work when called from any directory. Wait for tangotest device registration when running tests without existing tangodb volume
- Add ska-python to group build
- Add retry to base image
- Remove /bin/test from 'make test' targets
- Use dedicated docker-compose files for test harness environments rather than sourcing/composing services from other definitions.
- Remove /bin/test from 'make test' targets
- Make the new Pipenv.lock available inside the image rather than being overwritten by a potentially stale file.
- Add ska-python tests and CI test triggers
- Initial commit of ska-python Docker image
- Fix syntax errors in gitlab CI configuration
- Only trigger builds when directory changes
- Push itango into separate CI build stage.
- Use 'make test' procedures Add itango image to CI build
- Merge pull request #5 from ska-telescope/tango-builder
- .
- Merge remote-tracking branch 'origin/improve_python_test' into improve_python_test
- Refactor tango-rest test procedure Minor cleanup of tango-python test makefile
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- Move creation of tango user and sudo setup to base image
- Separate pytango and itango images
- Add pip to default python image Improve tests and test automation for tango-python image
- Merge remote-tracking branch 'origin/master'
- Merge pull request #4 from ska-telescope/use-docker-executor
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- .
- . restore
- . test notification on slack for failure
- Separate pytango and itango images
- ST-61: fixing
- ST-61: improving results
- ST-61: fixing
- ST-81: fixing
- SP-81: uploading result to gitlab
- ST-61: create result.txt
- ST-58: fixing url for tango rest test
- ST-58: fixing test
- ST-58: include rest and test it
- Add pip to default python image Improve tests and test automation for tango-python image
- Merge remote-tracking branch 'origin/master'
- Merge pull request #3 from ska-telescope/fix-makefile
- Change docker-compose to pull from gitlab registry by default
- bug fix: tangotest container incorrectly using Python image rather than Java image.
- put test not manual.
- add simple pytest
- another fix
- fixing tests
- fixing tests
- add pytest to the tango-python docker image
- fixing tests
- improving tests
- fixing tests
- Merge pull request #2 from ska-telescope/refactor-env
- refactored default env file
- Introduce mtango-rest image
- implementing simple test
- Testing the framework
- Always include DOCKER_REGISTRY_HOST and DOCKER_REGISTRY_USER variables in Makefiles and docker-compose files.
- Merge remote-tracking branch 'origin/fix-makefile'
- ST-43: changes to the configuration due to different OS version.
- ST-45: fix and test
- ST-45: fix and test
- ST-45: fix and test
- ST-45: another fix
- ST-45: run detached
- ST-45: FIX AND TEST
- ST-45: fix and test
- ST-45: fix and test
- ST-45: fix and test
- ST-45: fix and test
- ST-45: test and fix
- ST45: test and fix
- ST-45: fix
- ST-45: fix
- ST:45: fix
- ST-45: clean file and test
- ST-45: .
- ST:45 .
- ST:45. Test
- ST-45: fix for changing runner to shell
- ST-45: fix for changing runner to shell.
- ST:45 put manual every job except for tango-db and tango-cpp used for test. tango-dependencies should be already built.
- ST-45: test make pull on before script.
- ST-45: get the tango-dependencies in before script
- get the tango-dependencies in before script
- ST-45
- fix build
- delete only master option
- correct makefile modified gitlab pipeline
- Merge remote-tracking branch 'origin/master'
- Specify default Docker registry in Makefile. Clarify build instructions to state that custom registry must be part of build and push steps.
- Add DOCKER_REGISTRY_USER to build
- added comment for keyword stages
- install docker compose with pip
- removed stages: they are not needed at the moment.
- build restored.
- add comments.
- add CI configuration file.
- Add 'make push' target to root makefile
- Update github location in Sphinx configuration to point to ska-telescope
- Update to latest ska-skeleton docs
- Extract docker registry details, making them configurable. Add TBD docker registry username
- Bump initial release versions to 0.1.0
- Add logviewer to docker-compose
- Add clarifications to itango example in README.md
- Add root-level makefile to docker directory
- Add help to dockerfiles
- Use makefile to control docker-compose
- Add files and Sphinx template from SKA skeleton project
- Add docker images for Pogo and an example Starter device, plus docker-compose files for Pogo, Astor, and an example Starter device.
- Add dedicated directory for docker-compose files
- Remove supervisord from TANGO C++ image
- User ipython to create a default ipython profile in Python TANGO docker image.
- Use Makefiles to build Docker images rather than docker-compose.
- Initial commit.


\[0.3.2\]: /compare/0.3.1...0.3.2
\[0.3.1\]: /compare/0.0.123...0.3.1
\[0.0.123\]: /compare/0.2.30...0.0.123
\[0.2.30\]: /compare/0.2.29...0.2.30
\[0.2.29\]: /compare/0.2.28...0.2.29
\[0.2.28\]: /compare/0.2.27...0.2.28
\[0.2.27\]: /compare/0.2.26...0.2.27
\[0.2.26\]: /compare/ska-tango-images-0.2.25...0.2.26
\[ska-tango-images-0.2.25\]: /compare/0.2.3...ska-tango-images-0.2.25
\[0.2.3\]: /compare/0.2.2...0.2.3
\[0.2.2\]: /compare/0.2.1...0.2.2
\[0.2.1\]: /compare/0.2.0...0.2.1
\[0.2.0\]: /compare/0.1.0...0.2.0
