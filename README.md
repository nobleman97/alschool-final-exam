## Step 1: Install Deps
- AWS cli
- Kops
- Terraform

## Step 2: Define ENV
```bash
export AWS_ACCESS_KEY_ADMIN_USER=REDACTED
export AWS_SECRET_KEY_ADMIN_USER=REDACTED

export AWS_ACCESS_KEY_KOPS_USER=""
export AWS_SECRET_KEY_KOPS_USER=""
```


## Step 3: Run Terraform Plan and apply
then...

```bash
export AWS_ACCESS_KEY=$AWS_ACCESS_KEY_ADMIN_USER
export AWS_SECRET_KEY=$AWS_SECRET_KEY_ADMIN_USER
```


Run:
```bash
terraform plan

terraform apply
```


Then...
```bash
export AWS_ACCESS_KEY_KOPS_USER=$(terraform output kops_iam_key | tr -d '"')
export AWS_SECRET_KEY_KOPS_USER=$(terraform output kops_iam_secret | tr -d '"')
```



Then configure nameserver based on output

## Step 4: Get AZ and create cluster

```aws ec2 describe-availability-zones --region us-west-2```
use us-west-2

```bash


export KOPS_CLUSTER_NAME=kops.davido.live
export KOPS_BUCKET_NAME=$(terraform output kops_bucket_name | tr -d '"')
export KOPS_STATE_STORE=s3://${KOPS_BUCKET_NAME}

export CONTROL_PLANE_SIZE="t3.medium"
export NODE_SIZE="t3.medium"

kops create cluster \
    --name=${KOPS_CLUSTER_NAME} \
    --node-count 2 \
    --cloud=aws \
    --node-size ${NODE_SIZE} \
    --ssh-public-key=~/.ssh/exam4.pub \
    --zones=us-west-2a \
    --control-plane-size $CONTROL_PLANE_SIZE \
    --discovery-store=${KOPS_STATE_STORE}/${KOPS_CLUSTER_NAME}/discovery \
    --yes

```

Wait until cluster is ready before proceeding:
```bash
kops validate cluster --wait 10m
```

## Step 5: If you want to update cluster

```bash
kops edit cluster
```

Then save by running:
```bash
kops update cluster --name ${KOPS_CLUSTER_NAME} --yes --admin

```

## Step 6: Export Kubeconfig for Kubectl
```bash
kops export kubeconfig --admin
```

Test it:
```bash
kubectl get nodes -o wide
```
## Step 7: Configure the Instance nodes

<!-- Run:
```bash
kubectl get ig
```

From the output, note the name of **the node instance group**

Next, adjust the node instance group to host 2 worker nodes by runnning:
```bash
kubectl replace -f manifests/ig.yml -->
```

## Step 8: Deploy the app
Run:
```bash

kubectl create namespace sock-shop
kubectl apply -f microservices-demo/deploy/kubernetes/complete-demo.yaml
```

## Step 9: Set up ingress controller
Run:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/cloud/deploy.yaml
```

Create an ingress resource for sock-shop frontend
```bash

 # Ensure that you change the host in all ingress files and 
 # create an appropriate A name record where necessary
kubectl apply -f manifests/sock-ingress.yml 
```

## Step 10: Deploy Adminer
```bash
kubectl apply -f adminer
```

## Step 11: Deploy Monitoring and the ingress for them



```bash
kubectl apply -f microservices-demo/deploy/kubernetes/manifests-monitoring

 # Deploy the ingress resources
 # Ensure that you change the host in all ingress files and 
 # create an appropriate A name record where necessary
kubectl apply -f manifests/monitoring-ingress.yml


```

## Step 12: SetUp Monitoring
```bash
kubectl apply -f https://raw.githubusercontent.com/fluent/fluentd-kubernetes-daemonset/master/fluentd-daemonset-elasticsearch-rbac.yaml


kubectl apply -f microservices-demo/deploy/kubernetes/manifests-logging

```


# Troubleshooting
- 1. If at any point in time



timeout 2s ping lB | grep -oP '\(\K[\d.]+(?=\))'
