FROM golang:1.13.5 as builder
WORKDIR /github.com/mayadata-io/mysqld_exporter
COPY . .
RUN make

ARG ARCH="amd64"
ARG OS="linux"
FROM   quay.io/prometheus/busybox:latest

ARG ARCH="amd64"
ARG OS="linux"
COPY --from=builder /github.com/mayadata-io/mysqld_exporter/mysqld_exporter /bin/mysqld_exporter

USER        nobody
EXPOSE      9104
ENTRYPOINT  [ "/bin/mysqld_exporter" ]
