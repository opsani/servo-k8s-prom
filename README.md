# Opsani Servo for Kubernetes Applications with Prometheus Monitoring

This project contains the container manifest for building an Opsani Servo
container image.

This particular Servo includes plugins to provide support for applications
running on *Kubernetes* clusters and instrumented to provide metrics through a
*Prometheus* monitoring system. For more information on Servos and available plugins,
see https://github.com/opsani/servo.

The Servo container created in this project and published at Docker Hub as `opsani/servo-k8s-prom:latest`
refers to the latest versions of the Kubernetes and Prometheus plugins. It is suited as-is
primarily for initial deployment and testing. For production use, most organizations will want to clone
this repository and build their own Servo, using the organization's official base image,
tying the versions of the plugins, and publishing it in their preferred image repositories.
 

## Building the Servo container

To build the Servo container image, use the following command and then push
the image to your desired image repository.

```
docker build . -t example.com/servo-k8s-prom
```

## Running the Servo

Before running the Servo, make sure that you create the `config.yaml` file (or k8s ConfigMap)
with `k8s:` and `prom:` sections in it. These sections define which Kubernetes deployment
resouce will be tuned and which settings, as well as what metrics will be collected from Prometheus.

Please see the [Kubernetes](https://github.com/opsani/servo-k8s) and [Prometheus](https://github.com/opsani/servo-prom) plugin
documentation for details on the configuration.

You will also need your account ID, application ID and API token for the Opsani service. These are configured in the Servo's deployment resource.

To run the Servo, you typically need the following 4 Kubernetes resources:

* a config map with the Servo configuration (as described above)
* a secret with the Opsani API token
* a deployment for the Servo container
* a service account to run the Servo container 

For an example of the Servo resouces, see https://github.com/opsani/co-http/tree/master/k8s-canary-envoy and, specifically, the `opsani-servo.yaml` and 
`rbac.yaml` files.

## Servo connectivity

In order to operate, the Servo requires that its pod has the following network connectivity:

* outgoing access to the Opsani API endpoint (https)
* access to the Kubernetes cluster API endpoint
* access to the Prometheus API endpoint

Please see the [Kubernetes plugin](https://github.com/opsani/servo-k8s) for a list of permissions required by the Kubernetes plugin.

## Servo logs

This servo logs data it sends to the Opsani service, as well as details of any errors it encounters. If your Servo is not connecting, please check the logs to see the cause.