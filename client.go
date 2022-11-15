package main

import (
	"context"
	"fmt"
	"github.com/hashitalk-deploy/hello"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"log"
)

func main() {
	var conn *grpc.ClientConn
	creds := insecure.NewCredentials()
	conn, err := grpc.Dial(fmt.Sprintf(":%d", 9000), grpc.WithTransportCredentials(creds))
	if err != nil {
		log.Fatalf("did not connect: %s", err)
	}
	defer conn.Close()

	helloClient := hello.NewHelloServiceClient(conn)

	resp, err := helloClient.SayHello(context.Background(), &hello.MsgRequest{Body: "Hello from Client :)"})
	if err != nil {
		log.Fatalf("err when calling SayHello method: %s", err)
	}
	log.Printf("Response from server: %s", resp.Body)
}
