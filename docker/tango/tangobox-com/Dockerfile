FROM nexus.engageska-portugal.pt/ska-docker/ska-python-buildenv:9.3.3.1 as ska

FROM registry.gitlab.com/s2innovation/tangobox-docker/tangobox-com
COPY --from=ska /usr/local/bin/retry /usr/local/bin/retry
