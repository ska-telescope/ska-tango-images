import os
import pytest
import logging
import pytest
import yaml
import mysql.connector

from tango import DeviceProxy
from collections import namedtuple

## shared fixtures
from resources.test_support.fixtures import run_context

"""
Taken from https://gitlab.com/ska-telescope/skampi/-/blob/21e00f36a5fa797ad816ec8c40954f6a3a70b040/post-deployment/tests/conftest.py

RunContext is a metadata object to access values from the environment, 
i.e. data that is injected in by the Makefile. Useful if tests need to 
be aware of the k8s context they are running in, such as the HELM_RELEASE.

This will allow tests to resolve hostnames and other dynamic properties.

Example:

def test_something(run_context):
    HOSTNAME = 'some-pod-{}'.format(run_context.HELM_RELEASE)

"""

FILE_PATH = os.path.abspath("tests/tango_values.yaml")


def get_values_file():

    try:
        with open(FILE_PATH) as file:
            pytest.values_list = yaml.load(file, Loader=yaml.FullLoader)
    except Exception as e:
        pytest.raises(e)


def get_db_config():
    try:
        pytest.dbHost = "ska-tango-base-" + pytest.values_list["tangodb"]["component"]
        pytest.dbName = pytest.values_list["tangodb"]["db"]["db"]
        pytest.dbUser = pytest.values_list["tangodb"]["db"]["user"]
        pytest.dbPassword = pytest.values_list["tangodb"]["db"]["password"]
    except Exception as e:
        pytest.raises(e)


@pytest.fixture
def mysql_cursor():
    get_values_file()
    get_db_config()
    mysql_cnx = None
    try:
        mysql_cnx = mysql.connector.connect(
            user=pytest.dbUser,
            password=pytest.dbPassword,
            host=pytest.dbHost,
            database=pytest.dbName,
        )
    except mysql.connector.Error as err:
        logging.error(err)
        pytest.raises(Exception("Database connection Error"))

    cursor = mysql_cnx.cursor()
    yield cursor
    cursor.close()
    mysql_cnx.close()
