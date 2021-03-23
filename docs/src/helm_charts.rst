Helm Charts available on ska-tango-images repository
====================================================

There are two helm charts available on this repository: one is called ``tango-base`` and the other is the ``tango-util``.
There is another helm chart, called ``ska-tango-images``, which is used only for testing purposes. 

The tango-base helm chart
-------------------------

The ``tango-base`` helm chart is an application chart which defines the basic TANGO ecosystem in kubernetes. 

In specific it defines the following k8s services: 
 - tangodb: it is a mysql database used to store configuration data used at startup of a device server (more information can be found `here <https://tango-controls.readthedocs.io/en/latest/reference/glossary.html#term-tango-database>`_.
 - databaseds: it is a device server providing configuration information to all other components of the system as well as a runtime catalog of the components/devices (more information can be found `here <https://tango-controls.readthedocs.io/en/latest/reference/glossary.html#term-tango-host>`_.
 - itango: it is an interactive Tango client (more information can be found `here <https://gitlab.com/tango-controls/itango>`_.
 - vnc: it is a debian environment with x11 server and vnc/novnc installed on it.
 - tangorest: it defines the rest api for the TANGO eco-system  (more information can be found `here <https://tango-controls.readthedocs.io/en/latest/installation/vm/tangobox.html?highlight=rest#rest-api>`_.
 - tangotest: it is the tango test device server (more information can be found `here <https://gitlab.com/tango-controls/TangoTest>`_.


The tango-util helm chart
-------------------------

The ``tango-util`` helm chart is a library chart which helps other application chart defines TANGO device servers.

In specific it defines the following helm named template: 
 - configuration (deprecated): it creates a k8s service account, a role and role binding for waiting the configuration job to be done and a job for the `dsconfig <https://github.com/MaxIV-KitsControls/lib-maxiv-dsconfig>`_ application to apply a configuration json file set into the values file;
 - deviceserver (deprecated): it creates a k8s service and a k8s statefulset for a instance of a device server;
 - multidevice-config: it creates a ConfigMap which contains the generated `dsconfig <https://github.com/MaxIV-KitsControls/lib-maxiv-dsconfig>`_ json configuration file, the boostrap script for the `dsconfig <https://github.com/MaxIV-KitsControls/lib-maxiv-dsconfig>`_ application and a python script for multi class device server startup;
 - multidevice-job: it creates a job for the `dsconfig <https://github.com/MaxIV-KitsControls/lib-maxiv-dsconfig>`_ application to apply a configuration json file set into the values file;
 - multidevice-sacc-role: it creates a k8s service account, a role and role binding for waiting the configuration job to be done;
 - multidevice-svc: it creates a k8s service and a k8s statefulset for a device server tag specified in the values file.