
Feature: tango-db
	Test tango db connection

Scenario: Test mysql connection
	Given Tango env tango_values.yaml
	When I extract the DB config in the databaseds-ska-tango-base-{{.Release.Name}}
	Then I check the tango database connection

# ping database

