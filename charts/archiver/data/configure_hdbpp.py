#Imports
import sys, getopt
import json
from tango import DeviceProxy, DevFailed, AttributeProxy
from time import sleep
import os

def cm_configure_attributes():
    configure_success_count = 0
    configure_fail_count = 0
    already_configured_count = 0
    total_attrib_count = 0
    with open(attr_list_file, 'r') as attrib_list_file:
        configuration_blocks = json.load(attrib_list_file)
        for cb in configuration_blocks:
            attribute_list = cb['attributes']
            polling_period = cb['polling_period']
            period_event = cb['period_event']
            for attribute in attribute_list:
                total_attrib_count += 1
                
                attribute_fqdn = "tango://" + os.environ['TANGO_HOST'] + "/" + attribute

                is_already_archived = False
                attr_list = evt_subscriber_proxy.read_attribute("AttributeList").value
                if attr_list is not None:
                    for already_archived in attr_list:
                        if attribute.lower() in str(already_archived).lower():
                            print("Attribute " + attribute + " already configured.")
                            is_already_archived = True
                            already_configured_count, configure_fail_count = start_archiving(attribute, already_configured_count, configure_fail_count)
                            break

                if not is_already_archived:
                    print("Attribute " + attribute + " not configured. Configuring it now. ")
                    max_retries = 5
                    sleep_time = 1
                    not_online = False
                    for x in range(0, max_retries):
                        try:
                            att = AttributeProxy(attribute_fqdn)
                            att.read()
                            break
                        except DevFailed as df:
                            if(x == (max_retries -1)):
                                print("Attribute " + attribute + " not online. Skipping it.")
                                not_online = True
                                break
                            print("DevFailed exception: " + str(df.args[0].reason) + ". Sleeping for " + str(sleep_time) + "ss")
                            sleep(sleep_time)

                    if (not_online):
                        continue

                    try:
                        conf_manager_proxy.write_attribute("SetAttributeName", attribute_fqdn)
                        conf_manager_proxy.write_attribute("SetArchiver", evt_subscriber_device_fqdn)
                        conf_manager_proxy.write_attribute("SetStrategy", "ALWAYS")
                        conf_manager_proxy.write_attribute("SetPollingPeriod", int(polling_period))
                        conf_manager_proxy.write_attribute("SetPeriodEvent", int(period_event))
                    except Exception as except_occured:
                        print("Exception while setting configuration manager arrtibutes: ", except_occured)
                        configure_fail_count += 1
                        continue

                    try:
                        conf_manager_proxy.AttributeAdd()
                        configure_success_count += 1
                        print ("attribute_fqdn " + attribute_fqdn + " " + " added successfuly")
                    except DevFailed as df:
                        configure_fail_count += 1
                        print("Exception occured while adding attribute for archiving: ", df)

    return configure_success_count, configure_fail_count, already_configured_count, total_attrib_count


def start_archiving(str_attribute, already_configured_count, configure_fail_count):
    try:
        conf_manager_proxy.command_inout("AttributeStart", str_attribute)
        already_configured_count += 1
    except Exception as except_occured:
        configure_fail_count += 1
        print("start_archiving except_occured: ", except_occured)

    return already_configured_count

# Main entrypoint of the script.
conf_manager_device_fqdn = ""
evt_subscriber_device_fqdn = ""
attr_list_file = ""
## parse arguments
try:
    opts, args = getopt.getopt(sys.argv[1:], "c:e:a:", ["cm=", "es=", "attrfile="])

except getopt.GetoptError:
    print("Please provide proper arguments.")
    print("Usage: $python configure_hdbpp.py --cm=<FQDN> --es=<FQDN> --attrfile=<filepath> OR")
    print("       $python configure_hdbpp.py -cm <FQDN> -e <FQDN> -a <filepath>")
    print("       cm: FQDN of HDB++ Configuration Manager")
    print("       es: FQDN of HDB++ Event subscriber")
    print("       infile: File containing FQDNs of attributes to archive")
    sys.exit(2)
for opt, arg in opts:
    if opt in ("-c", "--cm"):
        conf_manager_device_fqdn = arg
    elif opt in ("-e", "--es"):
        evt_subscriber_device_fqdn = arg
    elif  opt in ("-a", "--attrfile"):
        attr_list_file = arg

conf_manager_proxy = DeviceProxy(conf_manager_device_fqdn)
evt_subscriber_proxy = DeviceProxy(evt_subscriber_device_fqdn)

sleep_time = 6
max_retries = 10
for x in range(0, max_retries):
    try:
        configure_success_count, configure_fail_count, already_configured_count, total_attrib_count = cm_configure_attributes()
        print("Configured successfully: ", configure_success_count, "Failed: ", configure_fail_count, "Already configured: ", already_configured_count, "Total attributes: ", total_attrib_count)
        break
    except:
        print("configure_attribute exception: " + str(sys.exc_info()))
        if(x == (max_retries - 1)):
            sys.exit(-1)

    try:
        deviceAdm = DeviceProxy("dserver/hdbppcm-srv/01")
        deviceAdm.RestartServer()
    except:
        print("reset_conf_manager exception: " + str(sys.exc_info()[0]))

    sleep(sleep_time)


if configure_fail_count > 0:
    exit(-1)

evt_subscriber_proxy.Start()
