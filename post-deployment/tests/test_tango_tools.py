# coding=utf-8
"""tango_tools.feature feature tests."""
import tango
import logging 
import pytest
import subprocess

from pytest_bdd import given, scenario, then, when, parsers, scenarios


@given('the TANGO_HOST is defined in the environment')
def the_tango_host_is_defined_in_the_environment(run_context):
    """the TANGO_HOST is defined in the environment."""
    # logging.info("TANGO_HOST: {}".format(run_context.TANGO_HOST))
    assert run_context.TANGO_HOST == 'databaseds-tango-base-test:10000', "RunContext has unexpected TANGO_HOST variable: {}".format(run_context.TANGO_HOST)


# @pytest.fixture
@when(parsers.parse('I call the {command} command with parameter {parameter}'))
def call_command(command, parameter):
    """I call a command with parameter."""

    if parameter == "ping-database":
        # logging.info("Running command {} with param {}".format(command, parameter))
        pytest.result = subprocess.run([command, "--"+parameter, "20"])
    elif command == "itango3":
        # logging.info("Running command {} with param {}".format(command, parameter))
        pytest.result = subprocess.run([command, "--"+parameter])


@then('the return code is 0')
def check_return_code():
    """the result is 0."""
    # return_code = call_command.returncode
    return_code = pytest.result.returncode
    assert return_code == 0, "Function returned {}".format(pytest.result)

scenarios('../features/tango_tools.feature')
