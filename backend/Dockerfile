FROM golang:latest as builder
RUN mkdir /build
ADD . /build
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

FROM busybox
RUN mkdir /app
COPY --from=builder /build/main /app
WORKDIR /app
CMD ["/app/main"]
