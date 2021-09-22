BASE = $(shell pwd)

HELM_CHARTS_TO_PUBLISH = ska-tango-util ska-tango-base

# include all makefile templates
include .make/*.mk

# include your own private variables for custom deployment configuration
-include PrivateRules.mak
