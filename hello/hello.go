package hello

import (
	"golang.org/x/net/context"
	"log"
)

type Server struct{}

func (s *Server) SayHello(ctx context.Context, req *MsgRequest) (*MsgResponse, error) {
	log.Printf("Recieved request from client: %s", req.Body)
	return &MsgResponse{Body: "Hello from Server :)"}, nil
}
