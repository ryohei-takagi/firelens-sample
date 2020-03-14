FROM golang:1.14-alpine as builder
ENV ROOT_PATH /go/src/github.com/ryohei-takagi/firelens-sample

WORKDIR $ROOT_PATH

RUN apk add --no-cache alpine-sdk git

RUN addgroup -g 10001 -S admin \
    && adduser -u 10001 -G admin -S admin

COPY go.mod go.sum ./
RUN go mod download

COPY main.go main.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/api $ROOT_PATH/main.go && \
    chmod 755 /go/bin/api && \
    chown admin:admin /go/bin/api

FROM scratch

ENV ROOT_PATH /go/src/github.com/ryohei-takagi/firelens-sample

COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/bin/api /go/bin/api

USER admin

EXPOSE 9000
CMD ["/go/bin/api"]