FROM debian:buster-slim

WORKDIR /root

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
    ; \
    rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/privacybydesign/irmago/releases/download/v0.5.0/irma-master-linux-amd64 -O /usr/local/bin/irma
RUN chmod +x /usr/local/bin/irma

CMD ["irma", "server", "-v"]
