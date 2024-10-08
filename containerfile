FROM docker.io/library/golang:1.23 AS builder

ARG TARGETOS
ARG TARGETARCH

COPY main.go .

RUN echo "${TARGETOS} ${TARGETARCH}"
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /bin/opm main.go
RUN ls -la

FROM alpine:latest
 
COPY --from=builder /bin/opm /bin/opm
COPY ./configs /configs

CMD ["/bin/opm" ,"serve","/configs","--cache-only","--cache-dir=/tmp/cache"]
