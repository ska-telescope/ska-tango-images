KUBE_NAMESPACE ?= ska-docker#namespace to be used
RELEASE_NAME ?= test## release name of the chart
UMBRELLA_CHART_PATH ?= ska-docker/## Path of the umbrella chart to work with
HELM_HOST ?= https://nexus.engageska-portugal.pt## helm host url https
MINIKUBE ?= true## Minikube or not

.DEFAULT_GOAL := help

namespace: ## create the kubernetes namespace
	@kubectl describe namespace $(KUBE_NAMESPACE) > /dev/null 2>&1 ; \
		K_DESC=$$? ; \
		if [ $$K_DESC -eq 0 ] ; \
		then kubectl describe namespace $(KUBE_NAMESPACE); \
		else kubectl create namespace $(KUBE_NAMESPACE); \
		fi

help:  ## show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

publish-charts: ## publish charts 
	mkdir -p repository
	@for i in tango-base/ archiver/ tango-util/; do \
	helm package $${i} --destination ./repository ; \
	done \
	for i in repository/*; do \
	curl -v -u $(HELM_USERNAME):$(HELM_PASSWORD) --upload-file $${i} $(HELM_HOST)/repository/helm-chart/$${i}
	done

install-chart: namespace## install the helm chart with name RELEASE_NAME and path UMBRELLA_CHART_PATH on the namespace KUBE_NAMESPACE 
	helm install $(RELEASE_NAME) --dependency-update \
	--set minikube=$(MINIKUBE) \
	 $(UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE) 

uninstall-chart: ## uninstall the ska-docker helm chart on the namespace ska-docker
	helm template  $(RELEASE_NAME) $(UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE)  | kubectl delete -f - ; \
	helm uninstall  $(RELEASE_NAME) --namespace $(KUBE_NAMESPACE) 

reinstall-chart: uninstall-chart install-chart ## reinstall the ska-docker helm chart on the namespace ska-docker

upgrade-chart: ## upgrade the ska-docker helm chart on the namespace ska-docker
	helm upgrade --set minikube=$(MINIKUBE) $(RELEASE_NAME) $(UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE) 

.PHONY: help