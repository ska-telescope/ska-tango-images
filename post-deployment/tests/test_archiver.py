# coding=utf-8
"""features/archiver.feature feature tests."""

import tango
from pytest_bdd import given, scenario, then, when, parsers


@scenario('archiver.feature', 'Test archiver')
def test_archiver():
    """Test archiver."""


@given(parsers.parse('a device called {device_name}'))
def device_proxy1(run_context, device_name):
    """a device called archiving/hdbpp/confmanager01."""
    return tango.DeviceProxy(device_name)


@given(parsers.parse('a device called {device_name}'))
def device_proxy2(run_context, device_name):
    """a device called archiving/hdbpp/eventsubscriber01."""
    return tango.DeviceProxy(device_name)


@when(parsers.cfparse("I call the command {command_name}({parameter:String?})", extra_types=dict(String=str)))
def call_command(device_proxy, command_name):
    """I call the command archive()."""
    return device_proxy.command_inout(command_name)


@when(parsers.parse('attribute is set to {attribute_name}'))
def set_attribute(device_proxy, attribute_name):
    """Attribute is set to sys/tg_test/1/double_scalar."""
    return device_proxy.read_attribute(attribute_name)


@then(parsers.parse("time interval is {time_interval}({parameter:String?})", extra_types=dict(String=str)))
def set_time_interval(device_proxy, time_interval):
    """Time interval is 1 second."""
    return device_proxy.read_attribute(time_interval)


@then(parsers.parse('the attribute {attribute_name} is {expected_value}'))
def check_attribute(device_proxy, attribute_name, expected_value):
    """the attribute State is archiving."""
    attr = device_proxy.read_attribute(attribute_name)
    assert str(attr.value) == expected_value
