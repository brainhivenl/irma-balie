FROM golang:latest
RUN go get -u github.com/canthefason/go-watcher/cmd/watcher
ENTRYPOINT []
CMD ["watcher"]
