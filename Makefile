NAME=quay.io/chmouel/buildah-oc-podman

.PHONY: all
all: build push

build:
	docker build . -t ${NAME}

push:
	docker push ${NAME}
