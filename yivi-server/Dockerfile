FROM alpine:latest AS scheme

RUN apk add git

RUN git clone https://github.com/privacybydesign/pbdf-schememanager.git /pbdf-schememanager && \
	cd /pbdf-schememanager && \
	git checkout 8cfecb5dfc7bfe6a7a639526faba2b57a5e438f4


FROM golang:1.20-bullseye as build

RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

ENV IRMA_VERSION=0.12.2
ENV CGO_ENABLED=0

RUN curl -LO https://github.com/privacybydesign/irmago/archive/refs/tags/v${IRMA_VERSION}.zip && \
	unzip v${IRMA_VERSION}.zip && \
	cd irmago-${IRMA_VERSION} && \
	go build -ldflags '-extldflags "-static"' -o /build/irma ./irma && \
	cd .. && \
	rm -fr irmago-${IRMA_VERSION} v${IRMA_VERSION}.zip

FROM gcr.io/distroless/base

WORKDIR /dist

COPY --from=scheme /pbdf-schememanager /dist/irma-assets/pbdf
COPY --from=build /build/irma ./irma

CMD ["/dist/irma"]
