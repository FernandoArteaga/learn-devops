# Kubernetes

Kubernetes is an open-source platform designed to automate deploying, scaling, and operating application containers.
It is called a container orchestrator because it ensures that the containers are running as expected, and offers high
availability and scalability out of the box.

## Kubernetes Manifests

Kubernetes' manifests are files that describe the desired state of the application you want to run on the cluster, or
the resources you want to create. They are written in YAML and can be used to create, update, or delete these resources.

We'll use the [kubectl](https://kubernetes.io/docs/reference/kubectl/quick-reference/) command-line tool to interact
with the Kubernetes cluster and manage the resources.

### What we will be deploying

We will deploy [my-awesome-app](../my-awesome-app/README.md) to the Kubernetes cluster. For that, we will need to create
a [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), a [Service](https://kubernetes.io/docs/concepts/services-networking/service/), 
and a simple [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) (without SSL termination).

### Create the resources

For creating the [resources](./manifests), we will need to have the `kubectl` command-line tool installed, a local 
Kubernetes cluster running, and the `my-awesome-app` image built and available in a container registry. We can make use
of the [Docker Desktop Kubernetes cluster](https://docs.docker.com/desktop/kubernetes/), [Minikube](https://minikube.sigs.k8s.io/docs/start/),
[Kind](https://kind.sigs.k8s.io/), or any other Kubernetes cluster.

We'll use Kind to create a local Kubernetes cluster. But feel free to use any other tool you are comfortable with.

1. Create a kind cluster with `extraPortMappings` and `node-labels` for configuring the Ingress controller
   ```sh
   kind create cluster --name learn-devops --config=./kind-config.yaml
   ```
2. Create an Ingress controller
   ```sh
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
   ```
3. Wait for the Ingress controller to be running
   ```sh
   kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
   ```
4. Create a namespace named `learn-devops`, where we will deploy the resources
   ```sh
   kubectl create namespace learn-devops
   ```
5. Deploy the resources in the `learn-devops` namespace
   ```sh
   kubectl apply -n learn-devops -f ./manifests
   ```
6. Check that `my-awesome-app` is running
   ```sh
   kubectl get pods -n learn-devops
   ```
7. Open the application in the browser, and you should see `my-awesome-app` running 👏
   ```sh
   open http://localhost/my-awesome-app
   ```

Clean up everything by deleting the kind cluster
```sh
kind delete cluster --name learn-devops
```
