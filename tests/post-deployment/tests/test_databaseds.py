import tango


def test_databaseds_connection():
    db = tango.Database()
    assert db is not None


def test_device_registration(mysql_cursor):
    db = tango.Database()
    test_device = tango.DbDevInfo()
    test_device.name = "test/device/1"
    test_device._class = "TestDevice"
    test_device.server = "TestDevice/test"
    db.add_server(test_device.server, test_device, with_dserver=True)

    mysql_cursor.execute("SELECT name,class,server FROM device WHERE name='test/device/1';")
    database_info = [info for info in mysql_cursor]
    assert ('test/device/1', 'TestDevice', 'TestDevice/test') in database_info


def test_device_property_registration(mysql_cursor):
    db = tango.Database()
    test_device = tango.DbDevInfo()
    test_device.name = "test/device/1"
    test_device._class = "TestDevice"
    test_device.server = "TestDevice/test"
    db.add_server(test_device.server, test_device, with_dserver=True)
    db.put_device_property(test_device.name, {"test_property": ["test_property_value"]})

    mysql_cursor.execute("SELECT name,device FROM property_device where device='test/device/1'")
    database_info = [info for info in mysql_cursor]
    assert ("test_property", "test/device/1") in database_info
