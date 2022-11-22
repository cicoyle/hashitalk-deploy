# Hashitalks: Deploy 2022

## Use Waypoint To Easily Deploy To Azure AKS

## Repo Setup:
```
go mod init github.com/hashitalk-deploy/azure
go mod tidy
```

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

## Build Image locally
```
docker build -t hashicassie/hashitalk-deploy:2022 -f azure/Dockerfile . 
```


## Configure Waypoint
```
cd /azure
waypoint runner install -platform=kubernetes -server-addr=<server_addr> -k8s-runner-image=hashicorp/waypoint:latest -id=azure -- -label=cloud=azure
waypoint runner profile set -env-var=DOCKER_PWD='pwd' -name=kubernetes-azure
waypoint init
waypoint project apply -data-source="git" -git-url="https://github.com/cicoyle/hashitalk-deploy" -git-ref=main -git-path=azure -waypoint-hcl=waypoint.hcl hashitalk-deploy-azure
waypoint up
```