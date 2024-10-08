#!/bin/bash

podman build --build-arg TARGETOS=linux --build-arg TARGETARCH=arm64 --platform linux/arm64 -t localhost:5000/test/opm-service:linux-arm64 -f containerfile
podman build --build-arg TARGETOS=linux --build-arg TARGETARCH=amd64 --platform linux/amd64 -t localhost:5000/test/opm-service:linux-amd64 -f containerfile

podman push localhost:5000/test/opm-service:linux-arm64 --tls-verify=false
podman push localhost:5000/test/opm-service:linux-amd64 --tls-verify=false

podman manifest create localhost:5000/test/opm-service:v1.0.0 localhost:5000/test/opm-service:linux-arm64 localhost:5000/test/opm-service:linux-amd64 

podman push manifest localhost:5000/test/opm-service:v1.0.0 --tls-verify=false

# finally test it out
podman build -t localhost:5000/container-test:v1.0.0 -f rebuild-catalog.containerfile 

: <<'END'
[1/2] STEP 1/7: FROM localhost:5000/test/opm-service:v1.0.0 AS builder
WARNING: image platform (linux/arm64/v8) does not match the expected platform (linux/amd64)
[1/2] STEP 2/7: USER 0
--> fea8375c8888
[1/2] STEP 3/7: RUN rm -fr /configs
--> a8bfd03c9f53
[1/2] STEP 4/7: COPY ./configs /configs
--> 69e9a2766df7
[1/2] STEP 5/7: USER 1001
--> 83f37a0b1aae
[1/2] STEP 6/7: RUN rm -fr /tmp/cache/*
--> 05d2a9bc0e14
[1/2] STEP 7/7: RUN /bin/opm serve /configs --cache-only --cache-dir=/tmp/cache
opm simulator
--> ce15b4414837
[2/2] STEP 1/7: FROM localhost:5000/test/opm-service:v1.0.0
WARNING: image platform (linux/arm64/v8) does not match the expected platform (linux/amd64)
[2/2] STEP 2/7: USER 0
--> Using cache fea8375c88885ee8b968bdae8b6095bd15382cb78ceb3eca992ae646ab884f33
--> fea8375c8888
[2/2] STEP 3/7: RUN rm -fr /configs
--> Using cache a8bfd03c9f5323e6f9c513346a265075359360751d79997bbc32174728e76702
--> a8bfd03c9f53
[2/2] STEP 4/7: COPY ./configs /configs
--> Using cache 69e9a2766df73a7cdf5eb204fa01633a29c1245c8c21f46c598daa127b2a2c14
--> 69e9a2766df7
[2/2] STEP 5/7: USER 1001
--> Using cache 83f37a0b1aae6aab1d6c931bceba29ca4d03a29ef33aee0d5ee540d86b3ef2e6
--> 83f37a0b1aae
[2/2] STEP 6/7: RUN rm -fr /tmp/cache/*
--> Using cache 05d2a9bc0e14cf1ece51939664b9bf7118fc13d5213abf2da4727c67b6026e0b
--> 05d2a9bc0e14
[2/2] STEP 7/7: COPY --from=builder /tmp/cache /tmp/cache
[2/2] COMMIT localhost:5000/kaka:v1.0.0
--> 24da1614b419
Successfully tagged localhost:5000/kaka:v1.0.0
24da1614b41991211ae2a1dd2fa18956396ccf2dbab0806a1179df7f0d2457e6]
END
