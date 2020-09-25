import os
import pytest
import logging

from tango import DeviceProxy
from collections import namedtuple

## shared fixtures
from resources.test_support.fixtures import run_context

"""
Taken from https://gitlab.com/ska-telescope/skampi/-/blob/21e00f36a5fa797ad816ec8c40954f6a3a70b040/post-deployment/tests/conftest.py

RunContext is a metadata object to access values from the environment, 
i.e. data that is injected in by the Makefile. Useful if tests need to 
be aware of the k8s context they are running in, such as the HELM_RELEASE.

This will allow tests to resolve hostnames and other dynamic properties.

Example:

def test_something(run_context):
    HOSTNAME = 'some-pod-{}'.format(run_context.HELM_RELEASE)

"""

