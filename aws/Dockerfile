#--------------------------------------------------------------------
# builder
#--------------------------------------------------------------------

FROM golang:1.17.2-alpine3.14 AS builder

WORKDIR /app-src

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY . ./

RUN go build -o /tmp/server aws/server.go

#--------------------------------------------------------------------
# final image
#--------------------------------------------------------------------

FROM alpine:3.14

COPY --from=builder /tmp/server /server
EXPOSE 5300
CMD [ "/server" ]