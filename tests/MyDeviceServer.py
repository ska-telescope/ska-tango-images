from tango.server import Device, run

class MyDevice(Device):
    pass

if __name__ == '__main__':
    run((MyDevice,))
