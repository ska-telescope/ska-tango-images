# check device
Scenario: Call Command and test attribute
	Given a device called sys/tg_test/1
	When I call the command State()
	Then the attribute State is RUNNING

# ping database