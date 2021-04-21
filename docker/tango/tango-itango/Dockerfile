ARG CAR_OCI_REGISTRY_PREFIX
ARG CAR_OCI_REGISTRY_HOST

FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_PREFIX}/pytango-builder:9.3.3.3 as buildenv
FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_PREFIX}/pytango-runtime:9.3.3.3

# create ipython profile to so that itango doesn't fail if ipython hasn't run yet

RUN ipython profile create

COPY requirements.txt /requirements.txt
RUN python3 -m pip install -r /requirements.txt

CMD ["itango3"]
