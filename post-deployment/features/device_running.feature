# check device
@skip
Scenario: Test device is running
	Given a device called sys/tg_test/1
	When I call the command state()
	Then the attribute DevState is RUNNING
