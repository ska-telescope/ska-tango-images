# coding=utf-8
"""tango_tools.feature feature tests."""
import tango
import logging 
import pytest
import subprocess
import requests
from time import sleep

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
def curl_rest(run_context, basic_auth, address):
    """Request basic attribute from test device"""
    #pytest.result = subprocess.run(["curl", "--user", basic_auth, address])
    
    url = address.replace('TANGO_HOST',run_context.TANGO_HOST.split(':')[0])
    logging.info("Request sent to {}".format(url))
    
    auth_tuple = (basic_auth.split(':')[0], basic_auth.split(':')[1])
    
    sleep_time = 20
    max_retries = 10
    total_slept = 0
    for x in range(0, max_retries):
        try:
            pytest.result = requests.get(url, auth=auth_tuple)
            logging.info("Result text: {}".format(pytest.result.text))
            logging.info("Result json: {}".format(pytest.result.json()))
            break
        except Exception as e:
            sleep(sleep_time)
            total_slept += 1
            if(x == (max_retries - 1)):
                raise e

@then(parsers.parse('the return code is {expected_result}'))
def check_return_code(expected_result):
    """the return code is as expected."""
    # return_code = call_command.returncode
    if expected_result == '200':
        assert pytest.result.status_code == int(expected_result), "Curl returned {}, expected {}".format(pytest.result, expected_result)
        assert pytest.result.json()['quality'] == 'ATTR_VALID'
    else:
        return_code = pytest.result.returncode
        assert str(return_code) == str(expected_result), "Function returned {}, expected {}".format(pytest.result, expected_result)

@then(parsers.parse('the result {key} is {value}'))
def check_result(key,value):
    """result is as expected"""
    assert pytest.result.json()[key] == value

scenarios('../features/tango_tools.feature')
