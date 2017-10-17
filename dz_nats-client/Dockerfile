###############################
# Builder container
###############################

From golang:1.9 as builder
RUN apt-get update
WORKDIR /go/src/app
COPY main.go .

RUN go get github.com/nats-io/go-nats

# Install dependencies...
RUN go-wrapper download
RUN go-wrapper install

# Compile
RUN CGO_ENABLED=0 GOOS=linux go build -a -o main .


###############################
# Exec container
###############################

From alpine:latest
COPY --from=builder /go/src/app/main /main
CMD ["/main"]