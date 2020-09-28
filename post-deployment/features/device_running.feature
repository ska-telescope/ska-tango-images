# check device is running
# @skip
Scenario: Test device is running
	Given a device called sys/tg_test/1
	When I call the command State()
	Then the attribute State is RUNNING
