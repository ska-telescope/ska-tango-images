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

`Dsconfig <https://github.com/MaxIV-KitsControls/lib-maxiv-dsconfig>`_ is a json based file that is used for Tango Device configuration.
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
 - **instances** : On this field the user can define what are the instances that are going to be created on the deviceServer. 
 - **entrypoints** : The number of entrypoints should correspond to the maximum number of different devices that can be present on the deviceServer. In this example, the instance "test" has 3 different devices and the instance "test2" only 1, but the device present on instance 2 is also present on instance 1 making it 3 different devices.   
  
    - **name** : This is a **mandatory** field at entrypoints. The name field has to have a format like NameOfTheModule.NameOfTheClass.
    - **path** : This is a **optional** field at entrypoints. The path field is the path of the module that has the class of the device. This field may not be present **only** if the module is included in the list of directories that the interpreter will search, one example is if the modules are installed with pip.
 
 - **server** : contains a list of all instances defined.

    - **intances** : contains a list of all devices defined on the instance, with their classes and device properties and values.
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
