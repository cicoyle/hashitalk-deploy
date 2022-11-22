# Hashitalks: Deploy 2022

## Use Waypoint To Easily Deploy To GCP GKE

## Repo Setup:
```
go mod init github.com/hashitalk-deploy/gcp
go mod tidy
```

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

## Build Image locally
```
docker build -t hashicassie/hashitalk-deploy:2022 -f gcp/Dockerfile . 
```


## Configure Waypoint
```
cd /gcp
waypoint runner install -platform=kubernetes -server-addr=<server_addr> -k8s-runner-image=hashicorp/waypoint:latest -id=gcp -- -label=cloud=gcp
waypoint runner profile set -env-var=DOCKER_PWD='pwd' -name=kubernetes-gcp
waypoint init
waypoint project apply -data-source="git" -git-url="https://github.com/cicoyle/hashitalk-deploy" -git-ref=main -git-path=gcp -waypoint-hcl=waypoint.hcl hashitalk-deploy-gcp
waypoint up
```