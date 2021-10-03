BASE = $(shell pwd)

HELM_CHARTS_TO_PUBLISH ?= ska-tango-util ska-tango-base
# OCI_IMAGES ?= ska-tango-images-tango-dependencies ska-tango-images-tango-dependencies-alpine ska-tango-images-tango-db ska-tango-images-tango-cpp ska-tango-images-tango-cpp-alpine ska-tango-images-tango-java ska-tango-images-tango-java-alpine ska-tango-images-tango-rest ska-tango-images-tango-rest-alpine ska-tango-images-pytango-builder ska-tango-images-pytango-builder-alpine ska-tango-images-tango-pogo ska-tango-images-tango-pogo-alpine ska-tango-images-tango-libtango ska-tango-images-tango-jive ska-tango-images-tango-jive-alpine ska-tango-images-pytango-runtime ska-tango-images-pytango-runtime-alpine ska-tango-images-tango-admin ska-tango-images-tango-databaseds ska-tango-images-tango-test ska-tango-images-tango-dsconfig ska-tango-images-tango-itango ska-tango-images-tango-vnc ska-tango-images-tango-vnc-alpine ska-tango-images-tango-pytango ska-tango-images-tango-panic ska-tango-images-tango-panic-gui
OCI_IMAGES ?= ska-tango-images-tango-dependencies ska-tango-images-tango-dependencies-alpine ska-tango-images-tango-db ska-tango-images-tango-cpp ska-tango-images-tango-cpp-alpine ska-tango-images-tango-java ska-tango-images-tango-java-alpine ska-tango-images-tango-rest ska-tango-images-pytango-builder ska-tango-images-pytango-builder-alpine ska-tango-images-tango-pogo ska-tango-images-tango-libtango ska-tango-images-tango-jive ska-tango-images-pytango-runtime ska-tango-images-pytango-runtime-alpine ska-tango-images-tango-admin ska-tango-images-tango-databaseds ska-tango-images-tango-test ska-tango-images-tango-dsconfig ska-tango-images-tango-itango ska-tango-images-tango-vnc ska-tango-images-tango-pytango ska-tango-images-tango-panic ska-tango-images-tango-panic-gui
OCI_IMAGES_TO_PUBLISH ?= $(OCI_IMAGES)

KUBE_NAMESPACE ?= ska-tango-images#namespace to be used
RELEASE_NAME ?= test## release name of the chart
UMBRELLA_CHART_PATH ?= ska-tango-umbrella/## Path of the umbrella chart to work with
# HELM_HOST ?= https://artefact.skatelescope.org # helm host url https
MINIKUBE ?= true ## Minikube or not
MARK ?= all
IMAGE_TO_TEST ?= artefact.skao.int/ska-tango-images-tango-itango:9.3.4 ## TODO: UGUR docker image that will be run for testing purpose
CI_JOB_ID ?= local##pipeline job id
TEST_RUNNER ?= test-mk-runner-$(CI_JOB_ID)##name of the pod running the k8s_tests
TANGO_HOST ?= tango-host-databaseds-from-makefile-$(RELEASE_NAME):10000## TANGO_HOST is an input!
CHARTS ?= ska-tango-util ska-tango-base ska-tango-umbrella## list of charts to be published on gitlab -- umbrella charts for testing purpose
# LINTING_OUTPUT=$(shell helm lint --with-subcharts $(UMBRELLA_CHART_PATH) | grep ERROR -c | tail -1)

CI_PROJECT_PATH_SLUG ?= ska-tango-images
CI_ENVIRONMENT_SLUG ?= ska-tango-images

RELEASE_SUPPORT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/.make-release-support

# include OCI Images support
include .make/oci.mk

# include Helm Chart support
include .make/helm.mk

# include make support
include .make/make.mk

# include help support
include .make/help.mk

# include core release support
include .make/release.mk

# include your own private variables for custom deployment configuration
-include PrivateRules.mak

oci-bump-patch-release: ## Bump patch release for all OCI Image .release files in ./images/<dir>
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make bump-patch-release RELEASE_CONTEXT_DIR=images/$(ociimage);)

oci-bump-minor-release: ## Bump minor release for all OCI Image .release files in ./images/<dir>
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make bump-minor-release RELEASE_CONTEXT_DIR=images/$(ociimage);)

oci-bump-major-release: ## Bump major release for all OCI Image .release files in ./images/<dir>
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make bump-major-release RELEASE_CONTEXT_DIR=images/$(ociimage);)

custom-oci-publish-all: ## Custom Publish all OCI Images in OCI_IMAGES_TO_PUBLISH using image local .release
	$(foreach ociimage,$(OCI_IMAGES_TO_PUBLISH), make oci-publish OCI_IMAGE=$(ociimage) RELEASE_CONTEXT_DIR=images/$(ociimage);)

# Colour bank https://stackoverflow.com/questions/4332478/read-the-current-text-color-in-a-xterm/4332530#4332530
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
LIME_YELLOW=$(shell tput setaf 190)
POWDER_BLUE=$(shell tput setaf 153)
BLUE=$(shell tput setaf 4)
NORMAL=$(shell tput sgr0)

make-a-release: ## Step through the process of bumping .release and creating a tag
	@clear; \
	printf "This is a guild to creating a release of ska-tango-images, including OCI Images and Helm Charts.\n You $(YELLOW) 🔥MUST🔥$(NORMAL) first have merged your Merge Request!!!\nThe steps are:\n * git checkout master && git pull \n * Select and bump OCI Image .release's \n * bump project .release  $(YELLOW)AND$(NORMAL) update Helm Chart release  $(YELLOW)AND$(NORMAL) the tango-util version dependency in tango-base \n * Commit .release and $(YELLOW)ANY$(NORMAL) outstanding changes, and set project git tag \n * Push changes and tag \n\n $(LIME_YELLOW)✋ The current git status (outstanding) is:$(NORMAL) \n $$(git status -b) \n"; \
	read -p "$(POWDER_BLUE)Do you wish to continue (you will be prompted at each step)$(NORMAL) $(YELLOW)[N/y]$(NORMAL): " SHALL_WE; \
	if [[ "y" == "$${SHALL_WE}" ]] || [[ "Y" == "$${SHALL_WE}" ]]; then \
		echo "$(GREEN)❗ OK - lets build a release ...$(NORMAL)"; \
	else \
		printf "$(RED) 😱 OK - aborting$(NORMAL).\n 💀"; \
		exit 1; \
	fi;

	@printf "\nStep 1: >> git checkout master && git pull\nswitching from branch: $$(git branch --show-current) to master\n"; \
	read -p "$(POWDER_BLUE)Do you wish to continue (you will be prompted at each step)$(NORMAL) $(YELLOW)[N/y]$(NORMAL): " SHALL_WE; \
	if [[ "y" == "$${SHALL_WE}" ]] || [[ "Y" == "$${SHALL_WE}" ]]; then \
		echo "$(GREEN) OK - ✨ lets switch to master and pull ...$(NORMAL)"; \
		git checkout master && git pull; \
	else \
		printf "$(RED) 😱 OK - aborting$(NORMAL).\n 💀"; \
		exit 1; \
	fi;

	@printf "\nStep 2: Select and bump OCI Image .release's \n Tell me which of the following OCI_IMAGES_TO_PUBLISH list to bump patch release for: $(OCI_IMAGES_TO_PUBLISH)\n"; \
	read -p "$(POWDER_BLUE)Enter list here$(NORMAL): " OCI_IMAGES_TO_RELEASE; \
	printf "\n You provided: $${OCI_IMAGES_TO_RELEASE}\n"; \
	read -p "$(POWDER_BLUE)Do you wish to continue (you will be prompted at each step)$(NORMAL) $(YELLOW)[N/y]$(NORMAL): " SHALL_WE; \
	if [[ "y" == "$${SHALL_WE}" ]] || [[ "Y" == "$${SHALL_WE}" ]]; then \
		echo "$(GREEN) OK - ✨ bumping patch .release files ...$(NORMAL)"; \
		make oci-bump-patch-release OCI_IMAGES_TO_PUBLISH="$${OCI_IMAGES_TO_RELEASE}"; \
	else \
		printf "$(RED) 😱 OK - aborting$(NORMAL).\n 💀"; \
		exit 1; \
	fi;

	@printf "\nStep 3: Bump project .release AND update Helm Chart release\n"; \
	read -p "$(POWDER_BLUE)Do you wish to continue (you will be prompted at each step)$(NORMAL) $(YELLOW)[N/y]$(NORMAL): " SHALL_WE; \
	if [[ "y" == "$${SHALL_WE}" ]] || [[ "Y" == "$${SHALL_WE}" ]]; then \
		echo "$(GREEN) OK - ✨ bumping patch on project .release file and updating Helm Charts ...$(NORMAL)"; \
		make bump-patch-release && make helm-set-release; \
		NEW_VERSION=$$(. $(RELEASE_SUPPORT) ; RELEASE_CONTEXT_DIR=$(RELEASE_CONTEXT_DIR) setContextHelper; getVersion); \
		sed -i.x -e "N;s/\(name: ska-tango-util.*version:\).*/\1 $${NEW_VERSION}/;P;D" charts/ska-tango-base/Chart.yaml; \
		rm -f charts/*/Chart.yaml.x; \
		printf "\n $(LIME_YELLOW)✋ The updated git status (outstanding) is:$(NORMAL) \n $$(git status -b) \n"; \
		printf "\n $(LIME_YELLOW)✋ The git diff is:$(NORMAL) \n $$(git diff) \n"; \
	else \
		printf "$(RED) 😱 OK - aborting$(NORMAL).\n 💀"; \
		exit 1; \
	fi;

	@printf "\nStep 4: Commit .release and $(YELLOW)ANY$(NORMAL) outstanding changes, and set project git tag\n"; \
	read -p "$(POWDER_BLUE)Do you wish to continue (you will be prompted at each step)$(NORMAL) $(YELLOW)[N/y]$(NORMAL): " SHALL_WE; \
	if [[ "y" == "$${SHALL_WE}" ]] || [[ "Y" == "$${SHALL_WE}" ]]; then \
		echo "$(GREEN) OK - ✨ doing commit and tag ...$(NORMAL)"; \
		make create-git-tag; \
	else \
		printf "$(RED) 😱 OK - aborting$(NORMAL).\n 💀"; \
		exit 1; \
	fi;

	@printf "\nStep 5: Push changes and tag\n"; \
	read -p "$(POWDER_BLUE)Do you wish to continue (you will be prompted at each step)$(NORMAL) $(YELLOW)[N/y]$(NORMAL): " SHALL_WE; \
	if [[ "y" == "$${SHALL_WE}" ]] || [[ "Y" == "$${SHALL_WE}" ]]; then \
		echo "$(GREEN) OK - ✨ doing push ...$(NORMAL)"; \
		make push-git-tag; \
		echo "$(LIME_YELLOW)🌟 All done! 🌟$(NORMAL)"; \
	else \
		printf "$(RED) 😱 OK - aborting$(NORMAL).\n 💀"; \
		exit 1; \
	fi;

clean: ## clean out references to chart tgz's
	@cd charts/ && rm -f ./*/charts/*.tgz ./*/Chart.lock ./*/requirements.lock

k8s: ## Which kubernetes are we connected to
	@echo "Kubernetes cluster-info:"
	@kubectl cluster-info
	@echo ""
	@echo "kubectl version:"
	@kubectl version
	@echo ""
	@echo "Helm version:"
	@helm version --client

namespace: ## create the kubernetes namespace
	@kubectl describe namespace $(KUBE_NAMESPACE) > /dev/null 2>&1 ; \
		K_DESC=$$? ; \
		if [ $$K_DESC -eq 0 ] ; \
		then kubectl describe namespace $(KUBE_NAMESPACE); \
		else kubectl create namespace $(KUBE_NAMESPACE); \
		fi

delete_namespace: ## delete the kubernetes namespace
	@if [ "default" = "$(KUBE_NAMESPACE)" ] || [ "kube-system" = "$(KUBE_NAMESPACE)" ]; then \
		echo "You cannot delete Namespace: $(KUBE_NAMESPACE)"; \
		exit 1; \
	else \
		kubectl describe namespace $(KUBE_NAMESPACE) && kubectl delete namespace $(KUBE_NAMESPACE); \
	fi

package: helm-pre-publish ## package charts
	@echo "Packaging helm charts. Any existing file won't be overwritten."; \
	mkdir -p ./tmp
	@for i in $(CHARTS); do \
		helm package charts/$${i} --dependency-update --destination ../tmp > /dev/null; \
	done; \
	mkdir -p ./repository && cp -n ../tmp/* ../repository; \
	cd ./repository && helm repo index .; \
	rm -rf ./tmp

helm-pre-publish: ## hook before helm chart publish
	@echo "helm-pre-publish: generating charts/ska-tango-base/values.yaml"
	@cd charts/ska-tango-base && bash ./values.yaml.sh

helm-pre-lint: helm-pre-publish ## make sure auto-generate values.yaml happens

dep-up: helm-pre-publish ## update dependencies for every charts in the env var CHARTS
	@cd charts; \
	for i in $(CHARTS); do \
		helm dependency update $${i}; \
	done;

install-chart: clean dep-up namespace## install the helm chart with name RELEASE_NAME and path UMBRELLA_CHART_PATH on the namespace KUBE_NAMESPACE
	@cd charts; \
	sed -e 's/CI_PROJECT_PATH_SLUG/$(CI_PROJECT_PATH_SLUG)/' ci-values.yaml > generated_values.yaml; \
	sed -e 's/CI_ENVIRONMENT_SLUG/$(CI_ENVIRONMENT_SLUG)/' generated_values.yaml > values.yaml; \
	helm install $(RELEASE_NAME) \
		--set global.minikube=$(MINIKUBE) \
		--set global.tango_host=$(TANGO_HOST) \
		--values values.yaml \
		$(UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE); \
	 rm generated_values.yaml; \
	 rm values.yaml

template-chart: clean dep-up## install the helm chart with name RELEASE_NAME and path UMBRELLA_CHART_PATH on the namespace KUBE_NAMESPACE
	@cd charts; \
	sed -e 's/CI_PROJECT_PATH_SLUG/$(CI_PROJECT_PATH_SLUG)/' ci-values.yaml > generated_values.yaml; \
	sed -e 's/CI_ENVIRONMENT_SLUG/$(CI_ENVIRONMENT_SLUG)/' generated_values.yaml > values.yaml; \
	helm template $(RELEASE_NAME) \
	--set global.minikube=$(MINIKUBE) \
	--set global.tango_host=$(TANGO_HOST) \
	--values values.yaml \
	--debug \
	 $(UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE); \
	 rm generated_values.yaml; \
	 rm values.yaml

uninstall-chart: ## uninstall the ska-tango-images helm chart on the namespace ska-tango-images
	@cd charts; \
	sed -e 's/CI_PROJECT_PATH_SLUG/$(CI_PROJECT_PATH_SLUG)/' ci-values.yaml > generated_values.yaml; \
	sed -e 's/CI_ENVIRONMENT_SLUG/$(CI_ENVIRONMENT_SLUG)/' generated_values.yaml > values.yaml; \
	helm template $(RELEASE_NAME) \
	--set global.minikube=$(MINIKUBE) \
	--set global.tango_host=$(TANGO_HOST) \
	--values values.yaml \
	 $(UMBRELLA_CHART_PATH) --namespace $(KUBE_NAMESPACE) | kubectl delete -f - ; \
	 rm generated_values.yaml; \
	 rm values.yaml; \
	 helm uninstall  $(RELEASE_NAME) --namespace $(KUBE_NAMESPACE)

reinstall-chart: uninstall-chart install-chart ## reinstall the ska-tango-images helm chart on the namespace ska-tango-images

# chart_lint: clean dep-up## lint check the helm chart
# 	mkdir -p build; helm lint $(UMBRELLA_CHART_PATH) --with-subcharts --namespace $(KUBE_NAMESPACE); \
# 	echo "<testsuites><testsuite errors=\"$(LINTING_OUTPUT)\" failures=\"0\" name=\"helm-lint\" skipped=\"0\" tests=\"0\" time=\"0.000\" timestamp=\"$(shell date)\"> </testsuite> </testsuites>" > build/linting.xml
# 	exit $(LINTING_OUTPUT)

wait: ## wait for pods to be ready
	@echo "Waiting for pods to be ready"
	@date
	@kubectl -n $(KUBE_NAMESPACE) get pods
	#jobs=$$(kubectl get job --output=jsonpath={.items..metadata.name} -n $(KUBE_NAMESPACE)); kubectl wait job --for=condition=complete --timeout=900s $$jobs -n $(KUBE_NAMESPACE)
	@kubectl -n $(KUBE_NAMESPACE) wait --for=condition=ready -l app=ska-tango-images --timeout=900s pods || exit 1
	@date

#
# defines a function to copy the ./test-harness directory into the K8s TEST_RUNNER
# and then runs the requested make target in the container.
# capture the output of the test in a tar file
# stream the tar file base64 encoded to the Pod logs
#
k8s_test = tar -c tests/post-deployment/ | \
		kubectl run $(TEST_RUNNER) \
		--namespace $(KUBE_NAMESPACE) -i --wait --restart=Never \
		--image-pull-policy=IfNotPresent \
		--image=$(IMAGE_TO_TEST) \
		--limits='cpu=1000m,memory=500Mi' \
		--requests='cpu=900m,memory=400Mi' -- \
		/bin/bash -c "mkdir testing && tar xv --directory testing --strip-components 2 --warning=all && cd testing && \
		make KUBE_NAMESPACE=$(KUBE_NAMESPACE) HELM_RELEASE=$(RELEASE_NAME) TANGO_HOST=$(TANGO_HOST) MARK=$(MARK) $1 && \
		tar -czvf /tmp/build.tgz build && \
		echo '~~~~BOUNDARY~~~~' && \
		cat /tmp/build.tgz | base64 && \
		echo '~~~~BOUNDARY~~~~'" \
		2>&1

# call 'k8s_test' and pass it arg 'test' - look for $1
# run the test function
# save the status
# clean out build dir
# print the logs minus the base64 encoded payload
# pull out the base64 payload and unpack build/ dir
# base64 payload is given a boundary "~~~~BOUNDARY~~~~" and extracted using perl
# clean up the run to completion container
# exit the saved status
test: helm-pre-publish ## test the application on K8s
	cp charts/ska-tango-base/values.yaml tests/post-deployment/tango_values.yaml; \
	$(call k8s_test,test); \
		status=$$?; \
		rm -fr build; \
		kubectl --namespace $(KUBE_NAMESPACE) logs $(TEST_RUNNER) | \
		perl -ne 'BEGIN {$$on=0;}; if (index($$_, "~~~~BOUNDARY~~~~")!=-1){$$on+=1;next;}; print if $$on % 2;' | \
		base64 -d | tar -xzf -; \
		kubectl --namespace $(KUBE_NAMESPACE) delete pod $(TEST_RUNNER); \
		rm tests/post-deployment/tango_values.yaml; \
		echo "Status set at \"$$status\" in ./Makefile test target"; \
		exit $$status

show:
	echo $$TANGO_HOST
