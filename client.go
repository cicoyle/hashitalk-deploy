package main

import (
	"context"
	"github.com/hashitalk-deploy/hello"
	"google.golang.org/grpc"
	"log"
)

func main() {
	opts := []grpc.DialOption{
		grpc.WithInsecure(),
	}
	conn, err := grpc.Dial("127.0.0.1:5300", opts...)

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
