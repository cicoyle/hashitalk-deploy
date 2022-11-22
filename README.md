# Hashitalks: Deploy

## Use Waypoint To Easily Deploy To All 3 Cloud Providers
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



### Cleanup Resources
```
eksctl delete cluster --name cassie-cluster --region us-east-1
```
Destroy aks & gke clusters from UI

### Docker Steps
```
docker login -u "hashicassie" -p '<pwd>' docker.io
docker build -t hashicassie/hashitalk-deploy:2022 .
docker push hashicassie/hashitalk-deploy:2022 
```
