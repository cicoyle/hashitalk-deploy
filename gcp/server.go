package main

import (
	"fmt"
	"github.com/hashitalk-deploy/gcp/hello"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"log"
	"net"
)

func main() {
	fmt.Println("Starting server on port 5300")

	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", 5300))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	helloServer := hello.Server{}
	grpcServer := grpc.NewServer()
	hello.RegisterHelloServiceServer(grpcServer, &helloServer)

	// Add reflection to use grpcurl
	reflection.Register(grpcServer)
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("failed to serve: %s", err)
	}
}
