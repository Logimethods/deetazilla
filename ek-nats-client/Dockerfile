FROM golang:1.9 as gobuild
COPY main.go .
RUN go get github.com/nats-io/go-nats \
    && env GOOS=linux GOARCH=amd64 go build main.go

FROM logimethods/eureka:entrypoint
#FROM entrypoint_exp

COPY entrypoint_insert.sh /entrypoint_insert.sh

COPY --from=gobuild /go/main /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/main"]
