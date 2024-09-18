# GLS-NEXT Code challenge

This repository contains the code for the resolution of the challenge.

To provide a beeter understanding, for each spefic part, there is a different README file with detailed information.

## Pre requisites

To be able to execute the solution of the challenge, these are the tools you need to have installed in your machine:

| Tool | How to install |
|------|----------------|
| minikube | https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download | 
| Docker | https://docs.docker.com/desktop/install/mac-install/ |
| python3 | brew install python|
| kubectl |https://kubernetes.io/docs/tasks/tools/ | 
| git | https://git-scm.com/book/en/v2/Getting-Started-Installing-Git | 

## How to run the application

### Python App
The details about how to run/build and deploy the application can be found [here](/code/README.md)

### Local Infrastrucuture

 - Install Minikube
 - Check the connectivity from yout system with minikube
 ````bash
    kubectl get pods
 ````
 - The command above should return a result simit to this:
 ```` bash
    NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
    kube-system   coredns-6f6b679f8f-hqkr8           1/1     Running   0          46s
    kube-system   etcd-minikube                      1/1     Running   0          51s
    kube-system   kube-apiserver-minikube            1/1     Running   0          52s
    kube-system   kube-controller-manager-minikube   1/1     Running   0          51s
    kube-system   kube-proxy-pb5gg                   1/1     Running   0          46s
    kube-system   kube-scheduler-minikube            1/1     Running   0          51s
    kube-system   storage-provisioner                1/1     Running   0          45s
````
- Now you are ble to deploy the application in your local cluster.
- If you can't access the cluster, please go to [minikube](https://minikube.sigs.k8s.io/docs/) documentation


## Design choices

### Current Scenario

For the code challenge, a simplest approach is in place to avoid problems to run in other machines.

To remove the complexity to install github-runners, elasticsearch, fluentd, kibana, prometheus and grafana in the local machine, simple solutions are in place to have the application running with the bare minimum.

### Pipeline

I'm using the [pipeline](.github/workflows/pipeline.yml) solution provided bit Github
with the runners provided by Github to build and deploy the application.

The image is build and send to my personal dockerhub repository, and the deployment occours in a temporaty instance of Minikube, to ensure the manifests and the application are working fine.

#### Limitation

With this approach, the deployment in our local cluster (Minikube) is not possible.

To deploy the application in the local environment we need to execute it manually from the local terminal.

- Check if the namespace (dev) will be used to deploy the app is created
```bash
kubectl get namespaces
NAME                   STATUS   AGE
default                Active   119d
kube-node-lease        Active   119d
kube-public            Active   119d
kube-system            Active   119d
kubernetes-dashboard   Active   119d
```

- If it is not present, we need to create it:
```bash
kubectl create namespace dev
```

- We can deploy the application now:
```bash
kubectl apply -f kubernetes-manifests/python-app.yaml --namespace dev
```

#### Solving limitations and Implementing Monitoring

In the real world the application will be running in a real cluster

It will enable us to build and deploy the application using our on infrastructure 

To solve the deployment limitations and provide a proper monitoring, the landscape bellow ilustrate how it will be configured:

![Diagram](diagram.png)

- To solve the limitation to deploy the application in the cluster, the Github Runners will be installed in the cluster and they will be configured to access the cluster and deploy the application.

- As an improvement, the strategy to deploy the application will be switched from kubectl to use HELM releases. The manifests can be found [here](/helm-python-app/). In the pipeline, the step to deploy the application will be like the below snippet:
```bash
                name: Deploy to minikube
                run: 
                    helm upgrade -i --namespace dev --create-namespace python-app ./helm-python-app -f helm-python-app/values.yaml
```


- The basic monitoring of the cluster will be done EFK (ElasticSearch + FluentBit + Grafana) solution for logs and Prometheus and Grafana for resources.


    - Installing Prometheus and Grafana
    Prometheus will expose the metrics from the cluster and application related to the usage of the resources like CPU and memory for e.g. and in Grafana we can create graphs and alerts to monitor it.

    - In order to have a reliable monitoring, Prometheus will be installed in the cluster and grafana will be installed in a [compute instance](/terraform_scripts/grafana.tf).
    ```bash
    helm install prometheus prometheus-community/prometheus
    ```

    - The same approach from Prometheus and Grafana will be used to EFK, only the forwarder will be installed in the cluster (FluentD) and [ElasticSearch](/terraform_scrpits/elasticsearch.tf) and [Kibana](/terraform_scripts/kibana.tf) will be installed in compute instances.
    ```bash
    helm install fluentd oci://registry-1.docker.io/bitnamicharts/fluentd
    ```
- For alerting, I'll use Grafana to send alerts Downtime, High CPU usage, Increase of the error in logs.
    - For resource alerts, I'll create a datasource to connect to Prometheus and create the dashboards to monitor the app.
    - For logs, I'll created a datasource to connect to ElasticSearch and create a query count the number of the errors, when this count exceed a number, an alert will be started.
    - Those alerts will be send by email and the internal communication tool, and for critical error to the phones of responsibles from the application.