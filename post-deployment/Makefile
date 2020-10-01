# Use bash shell with pipefail option enabled so that the return status of a
# piped command is the value of the last (rightmost) commnand to exit with a
# non-zero status. This lets us pipe output into tee but still exit on test
# failures.
SHELL = /bin/bash
.SHELLFLAGS = -o pipefail -c

TEST_ARTIFACTS = pytest.stdout report.xml report.json cucumber.json pytest-logs.txt

all: test

# create the build directory
# execute the python tests
# copy TEST_ARTIFACTS into build directory
# exit with same exit code as test run
test: install
	mkdir -p build && \
	find . -name "*.pyc" -type f -delete && \
	PYTHONPATH=/app:/app/testing:/app/testing/post-deployment pytest $(if $(findstring all,$(MARK)),, -m $(MARK)) --disable-pytest-warnings | tee pytest.stdout; \
	status=$$?; \
	echo "Status set at \"$$status\" in post-deployment/Makefile test target"; \
	$(foreach artfct,$(TEST_ARTIFACTS),mv -f $(artfct) build/;) \
	exit $$status

.PHONY: all test install

install:
	pip3 -q install -r test_requirements.txt;
	@echo "############ post-deployment/test_requirements.txt versions not necessarily fixed - see build/python_packages_installed_for_test.pip3 ###############"
	@pip3 list >> python_packages_installed_for_test.pip3
