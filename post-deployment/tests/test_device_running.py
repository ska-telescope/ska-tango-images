# coding=utf-8
"""features/device_running.feature feature tests."""
import tango
from pytest_bdd import given, scenario, then, when, parsers


@scenario('device_running.feature', 'Test device is running')
def test_test_device_is_running():
    """Test device is running."""


@given(parsers.parse('a device called {device_name}'))
def device_proxy(run_context, device_name):
    """a device called sys/tg_test/1."""
    return tango.DeviceProxy(device_name)


@when(parsers.cfparse("I call the command {command_name}({parameter:String?})", extra_types=dict(String=str)))
def call_command(device_proxy, command_name):
    """I call the command State()."""
    return device_proxy.command_inout(command_name)


@then(parsers.parse('the attribute {attribute_name} is {expected_value}'))
def check_attribute(device_proxy, attribute_name, expected_value):
    """the attribute State is RUNNING."""
    attr = device_proxy.read_attribute(attribute_name)
    assert str(attr.value) == expected_value

