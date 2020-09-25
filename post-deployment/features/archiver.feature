@skip
Scenario: Test Configuration Manager device is ON
	Given a device called archiving/hdbpp/confmanager01
	When I call the command state()
	Then the attribute DevState is ON

@skip
Scenario: Test Event Subscriber device is ON
	Given a device called archiving/hdbpp/eventsubscriber01
	When I call the command state()
	Then the attribute DevState is ON
