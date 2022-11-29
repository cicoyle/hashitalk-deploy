# Hashitalks: Deploy

## Use Waypoint To Easily Deploy To All Three Cloud Providers
Hashitalks: Deploy 2022

Creating a simple gRPC client & server in Go to accept incoming 
messages from the client and returns a response to the client.

This simple app will be deployed to k8s clusters in 3 cloud providers: AWS, GCP, Azure.

### Repo Setup:
- Generate the Go specific gRPC code using the `protoc` tool
- Create go.mod to track code dependencies
- Run server
- Run client to talk to server
```
protoc --go_out=plugins=grpc:hello hello.proto
go mod init github.com/hashitalk-deploy
go mod tidy
go run <cloud>/server.go
go run <cloud>/client.go
```

### Docker Steps
```
docker login -u "hashicassie" -p '<pwd>' docker.io
docker build -t hashicassie/hashitalk-deploy:2022 .
docker push hashicassie/hashitalk-deploy:2022 
```

# AWS EKS

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

Switch to use an existing context
```
kubectl config --kubeconfig ~/.kube/aws-eks-config use-context <context-name>
or
kubectl config  use-context <context-name>
```

Optionally: Rename your context
```
kubectl config rename-context <old-context> aws-context
```

5. Confirm kubectl context
```
kubectl config current-context
```

## Build Image Locally
```
docker build -t hashicassie/hashitalk-deploy:2022 -f Dockerfile . 
```

## Configure Waypoint
```
waypoint runner install -platform=kubernetes -server-addr=<server_addr> -k8s-runner-image=hashicorp/waypoint:latest -id=aws -- -label=cloud=aws
waypoint runner profile set -env-var=DOCKER_PWD='pwd' -name=kubernetes-aws
kubectl config use-context aws-context 
waypoint init
waypoint project apply -data-source="git" -git-url="https://github.com/cicoyle/hashitalk-deploy" -git-ref=main -waypoint-hcl=waypoint.hcl hashitalk-deploy-aws
waypoint up
```

# GCP GKE

## Pre-Requisites:
Note: The follow are specifically the instructions for Mac, the commands may be different for Windows

1. Install the gcloud cli
```
./google-cloud-sdk/install.sh
mv google-cloud-sdk /usr/local/bin   
source ~/.zshrc
gcloud components install gke-gcloud-auth-plugin 
gcloud init
```

2. Create cluster from UI

3. Create or update the kubeconfig file for your newly created cluster
```
gcloud container clusters get-credentials cassie-cluster --region us-east1
cp ~/.kube/config ~/.kube/gcp-config
```
OR:

Switch to use an existing context
```
kubectl config --kubeconfig ~/.kube/gcp-config use-context <context-name>
or
kubectl config  use-context <context-name>
```

Optionally: Rename your context
```
kubectl config rename-context <old-context> gcp-context
```

5. Confirm kubectl context
```
kubectl config current-context
```

## Build Image Locally
```
docker build -t hashicassie/hashitalk-deploy:2022 -f Dockerfile . 
```

## Configure Waypoint
```
waypoint runner install -platform=kubernetes -server-addr=<server_addr> -k8s-runner-image=hashicorp/waypoint:latest -id=gcp -- -label=cloud=gcp
waypoint runner profile set -env-var=DOCKER_PWD='pwd' -name=kubernetes-gcp
kubectl config use-context gcp-context
** Make changes to waypoint.hcl **
waypoint init
waypoint project apply -data-source="git" -git-url="https://github.com/cicoyle/hashitalk-deploy" -git-ref=main -waypoint-hcl=waypoint.hcl hashitalk-deploy-gcp
waypoint up
```

# Azure AKS


## Pre-Requisites:
Note: The follow are specifically the instructions for Mac, the commands may be different for Windows

1. Install the az cli
```
brew update && brew install azure-cli
az login
```

2. Create cluster from UI

3. Create or update the kubeconfig file for your newly created cluster
```
az aks get-credentials --resource-group cassie-rsrc-grp --name cassie-cluster
cp ~/.kube/config ~/.kube/azure-config
```
OR: 
   
Switch to use an existing context
```
kubectl config --kubeconfig ~/.kube/azure-config use-context <context-name>
or
kubectl config  use-context <context-name>
```

Optionally: Rename your context
```
kubectl config rename-context <old-context> azure-context
```

5. Confirm kubectl context
```
kubectl config current-context
```

## Build Image Locally
```
docker build -t hashicassie/hashitalk-deploy:2022 -f Dockerfile .
```

## Configure Waypoint
```
waypoint runner install -platform=kubernetes -server-addr=<server_addr> -k8s-runner-image=hashicorp/waypoint:latest -id=azure -- -label=cloud=azure
waypoint runner profile set -env-var=DOCKER_PWD='pwd' -name=kubernetes-azure
kubectl config use-context azure-context
** Make changes to waypoint.hcl **
waypoint init
waypoint project apply -data-source="git" -git-url="https://github.com/cicoyle/hashitalk-deploy" -git-ref=main -waypoint-hcl=waypoint.hcl hashitalk-deploy-azure
waypoint up
```

### Cleanup Resources
```
eksctl delete cluster --name cassie-cluster --region us-east-1
```
Destroy aks & gke clusters from UI

