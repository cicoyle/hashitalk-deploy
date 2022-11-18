package main

import (
	"fmt"
	"github.com/hashitalk-deploy/hello"
	"google.golang.org/grpc"
	"log"
	"net"
)

func main() {
	fmt.Println("Starting server on port 8080")

	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", 8080))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	helloServer := hello.Server{}
	grpcServer := grpc.NewServer()
	hello.RegisterHelloServiceServer(grpcServer, &helloServer)
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("failed to serve: %s", err)
	}
}
