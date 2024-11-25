import os
import re
import sys
import subprocess
import time
import pytest

CI_REGISTRY = os.environ.get('CI_REGISTRY', 'registry.gitlab.com')
CI_PROJECT_NAMESPACE = os.environ.get('CI_PROJECT_NAMESPACE', 'ska-telescope')
CI_PROJECT_NAME = os.environ.get('CI_PROJECT_NAME', 'ska-tango-images')
OCI_REGISTRY = f'{CI_REGISTRY}/{CI_PROJECT_NAMESPACE}/{CI_PROJECT_NAME}'
IMAGES_DIR = os.path.abspath(f"{os.path.dirname(__file__)}/../images")
CI_COMMIT_SHORT_SHA = os.environ.get('CI_COMMIT_SHORT_SHA', None)

# Return code used by tango when you pass invalid arguments
TANGO_CPP_DSERVER_INVALID_ARGS = 255
TANGO_JAVA_DSERVER_INVALID_ARGS = 1

def get_tag(name):
    if CI_COMMIT_SHORT_SHA is None:
        return "local"

    result = subprocess.run(['make', 'show-version', f'RELEASE_CONTEXT_DIR={IMAGES_DIR}/{name}', f'CAR_OCI_REPOSITORY_HOST={OCI_REGISTRY}'], check=True, capture_output=True)

    output = result.stdout.decode()

    for line in output.split('\n'):
        if line.startswith("make"):
            continue
        version = line
        break

    return f'{version}-dev.c{CI_COMMIT_SHORT_SHA}'

def run(args):
    print(f'Running: {args}')

    result = subprocess.run(args, capture_output=True)

    if result.stdout:
        print(f'!! docker stdout:\n{result.stdout.decode()}')
    if result.stderr:
        print(f'!! docker stderr:\n{result.stderr.decode()}')

    return result


def run_in_docker(image: str, command: [str], extra_args: [str] = []):
    args = ['docker', 'run', '--rm']
    args.extend(extra_args)
    args.append(image)
    args.extend(command)

    return run(args)

def check_tango_admin(image: str) -> None:
    command = ['--help']

    extra_args = ['--entrypoint', 'tango_admin']

    result = run_in_docker(image, command, extra_args)

    assert result.returncode == 0


def check_tango_test(image: str) -> None:
    command = ['TangoTest', '-nodb']

    result = run_in_docker(image, command)

    assert result.returncode == TANGO_CPP_DSERVER_INVALID_ARGS
    assert 'usage' in result.stderr.decode()

def check_orchestration_scripts(image: str) -> None:
    command = ['-h']
    extra_args = ['--entrypoint', 'retry']

    result = run_in_docker(image, command, extra_args)

    assert result.returncode == 0
    assert 'Usage' in result.stdout.decode()

    command = []
    extra_args = ['--entrypoint', 'wait-for-it.sh']

    result = run_in_docker(image, command, extra_args)

    assert result.returncode == 1
    assert 'Usage' in result.stderr.decode()


def test_tango_db():
    name='ska-tango-images-tango-db'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'

    def get_health(container):
        args = ['docker', 'inspect', '-f', '{{.State.Health.Status}}', container]
        result = run(args)

        return result.stdout.decode().strip()

    def wait_for_healthy(container):
        health = get_health(container)
        while health == "starting":
            time.sleep(0.5)
            health = get_health(container)

        return health == "healthy"


    # Start the maridbd daemon
    command = []
    extra_args = ['--detach',
            '--name=tango-db',
            '--env=MYSQL_ROOT_PASSWORD=secret',
            '--env=MYSQL_PASSWORD=tango',
            '--env=MYSQL_USER=tango',
            '--env=MYSQL_DATABASE=tango',
            '--health-cmd=healthcheck.sh --connect',
            '--health-start-period=1s',
            '--health-interval=0.5s',
            '--health-timeout=5s',
            '--health-retries=10']
    result = run_in_docker(image, command, extra_args)
    assert result.returncode == 0

    tango_db = result.stdout.decode().strip()
    databaseds = ""

    try:
        assert wait_for_healthy(tango_db)

        # start a Databaseds which connects to tango_db
        name='ska-tango-images-tango-databaseds'
        tag = get_tag(name)

        assert tag is not None

        image = f'{OCI_REGISTRY}/{name}:{tag}'
        extra_args = ['--detach',
                '--name=tango-dbds',
                '--env=TANGO_HOST=localhost:10000',
                '--env=MYSQL_HOST=tango-db:3306',
                '--env=MYSQL_PASSWORD=tango',
                '--env=MYSQL_USER=tango',
                '--env=MYSQL_DATABASE=tango',
                '--health-cmd=tango_admin --ping-database',
                '--health-start-period=1s',
                '--health-interval=0.5s',
                '--health-timeout=5s',
                '--health-retries=10']
        command = ["Databaseds", "2", "-ORBendPoint", "giop:tcp::10000"]
        result = run_in_docker(image, command, extra_args)
        assert result.returncode == 0

        databaseds = result.stdout.decode().strip()
        assert wait_for_healthy(tango_db)

    finally:
        args = ['docker', 'stop', tango_db]
        run(args)
        args = ['docker', 'stop', databaseds]
        run(args)

def test_tango_dsconfig():
    name='ska-tango-images-tango-dsconfig'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_orchestration_scripts(image)
    command = ['json2tango', '--help']

    result = run_in_docker(image, command)

    assert result.returncode == 0

def test_tango_admin():
    name='ska-tango-images-tango-admin'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_orchestration_scripts(image)

def test_tango_databaseds():
    name='ska-tango-images-tango-databaseds'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_orchestration_scripts(image)
    command = ['databaseds']

    result = run_in_docker(image, command)

    assert result.returncode == TANGO_CPP_DSERVER_INVALID_ARGS
    assert 'usage' in result.stderr.decode()

def test_tango_itango():
    name='ska-tango-images-tango-itango'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_orchestration_scripts(image)
    command = ['itango3', '--help']

    result = run_in_docker(image, command)

    assert result.returncode == 0

def test_tango_test():
    name='ska-tango-images-tango-test'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_tango_test(image)
    check_orchestration_scripts(image)

def test_tango_rest():
    name='ska-tango-images-tango-rest'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_orchestration_scripts(image)
    command = ['TangoRestServer']

    result = run_in_docker(image, command)

    assert result.returncode == TANGO_JAVA_DSERVER_INVALID_ARGS
    assert 'usage' in result.stdout.decode()

def test_tango_java():
    name='ska-tango-images-tango-java'
    tag = get_tag(name)

    assert tag is not None

    # For historical reasons, we expect the java image to include TangoTest and
    # tango_admin

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_tango_test(image)
    check_orchestration_scripts(image)

def test_tango_jive():
    name='ska-tango-images-tango-jive'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_orchestration_scripts(image)
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
    check_tango_admin(image)
    check_orchestration_scripts(image)
    command = ['pogo', '--help']

    # pogo 9.8.0 does not start if the display environment variable
    # is not set
    extra_args = ['--env', 'DISPLAY=NO']

    result = run_in_docker(image, command, extra_args)

    assert result.returncode == 0
    assert 'Actions' in result.stdout.decode()

def test_tango_boogie():
    name='ska-tango-images-tango-boogie'
    tag = get_tag(name)

    assert tag is not None

    image = f'{OCI_REGISTRY}/{name}:{tag}'
    check_tango_admin(image)
    check_orchestration_scripts(image)
    command = ['boogie', '-h']

    result = run_in_docker(image, command)

    assert result.returncode == 0
