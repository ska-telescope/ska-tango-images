import logging
import pytest
import yaml
import mysql.connector
from mysql.connector import errorcode
import os


def getValuesFile():

    print(f"Path ========> {os.getcwd()}")
    try:
        with open("/app/testing/tango_values.yaml") as file:
            pytest.values_list = yaml.load(file, Loader=yaml.FullLoader)
    except Exception as e:
        pytest.raises(e)


def getDBConfig():
    try:
        pytest.dbHost = 'ska-tango-base-' + pytest.values_list['tangodb']['component']
        pytest.dbName = pytest.values_list['tangodb']['db']['db']
        pytest.dbUser = pytest.values_list['tangodb']['db']['user']
        pytest.dbPassword = pytest.values_list['tangodb']['db']['password']
    except Exception as e:
        pytest.raises(e)


def test_database_connection():
    getValuesFile()
    getDBConfig()
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
        assert 1


def test_tango_database_is_present():
    getValuesFile()
    getDBConfig()
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
        # cnx.close()
        assert 1

    
    cursor = cnx.cursor()

    try:
        cursor.execute("SHOW DATABASES")
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        cnx.close()
        exit(1)
    
    database_names = []
    for database_name in cursor:  # NB database_name is a tuple
        print(database_name)
        database_names.append(database_name)
    
    cnx.close()
    assert ('tango',) in database_names
    

def test_tango_database_tables():
    getValuesFile()
    getDBConfig()
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
        # cnx.close()
        assert 1

    
    cursor = cnx.cursor()

    try:
        cursor.execute("SHOW TABLES")
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        cnx.close()
        exit(1)
    expected_tables = (
        'access_address','access_device','attribute_alias','attribute_class',
        'class_attribute_history_id','class_history_id','class_pipe_history_id',
        'device','device_attribute_history_id','device_history_id',
        'device_pipe_history_id','event','object_history_id','property',
        'property_attribute_class','property_attribute_class_hist',
        'property_attribute_device','property_attribute_device_hist',
        'property_class','property_class_hist','property_device',
        'property_device_hist','property_hist','property_pipe_class',
        'property_pipe_class_hist','property_pipe_device',
        'property_pipe_device_hist','server'
    )
    actual_tables = []
    for table_name in cursor:  # NB table_name is a tuple
        print(table_name)
        actual_tables.append(table_name[0])

    assert actual_tables == list(expected_tables)


def test_databaseds_server_is_registered_in_the_database():
    getValuesFile()
    getDBConfig()
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
        # cnx.close()
        assert 1

    
    cursor = cnx.cursor()

    try:
        cursor.execute("SELECT name FROM device")
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        cnx.close()
        exit(1)
    
    actual_devices = []
    for device_name in cursor:  # NB device_name is a tuple
        print(device_name)
        actual_devices.append(device_name[0])

    assert "sys/database/2" in actual_devices
