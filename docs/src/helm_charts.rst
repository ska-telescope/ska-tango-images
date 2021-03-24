Helm Charts available on ska-tango-images repository
====================================================

There are two helm charts available on this repository: one is called ``tango-base`` and the other is the ``tango-util``.
There is another helm chart, called ``ska-tango-images``, which is used only for testing purposes. 

The tango-base helm chart
-------------------------

The ``tango-base`` helm chart is an application chart which defines the basic TANGO ecosystem in kubernetes. 

In specific it defines the following k8s services: 
 - tangodb: it is a mysql database used to store configuration data used at startup of a device server (more information can be found `here <https://tango-controls.readthedocs.io/en/latest/reference/glossary.html#term-tango-database>`__.
 - databaseds: it is a device server providing configuration information to all other components of the system as well as a runtime catalog of the components/devices (more information can be found `here <https://tango-controls.readthedocs.io/en/latest/reference/glossary.html#term-tango-host>`__.
 - itango: it is an interactive Tango client (more information can be found `here <https://gitlab.com/tango-controls/itango>`__.
 - vnc: it is a debian environment with x11 server and vnc/novnc installed on it.
 - tangorest: it defines the rest api for the TANGO eco-system  (more information can be found `here <https://tango-controls.readthedocs.io/en/latest/installation/vm/tangobox.html?highlight=rest#rest-api>`__.
 - tangotest: it is the tango test device server (more information can be found `here <https://gitlab.com/tango-controls/TangoTest>`__.


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


Dsconfig generation
+++++++++++++++++++

`Dsconfig <https://github.com/MaxIV-KitsControls/lib-maxiv-dsconfig>`_ is an application which configure the tango database with the help of a json file.
With tango-util a deviceServer is configurable using specifications in a values.yaml file of the chart instead of the dsconfig.json file, where all deviceServers have a configuration yaml file.
Below there is an example of a values file that can be used with the tango-util multi device definition: 

.. code-block:: console

    deviceServers: 
        name: "theexample-{{.Release.Name}}"
        function: tango-example-powersupply
        domain: tango-example
        instances: ["test"]
        entrypoints:
            - name: "powersupply.PowerSupply"
            path: "/app/module_example/powersupply.py"
            - name: "EventReceiver.EventReceiver"
            path: "/app/module_example/EventReceiver.py"
            - name: "Motor.Motor"
            path: "/app/module_example/Motor.py"
        server:
            name: "theexample"
            instances:
            - name: "test2"
                classes: 
                - name: "PowerSupply"
                devices: 
                - name: "test/power_supply/2"
                    properties:
                    - name: "test"
                    values: 
                    - "test2"
            - name: "test"
                classes: 
                - name: "PowerSupply"
                devices: 
                - name: "test/power_supply/1"
                    properties:
                    - name: "test"
                    values: 
                    - "test2"
                - name: "EventReceiver"
                devices: 
                - name: "test/eventreceiver/1"
                - name: "Motor"
                devices: 
                - name: "test/motor/1"
                    properties:
                    - name: "polled_attr"
                    values: 
                    - "PerformanceValue"
                    - "{{ .Values.deviceServers.theexample.polling }}"
                    attribute_properties:
                    - attribute: "PerformanceValue"
                    properties: 
                    - name: "rel_change"
                        values: 
                        - "-1"
                        - "1"
        class_properties:
            - name: "PowerSupply"
            properties:
                - name: "aClassProperty"
                values: ["67.4", "123"]
                - name: "anotherClassProperty"
                values: ["test", "test2"]
        depends_on:
            - device: sys/database/2
        image:
            registry: "{{.Values.tango_example.image.registry}}"
            image: "{{.Values.tango_example.image.image}}"
            tag: "{{.Values.tango_example.image.tag}}"
            pullPolicy: "{{.Values.tango_example.image.pullPolicy}}"
    

Fields explained:
 - **deviceServers** : contains a list of all device server defined
 - **instances** : On this field the user can define which of the instances defined in the server tag are going to be created on the deviceServer. 
 - **entrypoints** : The number of entrypoints should correspond to the defined in the server tag field. 
  
    - **name** : This is a **mandatory** field at entrypoints. The name field has to have a format like NameOfTheModule.NameOfTheClass.
    - **path** : This is a **optional** field at entrypoints. The path field is the path of the module that has the class of the device. This field may not be present **only** if the module is included in the list of directories that the interpreter will search, one example is if the modules are installed with pip.
 
 - **server** : It's the equivalent of the dsconfig json file and define everything needed for a device server.

    - **intances** : A list of all instances for a device server. For each instance a number of devices can be defined together with the relative properties.
 - **class_properties** : On this field you can list your class properties.

The configuration file, like the above one, needs to be added to the values.yaml file. Below there is an example of how to add it :

.. code-block:: console

    deviceServers:
        theexample:
            instances: ["test2"]
            polling: 1000
            file: "data/theexample.yaml"

Fields explained:
    - **file** : This field specifies the path of the Dsconfig file in an yaml format. Note:. This file should be included in the `data folder <https://gitlab.com/ska-telescope/tango-example/-/tree/master/charts/tango-example/data>`__ .
    - **polling** : The polling field is one of the variable attributes of the  deviceServer. In this example we have it present on the *test/motor/1* device in the values of the *polled_attr* property. So this field allows us to change the value of the *polled_attr* property.
    - **instances** : If **instances** has values ​​in the value file, this takes precedence over the data file **instances** field.

The use of the yaml file allows users to have a cleaner and more understandable view of the DeviceServer configurations compared to a json file configuration. 
The helm template multidevice-config creates a ConfigMap which contains the generated dsconfig that was loaded and converted to a json type file from the values.yaml file described above.  


How to use the defined helm named template
++++++++++++++++++++++++++++++++++++++++++

A example on how to set up your k8s namespace with the helm named templates, described in the beginning of this `section <#the-tango-util-helm-chart>`_, can be seen on `tango-example <https://gitlab.com/ska-telescope/tango-example>`_ repository.
This templates are called by the below `template <https://gitlab.com/ska-telescope/tango-example/-/blob/master/charts/tango-example/templates/deviceservers.yaml>`_ present on the tango-example repository:

.. code-block:: console
    :linenos:

    {{ $localchart := . }}

    {{- range $key, $deviceserver := .Values.deviceServers }}

    {{- if hasKey $deviceserver "file"}}

    {{- $filedeviceserver := $.Files.Get $deviceserver.file | fromYaml }}
    {{- $_ := set $filedeviceserver "instances" (coalesce $localchart.Values.global.instances $deviceserver.instances $filedeviceserver.instances) }}
    {{- $context := dict "name" $key "deviceserver" $filedeviceserver "image" $deviceserver.image "local" $localchart }}
    {{ template "tango-util.multidevice-config.tpl" $context }}
    {{ template "tango-util.multidevice-sacc-role.tpl" $context }}
    {{ template "tango-util.multidevice-job.tpl" $context }}
    {{ template "tango-util.multidevice-svc.tpl" $context }}

    {{- else }}

    {{- $_ := set $deviceserver "instances" (coalesce $localchart.Values.global.instances $deviceserver.instances) }}
    {{- $context := dict "name" $key "deviceserver" $deviceserver "image" $deviceserver.image "local" $localchart }}
    {{ template "tango-util.multidevice-config.tpl" $context }}
    {{ template "tango-util.multidevice-sacc-role.tpl" $context }}
    {{ template "tango-util.multidevice-job.tpl" $context }}
    {{ template "tango-util.multidevice-svc.tpl" $context }}

    {{- end }}

    {{- end }} # deviceservers

Tango-example template description:
    - **Line 3**  to **Line 26** : This template will iterate through each field under deviceServers on the values.yaml file.
    - **Line 5**  to **Line 15** : If the device server has a file field we will get that configuration file and use it. (**Best Practice**: Add the deviceServer configuration in the data folder and then pass the path of it in the file field of the deviceServer).
    - **Line 15** to **Line 25** : If there is no file field it means that the configuration of this device was done inside the value.yaml. (**Note:** Making the configuration of the device inside the values.yaml makes this file bigger becoming harder to read and understand)
    - **Line 8**  : As discussed before it is possible to have a instances field in the values.yaml file and in the data file, it is also possible to have instances defined as a global field. It is being used a coalesced function that takes the first not null value of the list. The priority is, first it takes the instance value from the global variable if there is none it takes it from the values file and then from the data file.
    - **Line 27** : Same as line 8 but without the possibility of having the instance field on the data file.
    - **Line 9** and **Line 18** : Context is a list of variables that will passed as arguments to the templates.
    - **Templates** : There are four templates already described before. Each template will be called for each deviceServer as they are inside the range loop (line 3).