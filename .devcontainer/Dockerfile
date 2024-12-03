
FROM elixir:1.17.3-otp-25

LABEL org.opencontainers.image.description="Elixir devcontainer for VSCode or Codespaces"

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install --no-install-recommends tree inotify-tools \
    && apt-get -y install --no-install-recommends git iproute2 procps iproute2 lsb-release ca-certificates \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

USER vscode
ENV HOME /home/vscode