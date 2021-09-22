BASE = $(shell pwd)

# include all makefile templates
include .make/*.mk

# include your own private variables for custom deployment configuration
-include PrivateRules.mak
