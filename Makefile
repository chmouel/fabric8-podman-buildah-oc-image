NAME=quay.io/chmouel/buildah-oc-podman:latest

.PHONY: all
all: build push

build:
	docker build -t ${NAME} -f Dockerfile.fedora .

push:
	docker push ${NAME}
