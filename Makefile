IMG_NAME ?= opsani/servo-k8s-prom
IMG_TAG ?= measure-only

container:
	docker build . -t $(IMG_NAME):$(IMG_TAG)

push:
	docker push $(IMG_NAME):$(IMG_TAG)
