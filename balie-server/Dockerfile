FROM gradle:8.3.0 as java-build

WORKDIR /source

COPY mrtd-unpack ./

RUN gradle installDist

FROM golang:1.21-bullseye AS build

WORKDIR /build

COPY go.mod go.sum ./
COPY common ./common
COPY balie-server ./balie-server

ENV CGO_ENABLED=0

RUN go build -o /build/server ./balie-server

FROM openjdk:11-jre-slim AS release

WORKDIR /dist

# Install libopenjp2-tools for opj_decompress
RUN apt-get update && \
    apt-get install -y libopenjp2-tools && \
    rm -rf /var/lib/apt/lists/*

ENV BALIE_SERVER_MRTDUNPACK=/dist/mrtdunpack/bin/mrtdunpack

COPY --from=java-build /source/build/install/mrtdunpack ./mrtdunpack
COPY --from=build /build/server ./balie-server

CMD ["/dist/balie-server"]
