# check device
Scenario: Call Command and test attribute
	Given a device called <device_name>
	When I call the command <command_name>
	Then the attribute <attribute_name> is <expected_value>

Examples:
		| device_name    | command_name | attribute_name | expected_value |
		| sys/tg_test/1  | State()      | State          | RUNNING        |
		| sys/database/2 | State()      | State          | RUNNING        |