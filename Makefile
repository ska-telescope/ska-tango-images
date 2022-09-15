BASE = $(shell pwd)

HELM_CHARTS ?= ska-tango-util ska-tango-base
HELM_CHARTS_TO_PUBLISH ?= $(HELM_CHARTS)
OCI_IMAGES ?= ska-tango-images-tango-dependencies ska-tango-images-tango-cpp ska-tango-images-tango-java ska-tango-images-tango-rest ska-tango-images-pytango-builder ska-tango-images-tango-pogo ska-tango-images-tango-libtango ska-tango-images-tango-jive ska-tango-images-pytango-runtime ska-tango-images-tango-admin ska-tango-images-tango-databaseds ska-tango-images-tango-test ska-tango-images-tango-dsconfig ska-tango-images-tango-itango ska-tango-images-tango-vnc ska-tango-images-tango-pytango ska-tango-images-tango-panic ska-tango-images-tango-panic-gui
OCI_IMAGES_TO_PUBLISH ?= $(OCI_IMAGES)

KUBE_NAMESPACE ?= ska-tango-images#namespace to be used
RELEASE_NAME ?= test## release name of the chart
K8S_CHART = ska-tango-umbrella
MINIKUBE ?= true ## Minikube or not
K8S_TEST_IMAGE_TO_TEST ?= artefact.skao.int/ska-tango-images-tango-itango:9.3.9 ## TODO: UGUR docker image that will be run for testing purpose
CI_JOB_ID ?= local##pipeline job id
TEST_RUNNER ?= test-mk-runner-$(CI_JOB_ID)##name of the pod running the k8s_tests
TANGO_HOST ?= makefile-databaseds-also-node-port:10000## TANGO_HOST connection to the Tango DS
TANGO_SERVER_PORT ?= 45450## TANGO_SERVER_PORT - fixed listening port for local server
K8S_CHARTS ?= ska-tango-util ska-tango-base ska-tango-umbrella## list of charts to be published on gitlab -- umbrella charts for testing purpose

CI_PROJECT_PATH_SLUG ?= ska-tango-images
CI_ENVIRONMENT_SLUG ?= ska-tango-images

K8S_CHART_PARAMS ?=  --set global.minikube=$(MINIKUBE) --set global.exposeDatabaseDS=$(MINIKUBE) --set global.exposeAllDS=$(MINIKUBE) --set global.tango_host=$(TANGO_HOST) --set global.device_server_port=$(TANGO_SERVER_PORT)

# K8S_TEST_MAKE_PARAMS = KUBE_NAMESPACE=$(KUBE_NAMESPACE) HELM_RELEASE=$(RELEASE_NAME) TANGO_HOST=$(TANGO_HOST) MARK=$(MARK)
# K8S_CHART_PARAMS = --set global.minikube=$(MINIKUBE) --set global.tango_host=$(TANGO_HOST) --values $(BASE)/charts/values.yaml

PYTHON_VARS_BEFORE_PYTEST = PYTHONPATH=${PYTHONPATH}:/app:/app/tests KUBE_NAMESPACE=$(KUBE_NAMESPACE) HELM_RELEASE=$(RELEASE_NAME) TANGO_HOST=$(TANGO_HOST)

PYTHON_VARS_AFTER_PYTEST = --disable-pytest-warnings --timeout=300

RELEASE_SUPPORT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/.make-release-support

# include OCI Images support
include .make/oci.mk

# include k8s support
include .make/k8s.mk

# include Helm Chart support
include .make/helm.mk

# include raw support
include .make/raw.mk

# include core make support
include .make/base.mk

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
	read -p "$(POWDER_BLUE)Do you wish to continue (you will be prompted at each step)$(NORMAL) $(YELLOW)[N=No/s=skip/y=yes]$(NORMAL): " SHALL_WE; \
	if [[ "y" == "$${SHALL_WE}" ]] || [[ "Y" == "$${SHALL_WE}" ]]; then \
		echo "$(GREEN) OK - ✨ bumping patch for .release files ...$(NORMAL)"; \
		make oci-bump-patch-release OCI_IMAGES_TO_PUBLISH="$${OCI_IMAGES_TO_RELEASE}"; \
	else \
		if [[ "s" == "$${SHALL_WE}" ]] || [[ "S" == "$${SHALL_WE}" ]]; then \
			echo "$(YELLOW) OK - 👍 Skipping bumping patch for .release files ...$(NORMAL)"; \
		else \
			printf "$(RED) 😱 OK - aborting$(NORMAL).\n 💀"; \
			exit 1; \
		fi; \
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

helm-pre-build: helm-pre-publish

helm-pre-lint: helm-pre-publish ## make sure auto-generate values.yaml happens

# use pre update hook to update chart values
k8s-pre-install-chart:
	make helm-pre-publish
	@echo "k8s-pre-install-chart: setting up charts/values.yaml"
	@cd charts; \
	sed -e 's/CI_PROJECT_PATH_SLUG/$(CI_PROJECT_PATH_SLUG)/' ci-values.yaml > generated_values.yaml; \
	sed -e 's/CI_ENVIRONMENT_SLUG/$(CI_ENVIRONMENT_SLUG)/' generated_values.yaml > values.yaml

k8s-pre-template-chart:
	make helm-pre-publish

k8s-pre-test:
	@echo "k8s-pre-test: setting up tests/values.yaml"
	cp charts/ska-tango-base/values.yaml tests/tango_values.yaml

# install helm plugin from https://github.com/quintush/helm-unittest
k8s-chart-test: helm-pre-publish
	helm package charts/ska-tango-util/ -d charts/ska-tango-base/charts/; \
	mkdir -p charts/build; \
	helm unittest charts/ska-tango-base/ --helm3 --with-subchart \
		--output-type JUnit --output-file charts/build/chart_template_tests.xml
