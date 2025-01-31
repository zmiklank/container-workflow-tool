.PHONY: test-in-container build-generator push-generator

TEST_IMAGE=cwt-tests
GENERATOR_IMAGE=quay.io/rhscl/cwt-generator
UNAME=$(shell uname)
ifeq ($(UNAME),Darwin)
	PODMAN := /usr/local/bin/docker
else
	PODMAN := /usr/bin/podman
endif

.PHONY: test
test:
	PYTHONPATH=.:$$PYTHONPATH python3 -W ignore::DeprecationWarning -m unittest -v

build:
	$(PODMAN) build --tag $(TEST_IMAGE) -f Dockerfile.tests .

test-in-container:
	$(PODMAN) run --rm -it $(TEST_IMAGE)

build-generator:
	$(PODMAN) build --tag ${GENERATOR_IMAGE} -f Dockerfile.generator .

push-generator: build-generator
	$(PODMAN) push ${GENERATOR_IMAGE}
