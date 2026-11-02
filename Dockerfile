# Build natively on the host platform and cross-compile for the target so
# multi-arch builds (e.g. linux/arm64 for Apple Silicon) don't require QEMU.
FROM --platform=$BUILDPLATFORM golang:1.27 AS build
ARG TARGETOS
ARG TARGETARCH
WORKDIR /go/src/app
COPY . .
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} make

FROM scratch
COPY *.html ./
COPY *.png ./
COPY *.js ./
COPY *.ico ./
COPY *.css ./
COPY --from=build /go/src/app/rollouts-demo /rollouts-demo

ARG COLOR
ENV COLOR=${COLOR}
ARG ERROR_RATE
ENV ERROR_RATE=${ERROR_RATE}
ARG LATENCY
ENV LATENCY=${LATENCY}

ENTRYPOINT [ "/rollouts-demo" ]
