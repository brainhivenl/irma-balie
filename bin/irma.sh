export IRMA_URL=https://31e1e4241871.ngrok.io

irma \
server \
--verbose \
--schemes-path=.docker-irma-configuration \
--schemes-assets-path=irma-config \
--schemes-update=0 \
--port=8088 \
--client-port=8089 \
--config=irma-config/config.json \
--jwt-privkey-file=irma-config/jwt_privkey.dev.pem \
--url=${IRMA_URL} \
--no-email \
--no-tls \
--no-auth
