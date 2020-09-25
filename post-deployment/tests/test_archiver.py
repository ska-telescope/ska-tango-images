# coding=utf-8
"""features/archiver.feature feature tests."""

from pytest_bdd import (
    given,
    scenario,
    then,
    when,
)


@scenario('archiver.feature', 'Test Configuration Manager device is ON')
def test_test_configuration_manager_device_is_on():
    """Test Configuration Manager device is ON."""


@scenario('archiver.feature', 'Test Event Subscriber device is ON')
def test_test_event_subscriber_device_is_on():
    """Test Event Subscriber device is ON."""


@given('a device called archiving/hdbpp/confmanager01')
def a_device_called_archivinghdbppconfmanager01():
    """a device called archiving/hdbpp/confmanager01."""
    raise NotImplementedError


@given('a device called archiving/hdbpp/eventsubscriber01')
def a_device_called_archivinghdbppeventsubscriber01():
    """a device called archiving/hdbpp/eventsubscriber01."""
    raise NotImplementedError


@when('I call the command state()')
def i_call_the_command_state():
    """I call the command state()."""
    raise NotImplementedError


@then('the attribute DevState is ON')
def the_attribute_devstate_is_on():
    """the attribute DevState is ON."""
    raise NotImplementedError

