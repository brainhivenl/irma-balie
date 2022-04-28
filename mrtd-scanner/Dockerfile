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

COPY mrtd-scanner /go/src/app/mrtd-scanner
WORKDIR /go/src/app/mrtd-scanner
RUN gradle installDist


FROM openjdk:11-jre-slim AS release

COPY --from=build /go/src/app/mrtd-scanner/build/install/mrtdscanner /opt/mrtdscanner

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        pcsc-tools \
    ; \
    rm -rf /var/lib/apt/lists/*;

CMD ["/opt/mrtdscanner/bin/mrtdscanner"]
