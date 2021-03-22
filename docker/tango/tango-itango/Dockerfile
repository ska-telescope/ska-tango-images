ARG CAR_OCI_REGISTRY_PREFIX
ARG CAR_OCI_REGISTRY_HOST

FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_PREFIX}/pytango-builder:9.3.3.2 as buildenv
FROM ${CAR_OCI_REGISTRY_HOST}/${CAR_OCI_REGISTRY_PREFIX}/pytango-runtime:9.3.3.2

# create ipython profile to so that itango doesn't fail if ipython hasn't run yet

RUN ipython profile create

CMD ["itango3"]
