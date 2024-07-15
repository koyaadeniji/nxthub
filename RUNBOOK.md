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
    docker build -t hello .
    docker images
    docker run -d --name helloworld -p 80:80 hello
    docker ps -a
    docker stop helloworld
    docker rm helloworld
    docker tag hello:latest koyaadeniji/helloworld:v1
    docker push koyaadeniji/helloworld:v1
    ```



## Helm and Kubernetes Commands
 **Create a Helm chart**

    ```bash
    helm create helloworld
    helm lint helloworld/
    helm install myworld helloworld/
    kubectl get pods
    kubectl get services
    helm upgrade myworld helloworld/
    kubectl get ingresses
    kubectl port-forward service/myworld-helloworld 8080:80
    kubectl logs deployment/myworld-helloworld
    kubectl exec -it myworld-helloworld-5bcdf77544-87q87 -- sh
    helm uninstall myworld
    kubectl describe pod myworld-helloworld-5bcdf77544-9hgjp
    ```


## Monitoring and Metrics
1. **Get Horizontal Pod Autoscaler (HPA)**

    kubectl scale deployment hello-world-deployment --replicas=<desired-replica-count>
    kubectl autoscale deployment hello-world-deployment --cpu-percent=80 --min=1 --max=10
    kubectl get hpa
    
2. **Top pods for resource usage**
    ```bash
    kubectl top pod
    ```
3. **Top nodes for resource usage**
    ```bash
    kubectl top node
    ```

4. **Adjust Resource Limits and Requests in the Deployment YAML:**
    ```yaml
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
    ```



## Troubleshooting
1. **Get current Kubernetes context**
    ```bash
    kubectl config current-context
    ```
2. **View Kubernetes configuration**
    ```bash
    kubectl config view
    ```
3. **Get cluster info**
    ```bash
    kubectl cluster-info
    ```
4. **Get component statuses**
    ```bash
    kubectl get componentstatuses
    ```
5. **Logs from a specific pod**
    ```bash
    kubectl logs myworld-helloworld-7749867b4d-s9bq8
    ```
6. **Describe a pod for troubleshooting**
    ```bash
    kubectl describe po myworld-helloworld-7749867b4d-s9bq8
    ```



## Additional Setup for Metrics Server
1. **Add metrics-server Helm repository**
    ```bash
    helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
    ```
2. **Install metrics-server using Helm**
    ```bash
    helm install my-metrics-server metrics-server/metrics-server --version 3.8.2
    ```
3. **Edit metrics-server deployment to access insecure tls**

    ```bash
    kubectl edit deployment/metrics-server -n kube-system
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
        
4. **Logs from metrics-server deployment**
    ```bash
    kubectl logs -f deployment/metrics-server -n kube-system
    ```
5. **Get all metrics-server pods**
    ```bash
    kubectl get po -n kube-system -l k8s-app=metrics-server
    ```

## Conclusion
This runbook provides the essential commands and steps required to manage and maintain the "Hello, World!" web server deployed in a Kubernetes environment using Docker and Helm. Follow these instructions to ensure smooth operation, monitoring, and troubleshooting of the web server.













