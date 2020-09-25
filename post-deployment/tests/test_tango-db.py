import logging
import pytest
from pytest_bdd import scenario, given, when, then, scenarios, parsers
import yaml
import mysql.connector
from mysql.connector import errorcode

pytest.namespace = ""

@given(parsers.parse("Tango env {values_file}"))
def getPodName(values_file):

    try:
        with open(values_file) as file:
            pytest.values_list = yaml.load(file, Loader=yaml.FullLoader)
    except Exception as e:
        pytest.raises(e)
        


@when(parsers.parse("I extract the DB config in the {device_name}"))
def getDBConfig(device_name):

    try:
        deviceList : list = pytest.values_list['deviceServers']
        
        for device in deviceList:
            if device['name'] == device_name:
                varList: list = device['environment_variables']

                for var in varList:
                    if var['name'] == 'MYSQL_HOST':
                        host : str = var['value']
                        pytest.dbHost = host.split(":")[0]
                    if var['name'] == 'MYSQL_DATABASE':
                        pytest.dbName = var['value']
                    if var['name'] == 'MYSQL_USER':
                        pytest.dbUser = var['value']
                    if var['name'] == 'MYSQL_PASSWORD':
                        pytest.dbPassword = var['value']

    except Exception as e:
        pytest.raises(e)
    

@then(parsers.parse("I check the tango database connection"))
def queryDB():
    try:
        cnx = mysql.connector.connect(
            user=pytest.dbUser,
            password=pytest.dbPassword,
            host=pytest.dbHost,
            database=pytest.dbName
        )

    except mysql.connector.Error as err:
            logging.error(err)
            pytest.raises(Exception("Database connection Error"))
    else:
        cnx.close()

scenarios('../features/tango-db.feature')
