# Runbook: Administering and Maintaining the "Hello, World!" Web Server

## Overview
This runbook outlines the steps for administering and maintaining the "Hello, World!" web server deployed using Kubernetes, Helm, and Traefik as the Ingress controller. 

## Table of Contents
- scaling
- logging
- monitoring
- troubleshooting

---

## Docker Commands
 **Build the Docker image**

    ```bash
    docker build -t hello .                           # to build the images throught the Dockerfile created
    docker images                                                      #To list the images
    docker run -d --name helloworld -p 80:80 hello                     #To run the helloworld container 
    docker ps -a
    docker stop helloworld
    docker rm helloworld
    docker tag hello:latest koyaadeniji/helloworld:v1                 #To tag the image and made ready to bt puch to docker hub
    docker push koyaadeniji/helloworld:v1                             #To push image to dockerhub
    ```



## Helm and Kubernetes Commands for SetUp and Troubleshooting
 **Create a Helm chart**

    ```bash
    helm create helloworld                               #
    helm lint helloworld/
    helm install myworld helloworld/
    kubectl get pods
    kubectl get services
    helm upgrade myworld helloworld/
    kubectl get ingresses
    kubectl port-forward service/myworld-helloworld 8080:80
    kubectl logs deployment/myworld-helloworld
    kubectl exec -it (container-name) -- sh
    helm uninstall myworld
    kubectl describe pod (pod-name)
    kubectl cluster-info
    kubectl get componentstatuses
    kubectl config view
    
    ```


 **Adjust Resource Limits and Requests in the Deployment YAML:**
    ```yaml
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
    ```





## Setup for Metrics Server

```bash

   helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
   helm repo update
   helm install metrics-server metrics-server/metrics-server --version 3.8.2
   kubectl edit deployment metrics-server
   kubectl top pod
   kubectl top node
   kubectl scale deployment hello-world-deployment --replicas=<desired-replica-count>
   kubectl autoscale deployment hello-world-deployment --cpu-percent=80 --min=1 --max=10
   kubectl get hpa
   kubectl logs -f deployment/metrics-server
   kubectl logs -f (pod-name)
   ```

    ```
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=8443
        - --kubelet-preferred-address-types=InternalIp,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        - --metric-resolution=15s
        - --kubelet-insecure-tls
    ```



## Setup for Prometheus and Grafana for Monitoring

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm search repo prometheus-community
   helm install promet prometheus-community/kube-prometheus-stack     # promet as release name
   kubectl get pods
   kubectl get svc
   kubectl edit svc (promet-prometheus-service)                       #change service type to LoadBalancer to view externally
   kubectl edit svc  (promet-grafana-service)                        # change service type to Loadbalancer and port number from 80 to 3000
   kubectl get svc                                                   # copy externalIP or the loadbalancer url with their coressponding port number and view over the browser
   helm uninstall (promet)
   ```



## Conclusion
This runbook provides the essential commands and steps required to manage and maintain the "Hello, World!" web server deployed in a Kubernetes environment using Docker and Helm. Follow these instructions to ensure smooth operation, monitoring, and troubleshooting of the web server.













