import logging
import pytest
import yaml
import mysql.connector

FILE_PATH = "/app/testing/tango_values.yaml"
mysql_cnx = None


@pytest.fixture
def getValuesFile():
    try:
        with open(FILE_PATH) as file:
            values_list = yaml.load(file, Loader=yaml.FullLoader)
            return values_list
    except Exception as e:
        pytest.raises(e)


@pytest.fixture
def getDBConfig(getValuesFile):
    mysql_config = dict()
    try:
        mysql_config["host"] = 'ska-tango-base-' + getValuesFile['tangodb']['component']
        mysql_config["database"] = getValuesFile['tangodb']['db']['db']
        mysql_config["user"] = getValuesFile['tangodb']['db']['user']
        mysql_config["password"] = getValuesFile['tangodb']['db']['password']
        return mysql_config
    except Exception as e:
        pytest.raises(e)


def init_mysql_db_connection(getDBConfig):
    global mysql_cnx
    try:
        logging.debug(
            "########################### Initializing Mysql Connection " + str(mysql_cnx))
        mysql_cnx = mysql.connector.connect(**getDBConfig)
    except mysql.connector.Error as err:
        logging.error(err)
        pytest.raises(Exception("Database connection Error"))


def delete_mysql_db_connection():
    logging.debug(
        "########################### Closing Mysql Connection " + str(mysql_cnx))
    mysql_cnx.close()


def test_database_connection(getDBConfig):
    try:
        cnx = mysql.connector.connect(**getDBConfig)

    except mysql.connector.Error as err:
        logging.error(err)
        pytest.raises(Exception("Database connection Error"))
    else:
        cnx.close()
        assert 1


def test_tango_database_is_present():
    cursor = mysql_cnx.cursor()
    try:
        cursor.execute("SHOW DATABASES")
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        cursor.close()
        delete_mysql_db_connection()
        exit(1)

    database_names = []
    for database_name in cursor:  # NB database_name is a tuple
        print(database_name)
        database_names.append(database_name)

    cursor.close()
    delete_mysql_db_connection()
    assert ('tango',) in database_names


def test_tango_database_tables():
    cursor = mysql_cnx.cursor()
    try:
        cursor.execute("SHOW TABLES")
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        cursor.close()
        delete_mysql_db_connection()
        exit(1)
    expected_tables = (
        'access_address', 'access_device', 'attribute_alias', 'attribute_class',
        'class_attribute_history_id', 'class_history_id', 'class_pipe_history_id',
        'device', 'device_attribute_history_id', 'device_history_id',
        'device_pipe_history_id', 'event', 'object_history_id', 'property',
        'property_attribute_class', 'property_attribute_class_hist',
        'property_attribute_device', 'property_attribute_device_hist',
        'property_class', 'property_class_hist', 'property_device',
        'property_device_hist', 'property_hist', 'property_pipe_class',
        'property_pipe_class_hist', 'property_pipe_device',
        'property_pipe_device_hist', 'server'
    )
    actual_tables = []
    for table_name in cursor:  # NB table_name is a tuple
        print(table_name)
        actual_tables.append(table_name[0])

    cursor.close()
    delete_mysql_db_connection()
    assert actual_tables == list(expected_tables)


def test_databaseds_server_is_registered_in_the_database():
    cursor = mysql_cnx.cursor()

    try:
        cursor.execute("SELECT name FROM device")
    except mysql.connector.Error as err:
        print("Failed creating database: {}".format(err))
        cursor.close()
        delete_mysql_db_connection()
        exit(1)

    actual_devices = []
    for device_name in cursor:  # NB device_name is a tuple
        print(device_name)
        actual_devices.append(device_name[0])

    cursor.close()
    delete_mysql_db_connection()
    assert "sys/database/2" in actual_devices
