Scenario: Connect to the tango database using tango_admin 
  Given the TANGO_HOST is defined in the environment
  When I call the tango_admin command with parameter ping-database
  Then the return code is 0