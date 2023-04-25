FROM golang:1.20-alpine AS build
ENV CGO_ENABLED=0
RUN mkdir /src
WORKDIR /src
COPY *.go go.mod go.sum /src/
RUN apk add git
RUN go build .

FROM gcr.io/distroless/static-debian11:nonroot
COPY --from=build --chown=nonroot:nonroot /src/exporter_exporter /home/nonroot/exporter_exporter
COPY --chown=nonroot:nonroot k8s.yml /home/nonroot/expexp.yaml
USER nonroot
WORKDIR /home/nonroot
ENTRYPOINT ["/home/nonroot/exporter_exporter"]
