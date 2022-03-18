FROM golang:latest AS build

WORKDIR /root

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        unzip \
        openjdk-11-jdk \
        libopenjp2-tools \
    ; \
    rm -rf /var/lib/apt/lists/*;

ADD https://services.gradle.org/distributions/gradle-6.6.1-bin.zip /root/gradle.zip
RUN mkdir /opt/gradle; \
    unzip -d /opt/gradle /root/gradle.zip

ENV HOME=/root \
    GRADLE_HOME=/root/.gradle \
    PATH="/opt/gradle/gradle-6.6.1/bin:${PATH}"

COPY mrtd-unpack /go/src/app/mrtd-unpack
WORKDIR /go/src/app/mrtd-unpack
RUN gradle installDist

COPY go.mod go.sum /go/src/app/
COPY common /go/src/app/common
COPY balie-server /go/src/app/balie-server
WORKDIR /go/src/app/balie-server
RUN go build .


FROM openjdk:11-jre-slim AS release

COPY --from=build /go/src/app/mrtd-unpack/build/install/mrtdunpack /opt/mrtdunpack
ENV BALIE_SERVER_MRTDUNPACK=/opt/mrtdunpack/bin/mrtdunpack

COPY --from=build /go/src/app/balie-server/balie-server /root/balie-server

WORKDIR /root
CMD ["./balie-server"]
