import os
import logging
import pytest
import yaml
import mysql.connector


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
