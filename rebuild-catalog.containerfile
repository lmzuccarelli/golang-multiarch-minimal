FROM localhost:5000/test/opm-service:v1.0.0 AS builder
USER 0
RUN rm -fr /configs
COPY ./configs /configs
USER 1001
RUN rm -fr /tmp/cache/*
RUN /bin/opm serve /configs --cache-only --cache-dir=/tmp/cache

FROM  localhost:5000/test/opm-service:v1.0.0
USER 0
RUN rm -fr /configs
COPY ./configs /configs
USER 1001
RUN rm -fr /tmp/cache/*
COPY --from=builder /tmp/cache /tmp/cache

