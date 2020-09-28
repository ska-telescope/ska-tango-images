# coding=utf-8
"""tango_admin.feature feature tests."""
import tango
import logging 
import pytest
import subprocess

from pytest_bdd import given, scenario, then, when


@scenario('tango_admin.feature', 'Connect to the tango database using tango_admin')
def test_connect_to_the_tango_database_using_tango_admin():
    """Connect to the tango database using tango_admin."""


@given('the TANGO_HOST is defined in the environment')
def the_tango_host_is_defined_in_the_environment(run_context):
    """the TANGO_HOST is defined in the environment."""
    # logging.info("TANGO_HOST: {}".format(run_context.TANGO_HOST))
    assert run_context.TANGO_HOST == 'databaseds-tango-base-test:10000', "RunContext has unexpected TANGO_HOST variable: {}".format(run_context.TANGO_HOST)


@pytest.fixture
@when('I call the tango_admin command with parameter ping-database')
def ping_database():
    """I call the tango_admin command with parameter ping-database."""
    return subprocess.run(["tango_admin", "--ping-database", "20"])


@then('the return code is 0')
def check_return_code(ping_database):
    """the result is 0."""
    assert ping_database.returncode == 0, "Ping Database returned {}".format(ping_database)

