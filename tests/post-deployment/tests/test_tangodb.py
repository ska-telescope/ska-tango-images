import logging
import pytest
import yaml
import mysql.connector

FILE_PATH = "/app/testing/tango_values.yaml"


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


def test_tango_database_is_present(mysql_cursor):
    mysql_cursor.execute("SHOW DATABASES")

    database_names = []
    for database_name in mysql_cursor:
        database_names.append(database_name[0])

    assert "tango" in database_names


def test_tango_database_tables(mysql_cursor):
    mysql_cursor.execute("SHOW TABLES")

    expected_tables = (
        "access_address",
        "access_device",
        "attribute_alias",
        "attribute_class",
        "class_attribute_history_id",
        "class_history_id",
        "class_pipe_history_id",
        "device",
        "device_attribute_history_id",
        "device_history_id",
        "device_pipe_history_id",
        "event",
        "object_history_id",
        "property",
        "property_attribute_class",
        "property_attribute_class_hist",
        "property_attribute_device",
        "property_attribute_device_hist",
        "property_class",
        "property_class_hist",
        "property_device",
        "property_device_hist",
        "property_hist",
        "property_pipe_class",
        "property_pipe_class_hist",
        "property_pipe_device",
        "property_pipe_device_hist",
        "server",
    )
    actual_tables = []
    for table_name in mysql_cursor:
        actual_tables.append(table_name[0])

    assert actual_tables == list(expected_tables)


def test_databaseds_server_is_registered_in_the_database(mysql_cursor):
    mysql_cursor.execute("SELECT name FROM device")

    actual_devices = []
    for device_name in mysql_cursor:
        actual_devices.append(device_name[0])

    assert "sys/database/2" in actual_devices
