FROM alpine:latest AS scheme

RUN apk add git

RUN git clone https://github.com/privacybydesign/pbdf-schememanager.git /pbdf-schememanager && \
	cd /pbdf-schememanager && \
	git checkout e92268845aa4c3b45397082b5b58cd4c5ff50cc5


FROM alpine:latest

WORKDIR /root

COPY --from=scheme /pbdf-schememanager /root/irma-assets/pbdf

# TODO: update irma server version
RUN wget https://github.com/privacybydesign/irmago/releases/download/v0.5.0/irma-master-linux-amd64 -O /usr/local/bin/irma
RUN chmod +x /usr/local/bin/irma

CMD ["/usr/local/bin/irma"]
