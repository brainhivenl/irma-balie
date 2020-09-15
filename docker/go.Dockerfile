FROM golang:latest

ENTRYPOINT []

WORKDIR /root

RUN go get -u github.com/canthefason/go-watcher/cmd/watcher

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

CMD ["watcher"]
