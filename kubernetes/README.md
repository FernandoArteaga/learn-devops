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
an [HorizontalPodAutoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale) (HPA)
and a simple [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) (without SSL termination).

### Create the resources

For creating the [resources](./manifests), we will need to have the `kubectl` command-line tool installed, a local 
Kubernetes cluster running, and the `my-awesome-app` image built and available in a container registry. For this example
we can use [Docker Desktop Kubernetes cluster](https://docs.docker.com/desktop/kubernetes/), [Minikube](https://minikube.sigs.k8s.io/docs/start/),
[Kind](https://kind.sigs.k8s.io/), or any other Kubernetes cluster.

We'll use `Kind` to create a local Kubernetes cluster. But feel free to use any other tool you are comfortable with.

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
4. Install the kubernetes `metrics-server` for the HPA to work
   ```sh
   helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
   helm repo update
   helm upgrade --install --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server --namespace kube-system
   ```
5. Create a namespace named `learn-devops`, where we will deploy the resources
   ```sh
   kubectl create namespace learn-devops
   ```
6. Deploy the resources in the `learn-devops` namespace
   ```sh
   kubectl apply -n learn-devops -f ./manifests
   ```
7. Check that `my-awesome-app` is running
   ```sh
   kubectl get pods -n learn-devops
   ```
8. Open the application in the browser, and you should see `my-awesome-app` running 👏
   ```sh
   open http://localhost/my-awesome-app
   ```

#### Make the HPA work

The HPA will only work if the application is under load. We can simulate a traffic load by using the [wrk](https://github.com/wg/wrk) tool.

Install `wrk` with Homebrew (macOS) 
```sh
brew install wrk
```

Watch the Pods running in the `learn-devops` namespace
```sh
kubectl get pods -n learn-devops -w
```

Open a new terminal window and run the following command to generate some traffic. This will simulate 12 threads and
400 connections for 30 seconds.
```sh
wrk -t12 -c400 -d1m http://localhost/my-awesome-app
```

You should see the number of Pods increasing in the terminal where you are watching the Pods running
(it could take a few seconds). And once the traffic stops, the number of Pods should decrease (always respecting the
`stabilizationWindowSeconds` defined in the HPA manifest)

### Clean up

Clean up everything by deleting the kind cluster
```sh
kind delete cluster --name learn-devops
```
