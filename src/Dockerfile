#checkov:skip=CKV2_DOCKER_1:Ensure that sudo isn't used

FROM ubuntu:22.04

#
# DOCKER BUILDKIT
#

ARG BUILDARCH
ARG BUILDOS
ARG BUILDPLATFORM
ARG TARGETARCH
ARG TARGETOS
ARG TARGETPLATFORM

#
# PROJECT
#

ARG PROJECT_BUILD_DATE
ARG PROJECT_COMMIT
ARG PROJECT_VERSION

#
# IMAGE
#

ARG DEFAULT_LANG="C.UTF-8"
ARG DEFAULT_USER_PRIMARY_GROUP="developers"
ARG DEFAULT_USER_SECONDARY_GROUPS="sudo,docker"
ARG DEFAULT_USER_SHELL="/bin/bash"
ARG DEFAULT_USER="dev"

#
# LABELS
#

#
# REFERENCE
#
#   - https://github.com/opencontainers/image-spec/blob/main/annotations.md
#

LABEL org.opencontainers.image.authors="Egon Braun <ebraun@schubergphilis.com>"
LABEL org.opencontainers.image.created="${PROJECT_BUILD_DATE}"
LABEL org.opencontainers.image.description="Container image to be used as a remote development environment in Visual Studio Code"
LABEL org.opencontainers.image.licenses="ApacheV2"
LABEL org.opencontainers.image.revision="${PROJECT_COMMIT}"
LABEL org.opencontainers.image.source="https://github.com/schubergphilis/devcontainer"
LABEL org.opencontainers.image.title="devcontainer"
LABEL org.opencontainers.image.url="ghcr.io/schubergphilis/devcontainer:latest"
LABEL org.opencontainers.image.vendor="Schuberg Philis"
LABEL org.opencontainers.image.version="${PROJECT_VERSION}"

#
# OS
#

ENV VERSION_UBUNTU="22.04"
ENV VERSION_UBUNTU_NAME="jammy"

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        direnv \
        gcc-aarch64-linux-gnu \
        git \
        git-extras \
        gnupg2 \
        gpg-agent \
        jq \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxmlsec1-dev \
        locales \
        lsb-release \
        make \
        pipx \
        pkg-config \
        python3 \
        python3-full \
        software-properties-common \
        ssh \
        sudo \
        tk-dev \
        unzip \
        vim \
        xz-utils \
        zip \
        zlib1g-dev \
    && apt-get autoremove -y \
    && apt-get clean autoclean -y \
    && rm -r /var/cache/* /var/lib/apt/lists/*

RUN locale-gen "${DEFAULT_LANG}" \
    && update-locale LANG="${DEFAULT_LANG}"

#
# INSTALL DOCKER
#

ENV VERSION_DOCKER_CLI="25.0.0-1"
ENV VERSION_DOCKER_BUILDX_PLUGIN="0.12.1-1"
ENV VERSION_DOCKER_COMPOSE_PLUGIN="2.24.1-1"
ENV FILENAME_DOCKER_SUFFIX="ubuntu.${VERSION_UBUNTU}~${VERSION_UBUNTU_NAME}_${TARGETARCH}.deb"
ENV FILENAME_DOCKER_CLI="docker-ce-cli_${VERSION_DOCKER_CLI}~${FILENAME_DOCKER_SUFFIX}"
ENV FILENAME_DOCKER_BUILDX_PLUGIN="docker-buildx-plugin_${VERSION_DOCKER_BUILDX_PLUGIN}~${FILENAME_DOCKER_SUFFIX}"
ENV FILENAME_DOCKER_COMPOSE_PLUGIN="docker-compose-plugin_${VERSION_DOCKER_COMPOSE_PLUGIN}~${FILENAME_DOCKER_SUFFIX}"
ENV URL_DOCKER_BASE="https://download.docker.com/linux/ubuntu/dists/${VERSION_UBUNTU_NAME}/pool/stable/${TARGETARCH}"
ENV URL_DOCKER_CLI="${URL_DOCKER_BASE}/${FILENAME_DOCKER_CLI}"
ENV URL_DOCKER_BUILDX_PLUGIN="${URL_DOCKER_BASE}/${FILENAME_DOCKER_BUILDX_PLUGIN}"
ENV URL_DOCKER_COMPOSE_PLUGIN="${URL_DOCKER_BASE}/${FILENAME_DOCKER_COMPOSE_PLUGIN}"

RUN curl -sSL -o "/tmp/${FILENAME_DOCKER_CLI}" "${URL_DOCKER_CLI}" \
    && curl -sSL -o "/tmp/${FILENAME_DOCKER_BUILDX_PLUGIN}" "${URL_DOCKER_BUILDX_PLUGIN}" \
    && curl -sSL -o "/tmp/${FILENAME_DOCKER_COMPOSE_PLUGIN}" "${URL_DOCKER_COMPOSE_PLUGIN}" \
    && dpkg -i "/tmp/${FILENAME_DOCKER_CLI}" \
    && dpkg -i "/tmp/${FILENAME_DOCKER_BUILDX_PLUGIN}" \
    && dpkg -i "/tmp/${FILENAME_DOCKER_COMPOSE_PLUGIN}" \
    && groupadd docker \
    && rm -f "/tmp/"*"${FILENAME_DOCKER_SUFFIX}"

#
# INSTALL HADOLINT
#

ENV VERSION_HADOLINT="2.12.0"
ENV URL_HADOLINT="https://github.com/hadolint/hadolint/releases/download/v${VERSION_HADOLINT}/hadolint-Linux-${TARGETARCH}"

RUN curl -sSL -o /usr/local/bin/hadolint "${URL_HADOLINT}" \
    && chmod +x /usr/local/bin/hadolint

#
# INSTALL GIT DELTA
#

ENV VERSION_GIT_DELTA="0.16.5"
ENV FILENAME_GIT_DELTA="git-delta_${VERSION_GIT_DELTA}_${TARGETARCH}.deb"
ENV URL_GIT_DELTA_BASE="https://github.com/dandavison/delta/releases/download/${VERSION_GIT_DELTA}"
ENV URL_GIT_DELTA="${URL_GIT_DELTA_BASE}/${FILENAME_GIT_DELTA}"

RUN curl -sSL --http1.1 -o "/tmp/${FILENAME_GIT_DELTA}" "${URL_GIT_DELTA}" \
    && dpkg -i "/tmp/${FILENAME_GIT_DELTA}" \
    && rm -f "/tmp/${FILENAME_GIT_DELTA}"

#
# INSTALL STARSHIP
#

RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

#
# INSTALL AWSCLI
#

RUN if [ "${TARGETARCH}" == "arm64" ]; then arch="aarch64"; elif [ "${TARGETARCH}" == "amd64" ]; then arch="x86_64"; else arch="${TARGETARCH}"; fi \
    && curl -vfsSL "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o "/tmp/awscliv2.zip" \
    && unzip "/tmp/awscliv2.zip" \
    && ./aws/install \
    && rm -rf "./aws" \
    && rm -f "/tmp/awscliv2.zip"

#
# CREATE DEV USER
#

RUN groupadd "${DEFAULT_USER_PRIMARY_GROUP}" \
    && useradd \
    -s "${DEFAULT_USER_SHELL}" \
    -g "${DEFAULT_USER_PRIMARY_GROUP}" \
    -G "${DEFAULT_USER_SECONDARY_GROUPS}" \
    -m "${DEFAULT_USER}"

#
# CONFIGURE SUDO
#

RUN echo \
    # CONTENT \
    "%${DEFAULT_USER_PRIMARY_GROUP} ALL=(ALL) NOPASSWD: ALL" \
    # END \
    >"/etc/sudoers.d/${DEFAULT_USER_PRIMARY_GROUP}"

USER "${DEFAULT_USER}"

ENV HOME="/home/${DEFAULT_USER}"
ENV LANG="${DEFAULT_LANG}"
ENV LANGUAGE="${DEFAULT_LANG}"
ENV LC_ALL="${DEFAULT_LANG}"
ENV PATH="${HOME}/.local/bin:${PATH}"
ENV PROMPT_COMMAND="history -a"
ENV HISTFILE="${HOME}/.history/.bash_history"

#
# GENERAL
#

RUN mkdir -p "${HOME}/.config" \
    && mkdir "${HOME}/.history" \
    && touch "${HOME}/.history/.bash_history" \
    && mkdir -p "${HOME}/.local/bin"

#
# INSTALL TFENV
#

ENV TFENV_VERSION="3.0.0"
ENV TFENV_ROOT="${HOME}/.tfenv"
ENV PATH="${TFENV_ROOT}/bin:${PATH}"

RUN git clone --depth=1 --branch "v${TFENV_VERSION}" "https://github.com/tfutils/tfenv.git" "${TFENV_ROOT}"

#
# INSTALL PYENV
#

ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/bin:$PATH"

RUN curl -fsSL https://pyenv.run | bash

#
# OTHER TOOLS
#

ENV VERSION_CHECKOV="3.2.16"
ENV VERSION_POETRY="1.7.1"
ENV VERSION_PRECOMMIT="3.6.0"

#
# PYTHON
#

RUN pipx install "checkov==${VERSION_CHECKOV}" \
    && pipx install "poetry==${VERSION_POETRY}" \
    && pipx install "pre-commit==${VERSION_PRECOMMIT}"

#
# CONFIGURE SHELL
#

RUN echo "eval \"\$(direnv hook bash)\"" >> "${HOME}/.bashrc" \
    && echo "eval \"\$(starship init bash)\"" >> "${HOME}/.bashrc" \
    && echo "eval \"\$(pyenv init --path)\"" >> "${HOME}/.bashrc" \
    && echo "eval \"\$(pyenv virtualenv-init -)\"" >> "${HOME}/.bashrc"

#
# RUN
#

HEALTHCHECK NONE

ENTRYPOINT [ ]

CMD [ ]
