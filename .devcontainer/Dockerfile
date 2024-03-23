# hadolint ignore=DL3006
FROM mcr.microsoft.com/devcontainers/base

ENV HADOLINT="2.12.0"


RUN apt-get update && \
    apt-get -y install curl --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# dprint
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://dprint.dev/install.sh | sh && \
    mv ~/.dprint/bin/dprint /usr/local/bin/

# hadolint
RUN curl -L https://github.com/hadolint/hadolint/releases/download/v$HADOLINT/hadolint-Linux-x86_64 -o hadolint && \
    chmod +x hadolint && \
    mv hadolint /usr/local/bin/

# taskfile
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
