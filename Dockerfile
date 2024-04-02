FROM alpine:3.19

ARG USERNAME=builder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

USER root
RUN apk --no-cache add \
    git \
    aws-cli \
    shadow

RUN groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME
HEALTHCHECK NONE