# Hashitalks: Deploy 2022

## Use Waypoint To Easily Deploy To AWS EKS

## Pre-Requisites:
Note: The follow are specifically the instructions for Mac, the commands may be different for Windows

1. Install the aws cli

```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

2. Export the aws cli credential information

   NOTE: Beware how often your tokens expire, mine expire daily
```
export AWS_ACCESS_KEY_ID=<key_id>
export AWS_SECRET_ACCESS_KEY=<access_key>
export AWS_SESSION_TOKEN=<session_token>
```

3. Install eksctl & create cluster in aws

   NOTE: I do not recommend using the UI
```
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
eksctl version

eksctl create cluster \
--name cassieCluster \  
--version 1.22 \
--region us-east-1 \        
--nodegroup-name linux-nodes \
--node-type t3.small \
--nodes 5 \
--nodes-min 5 \
--nodes-max 10 \
--managed \
--with-oidc
```

4. Create or update the kubeconfig file for your newly created cluster
```
aws eks update-kubeconfig --region us-east-1 --name cassieCluster
cp ~/.kube/config ~/.kube/aws-eks-config
```
OR: 
   
Use an existing context
```
kubectl config --kubeconfig=~/.kube/aws-eks-config use-context <context-name>
```

Optionally: Rename your context
```
kubectl config rename-context <old-context> aws-context
```

5. Confirm kubectl context
```
kubectl config current-context
```

## Build Image locally
```
docker build -t hashicassie/hashitalk-deploy:2022 -f aws/Dockerfile . 
```