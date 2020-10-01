# coding=utf-8
"""tango_tools.feature feature tests."""
import tango
import logging 
import pytest
import subprocess
import requests

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


@when(parsers.parse("I make a request with user {basic_auth} to {address}"))
def curl_rest(basic_auth, address):
    """Request basic attribute from test device"""
    pytest.result = subprocess.run(["curl", "--user", basic_auth, address])
    
    url = address
    auth_tuple = (basic_auth.split(':')[0], basic_auth.split(':')[1])

    pytest.result = requests.get(url, auth=auth_tuple)


@then(parsers.parse('the return code is {expected_result}'))
def check_return_code(expected_result):
    """the return code is as expected."""
    # return_code = call_command.returncode
    if expected_result == 200:
        assert pytest.result.status_code == expected_result, "Curl returned {}, expected {}".format(pytest.result, expected_result)
    else:
        return_code = pytest.result.returncode
        assert str(return_code) == str(expected_result), "Function returned {}, expected {}".format(pytest.result, expected_result)

scenarios('../features/tango_tools.feature')
