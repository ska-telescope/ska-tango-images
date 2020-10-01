Feature: Test tango tools

Scenario: Connect to the tango database using tango_admin 
  Given the TANGO_HOST is defined in the environment
  When I call the tango_admin command with parameter ping-database
  Then the return code is 0

@xfail
Scenario: Test starting itango session
  Given the TANGO_HOST is defined in the environment
  When I call the itango3 command with parameter simple-prompt
  Then the return code is 0

Scenario: Test REST interface
  Given the TANGO_HOST is defined in the environment
  When I make a request with user tango-cs:tango to http://tango-base-tango-rest:8080/tango/rest/rc4/hosts/TANGO_HOST/10000/devices/sys/tg_test/1/attributes/boolean_scalar/value
  Then the return code is 200
  And the result quality is ATTR_VALID
  And the result name is boolean_scalar