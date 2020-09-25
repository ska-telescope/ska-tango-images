# coding=utf-8
"""features/tango-cpp.feature feature tests."""
import tango
import logging 
import pytest

from pytest_bdd import given, scenario, then, when, parsers


@scenario('tango-cpp.feature', 'Call Command and test attribute')
def test_call_command_and_test_attribute():
    """Call Command and test attribute."""


@given(parsers.parse('a device called <device_name>'))
def device_proxy(run_context, device_name):
    """a device called sys/tg_test/1."""
    return tango.DeviceProxy(device_name)


@pytest.fixture
@when(parsers.parse('I call the command <command_name>'))
def call_command(device_proxy,command_name):
    """I call the command State()."""
    return device_proxy.command_inout(command_name)


@then(parsers.parse('the attribute <attribute_name} is <expected_value>'))
def check_attribute(device_proxy, attribute_name, expected_value):
    """the attribute State is RUNNING."""
    attr = device_proxy.read_attribute(attribute_name)
    assert str(attr.value) == expected_value

