# check device is running
# @skip
Feature: Device commands

Scenario: Test device is running
	Given a device called sys/tg_test/1
	When I call the command State()
	Then the attribute State is RUNNING

Scenario: Test DevString command
	Given a device called sys/tg_test/1
	When I call the command DevString(Hello World!)
	Then the attribute State is Hello World!