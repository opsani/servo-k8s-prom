# Optune Servo with Kubernetes (adjust) and Prometheus (measure) drivers

## Build servo container
```
docker build . -t example.com/servo-k8s-prom
```

## --- Running servo as a Deployment within the application namespace

WIP

> The `OPTUNE_USE_DEFAULT_NAMESPACE` environment variable set to `1` is used when the servo is embedded in the application itself (e.g., runs as a pod within the same namespace); this allows the namespace to be different from the `app_id` given to the servo.

## --- Running servo outside of the application namespace/cluster

WIP

Notes:
- `app_id` has to match the namespace
- if not running on the same cluster, map `/root/.kube/config` into the servo filesystem

## --- Configuring Prometheus credentials

WIP

## --- Open issues

* initially, `apache2-util` Linux package is included for simple testing with `ab`; it should be removed