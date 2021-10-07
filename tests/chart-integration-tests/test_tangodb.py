import pytest


@pytest.mark.namespace(create=True, name='test')
@pytest.mark.applymanifests('../../charts/ska-tango-base', files=[
    'gen_tangodb.yaml'
])
def test_tangodb(kube):
    """An example test against an tangodb deployment."""

    # wait for the manifests loaded by the 'applymanifests' marker
    # to be ready on the cluster
    kube.wait_for_registered(timeout=300)

    services = kube.get_services()
    tangodb_service = services.get('ska-tango-base-tangodb')
    assert tangodb_service is not None
    assert tangodb_service.is_ready()

    statefulsets = kube.get_statefulsets()
    tangodb_statefultest = statefulsets.get('ska-tango-base-tangodb')
    assert tangodb_statefultest is not None

    pods = tangodb_statefultest.get_pods()
    assert len(pods) == 1, 'tangodb should deploy with one replica'

    for pod in pods:
        containers = pod.get_containers()
        assert len(containers) == 1, 'tangodb pod should have one container'

    tango_service_endpoints = tangodb_service.get_endpoints()
    assert len(tango_service_endpoints) == 1

    # Test connnection to the database?