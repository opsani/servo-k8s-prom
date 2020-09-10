IMG_NAME ?= opsani/servo-k8s-prom
IMG_TAG ?= $(shell git rev-parse --abbrev-ref HEAD)

container:
	docker build . -t $(IMG_NAME):$(IMG_TAG)

push:
	docker push $(IMG_NAME):$(IMG_TAG)
