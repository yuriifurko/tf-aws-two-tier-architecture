FROM alpine:3.19

USER root
RUN apk --no-cache add \
    git \
    aws-cli

RUN useradd -ms /bin/bash builder

USER builder
WORKDIR /home/builder
HEALTHCHECK NONE