"""Functions for extracting version information from the repo."""

import os
import re
import subprocess
from pathlib import Path

REPO_DIR = os.path.abspath(f"{os.path.dirname(__file__)}/../../")
"""The toplevel directory of this repo."""

def get_version(dir: Path = Path(REPO_DIR)) -> str:
    """Return the version to describe dir.

    This has different behaviour depending on if we are running locally,
    in a CI job for an MR, in a CI job for a tag, or in readthedocs.  This 
    is detected using the following environment variables:
        - CI_JOB_ID
        - READTHEDOCS
        - CI_COMMIT_TAG

    :param dir: Directory to look for .release file
    :return: The version
    """
    is_ci_job = "CI_JOB_ID" in os.environ
    is_rtd_job = "READTHEDOCS" in os.environ
    is_tag_job = "CI_COMMIT_TAG" in os.environ
    is_local_job = not is_ci_job and not is_rtd_job

    # Return "local" for images when a local job
    if is_local_job and dir is not None:
        return "local"

    # When running on the CI, use the commit tag for images
    if is_ci_job and not is_tag_job and dir is not None:
        return os.environ["CI_COMMIT_SHORT_SHA"]

    with open(dir / '.release') as f:
        for line in f:
            if line.startswith('release'):
                return line.strip().removeprefix('release=')

def get_git_description() -> str:
    """Return the git description of HEAD.

    :return: The output of git describe
    """
    result = subprocess.run(['git', 'describe', '--tags', '--always', 'HEAD'], check=True, capture_output=True)

    return result.stdout.decode()

def get_doc_substitutions() -> dict[str, str]:
    """Return a list of all substitutions to apply in the documentation.

    This has different behaviour depending on if we are running locally,
    in a CI job for an MR, in a CI job for a tag, or in readthedocs.  This 
    is detected using the following environment variables:
        - CI_JOB_ID
        - READTHEDOCS
        - CI_COMMIT_TAG

    :return: Map from substitutee to substitutand
    """
    result = {}

    if "CI_COMMIT_TAG" in os.environ or "READTHEDOCS" in os.environ:
        result["oci-registry"] = "artefact.skao.int"
    else:
        result["oci-registry"] = "registry.gitlab.com/ska-telescope/ska-tango-images"

    for dockerfile in Path(f'{REPO_DIR}/images').rglob('Dockerfile'):
        dir = dockerfile.parent
        name = str(dir).removeprefix(f'{REPO_DIR}/images/ska-tango-images-')

        version = get_version(dir)

        result[f"{name}-imgver"] = version

    version_regex = re.compile("([0-9]+\.[0-9]+(\.[0-9]+)?)")
    upstream_to_strip = ["DATABASEDS_VERSION", "DATABASEDS_TANGODB_VERSION", "TANGOADMIN_VERSION"]
    with open(f'{REPO_DIR}/scripts/upstream-versions') as f:
        for line in f.readlines():
            if line.startswith("#"):
                continue
            name, version = line.strip().split('=')
            if name in upstream_to_strip:
                version = version_regex.search(version).group(1)
            name = name.lower().replace('_', '-')

            result[name] = version

    return result
