import pytest
import tango


@pytest.fixture
def test_device_info():
    device_info = tango.DbDevInfo()
    device_info.name = "test/device/1"
    device_info._class = "TestDevice"
    device_info.server = "TestDevice/test"
    return device_info


def test_databaseds_connection():
    db = tango.Database()
    assert db is not None


def test_device_registration(test_device_info, mysql_cursor):
    db = tango.Database()
    db.add_server(test_device_info.server, test_device_info, with_dserver=True)

    mysql_cursor.execute("SELECT name,class,server FROM device WHERE name='test/device/1';")
    database_info = [info for info in mysql_cursor]
    assert ("test/device/1", "TestDevice", "TestDevice/test") in database_info


def test_device_property_registration(test_device_info, mysql_cursor):
    db = tango.Database()
    db.add_server(test_device_info.server, test_device_info, with_dserver=True)
    db.put_device_property(
        test_device_info.name, {"device_test_property": ["device_test_property_value"]}
    )

    mysql_cursor.execute("SELECT name,device FROM property_device where device='test/device/1'")
    database_info = [info for info in mysql_cursor]
    assert ("device_test_property", "test/device/1") in database_info


def test_class_property_registration(test_device_info, mysql_cursor):
    db = tango.Database()
    db.add_server(test_device_info.server, test_device_info, with_dserver=True)
    db.put_class_property(
        test_device_info._class, {"class_test_property": ["class_test_property_value"]}
    )

    mysql_cursor.execute("SELECT name,value FROM property_class where class='TestDevice'")
    database_info = [info for info in mysql_cursor]
    assert ("class_test_property", "class_test_property_value") in database_info


def test_device_attribute_property_registration(test_device_info, mysql_cursor):
    db = tango.Database()
    db.add_server(test_device_info.server, test_device_info, with_dserver=True)
    db.put_device_attribute_property(
        test_device_info.name,
        {"test_attribute": {"attribute_test_property": ["attribute_test_property_value"]}},
    )

    mysql_cursor.execute(
        "SELECT attribute,name,value FROM property_attribute_device where device='test/device/1'"
    )
    database_info = [info for info in mysql_cursor]
    assert (
        "test_attribute",
        "attribute_test_property",
        "attribute_test_property_value",
    ) in database_info


# Unhappy paths
