FROM alpine:latest

USER root
RUN apk --no-cache add \
    git \
    aws-cli