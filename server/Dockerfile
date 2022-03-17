FROM golang:latest AS build

ENTRYPOINT []

WORKDIR /root

#RUN go get -u github.com/canthefason/go-watcher/cmd/watcher

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

COPY . /go/src/app
WORKDIR /go/src/app/server
RUN go build .

WORKDIR /go/src/app/mrtd-unpack
RUN ./run.dev.sh version
RUN gradle installDist


# FROM golang:latest
FROM openjdk:11-jre-slim

ENV BALIE_SERVER_DEBUGMODE="true"
ENV BALIE_SERVER_IRMASERVER=http://irma:8088
ENV BALIE_SERVER_JWTSECRET=foo
ENV BALIE_SERVER_MRTDUNPACK=mrtdunpack
ENV BALIE_SERVER_PASSPORTCREDENTIALID="tweedegolf-demo.amsterdam.passport"
ENV BALIE_SERVER_IDCARDCREDENTIALID="tweedegolf-demo.amsterdam.idcard"

COPY --from=build /go/src/app/server/server /root/server
COPY --from=build /go/src/app/mrtd-unpack/build/install/mrtdunpack/bin /usr/local/bin
COPY --from=build /go/src/app/mrtd-unpack/build/install/mrtdunpack/lib /usr/local/lib

WORKDIR /root
CMD ["./server"]