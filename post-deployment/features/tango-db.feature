# check device
Feature: tango-bd
	Test tango bd connection

Scenario: Test mysql connection
	Given Tango env tango_values.yaml
	When I extract the DB config in the databaseds-tango-base-test 
	Then I check the tango database connection

# ping database

