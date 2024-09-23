import os
import re
import sys
import subprocess
import pytest

CI_REGISTRY = os.environ.get('CI_REGISTRY', 'registry.gitlab.com')
CI_PROJECT_NAMESPACE = os.environ.get('CI_PROJECT_NAMESPACE', 'ska-telescope')
CI_PROJECT_NAME = os.environ.get('CI_PROJECT_NAME', 'ska-tango-images')
OCI_REGISTRY = f'{CI_REGISTRY}/{CI_PROJECT_NAMESPACE}/{CI_PROJECT_NAME}'
IMAGES_DIR = os.environ['SKA_TANGO_IMAGES_DIR']

RELEASE_REGEX = re.compile(r'^release=(.*)$')

# Return code used by tango when you pass no arguments
TANGO_DSERVER_NO_ARGS = 255

def get_tag(name):
    with open(f'{IMAGES_DIR}/{name}/.release', 'r') as f:
        for line in f:
            m = RELEASE_REGEX.match(line)
            if m is not None:
                return m.group(1)

def run_in_docker(image: str, command: [str], extra_args: [str] = []):
    args = ['docker', 'run', '--rm']
    args.extend(extra_args)
    args.append(image)
    args.extend(command)

    print(f'Running: {args}')

    result = subprocess.run(args, capture_output=True)

    if result.stdout:
        print(f'!! docker stdout:\n{result.stdout.decode()}')
    if result.stderr:
        print(f'!! docker stderr:\n{result.stderr.decode()}', file=sys.stderr)

    return result

def test_tango_dsconfig():
    name='ska-tango-images-tango-dsconfig'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    command = ['json2tango', '--help']

    result = run_in_docker(image, command)

    assert result.returncode == 0

def test_tango_admin():
    name='ska-tango-images-tango-admin'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    command = ['tango_admin', '--help']

    result = run_in_docker(image, command)

    assert result.returncode == 0

def test_tango_databaseds():
    name='ska-tango-images-tango-databaseds'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    command = ['databaseds']

    result = run_in_docker(image, command)

    assert result.returncode == TANGO_DSERVER_NO_ARGS
    assert 'usage' in result.stderr.decode()

def test_tango_itango():
    name='ska-tango-images-tango-itango'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    command = ['itango3', '--help']

    result = run_in_docker(image, command)

    assert result.returncode == 0

@pytest.mark.xfail(reason="FIXME: WOM-230")
def test_tango_test():
    name='ska-tango-images-tango-test'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    command = ['TangoTest']

    result = run_in_docker(image, command)

    assert result.returncode == TANGO_DSERVER_NO_ARGS
    assert 'usage' in result.stderr.decode()

def test_tango_rest():
    name='ska-tango-images-tango-rest'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    command = ['supervisord', '--help']

    result = run_in_docker(image, command)

    assert result.returncode == 0
    assert 'Usage' in result.stdout.decode()

def test_tango_jive():
    name='ska-tango-images-tango-jive'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    # Jive 7.36.0 prints out the usage if we give it a bogus option
    command = ['jive', '--not-an-option']

    result = run_in_docker(image, command)

    # It exits with 0 even though this is an error
    assert result.returncode == 0
    assert 'Usage' in result.stdout.decode()

def test_tango_pogo():
    name='ska-tango-images-tango-pogo'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    command = ['pogo', '--help']

    # pogo 9.8.0 does not start if the display environment variable
    # is not set
    extra_args = ['--env', 'DISPLAY=NO']

    result = run_in_docker(image, command, extra_args)

    assert result.returncode == 0
    assert 'Actions' in result.stdout.decode()
