# coding=utf-8
"""features/tango-cpp.feature feature tests."""

from pytest_bdd import (
    given,
    scenario,
    then,
    when,
)


@scenario('features/tango-cpp.feature', 'Call Command and test attribute')
def test_call_command_and_test_attribute():
    """Call Command and test attribute."""


@given('a device called sys/tg_test/1')
def a_device_called_systg_test1():
    """a device called sys/tg_test/1."""
    raise NotImplementedError


@when('I call the command State()')
def i_call_the_command_state():
    """I call the command State()."""
    raise NotImplementedError


@then('the attribute State is RUNNING')
def the_attribute_state_is_running():
    """the attribute State is RUNNING."""
    raise NotImplementedError
