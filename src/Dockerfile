# ##############################################################################
# PRELUDE
# ##############################################################################

#
# CHECKOV
#

# This is a container intended to be used as a remote development environment,
# we want to allow the user the ability to become root
#checkov:skip=CKV2_DOCKER_1:Ensure that sudo isn't used

# ------------------------------------------------------------------------------
# BASE IMAGE
# ------------------------------------------------------------------------------

FROM ubuntu:24.04@sha256:84e77dee7d1bc93fb029a45e3c6cb9d8aa4831ccfcc7103d36e876938d28895b

# ------------------------------------------------------------------------------
# ARGUMENTS
# ------------------------------------------------------------------------------

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
ARG DEFAULT_USER_SECONDARY_GROUPS="sudo"
ARG DEFAULT_USER_SHELL="/bin/bash"
ARG DEFAULT_USER="dev"

# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# ------------------------------------------------------------------------------

#
# OS
#

ENV VERSION_UBUNTU="24.04"
ENV VERSION_UBUNTU_NAME="noble"

# ------------------------------------------------------------------------------
# LABELS
# ------------------------------------------------------------------------------

#
# REFERENCE
#
#   - https://github.com/opencontainers/image-spec/blob/main/annotations.md
#

LABEL org.opencontainers.artifact.created="${PROJECT_BUILD_DATE}"
LABEL org.opencontainers.artifact.description="Container image to be used as a remote development environment in Visual Studio Code"
LABEL org.opencontainers.image.authors="Egon Braun <ebraun@schubergphilis.com>"
LABEL org.opencontainers.image.base.name="docker.io/library/ubuntu:${VERSION_UBUNTU}"
LABEL org.opencontainers.image.created="${PROJECT_BUILD_DATE}"
LABEL org.opencontainers.image.description="Container image to be used as a remote development environment in Visual Studio Code"
LABEL org.opencontainers.image.documentation="https://github.com/schubergphilis/devcontainer/README.md"
LABEL org.opencontainers.image.licenses="ApacheV2"
LABEL org.opencontainers.image.revision="${PROJECT_COMMIT}"
LABEL org.opencontainers.image.source="https://github.com/schubergphilis/devcontainer"
LABEL org.opencontainers.image.title="devcontainer"
LABEL org.opencontainers.image.url="docker://ghcr.io/schubergphilis/devcontainer"
LABEL org.opencontainers.image.vendor="Schuberg Philis"
LABEL org.opencontainers.image.version="${PROJECT_VERSION}"

# ######################################################################################################################
# SETUP: BASE
# ######################################################################################################################

SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

WORKDIR /

RUN case "${TARGETARCH}" in \
        amd64|arm64) ;; \
        *) echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac

# ----------------------------------------------------------------------------------------------------------------------
# INSTALL SYSTEM PACKAGES
# ----------------------------------------------------------------------------------------------------------------------

RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates curl \
    && mkdir -p /etc/apt/keyrings \
    && curl -sOL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& mv githubcli-archive-keyring.gpg /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& mkdir -p /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
    autoconf \
    build-essential \
    direnv \
    gdb \
    gh \
    git \
    git-extras \
    gnupg2 \
    gpg-agent \
    jq \
    libbz2-dev \
    libdb-dev \
    libffi-dev \
    libgdbm-dev \
    libgdbm6 \
    libgmp-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libyaml-dev  \
    locales \
    lsb-release \
    lsd \
    make \
    patch \
    pipx \
    pkg-config \
    python3 \
    python3-full \
    rustc \
    software-properties-common \
    ssh \
    sudo \
    tk-dev \
    tzdata \
    unzip \
    vim \
    wget \
    xz-utils \
    zlib1g-dev \
    && apt-get autoremove -y \
    && apt-get clean autoclean -y \
    && rm -r /var/cache/* /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# INSTALL COSIGN
# ------------------------------------------------------------------------------

#
# INSTALL
#

COPY --from=ghcr.io/sigstore/cosign/cosign:v3.0.6@sha256:de9c65609e6bde17e6b48de485ee788407c9502fa08b8f4459f595b21f56cd00 /ko-app/cosign /usr/local/bin/cosign

# ------------------------------------------------------------------------------
# INSTAL UV
# ------------------------------------------------------------------------------

#
# INSTALL
#

COPY --from=ghcr.io/astral-sh/uv:0.11.7@sha256:240fb85ab0f263ef12f492d8476aa3a2e4e1e333f7d67fbdd923d00a506a516a /uv /uvx /usr/local/bin/

# ------------------------------------------------------------------------------
# CONFIGURE LOCALISATION
# ------------------------------------------------------------------------------

RUN locale-gen "${DEFAULT_LANG}" \
    && update-locale LANG="${DEFAULT_LANG}"

# ##############################################################################
# SETUP: CUSTOM (AS ROOT)
# ##############################################################################

#
# Empty
#

# ------------------------------------------------------------------------------
# INSTALL HADOLINT
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_HADOLINT="2.14.0"

#
# INSTALL
#

RUN case "${TARGETARCH}" in \
        amd64) cpuarch="x86_64" ;; \
        *) cpuarch="${TARGETARCH}" ;; \
    esac \
    && curl -sOL "https://github.com/hadolint/hadolint/releases/download/v${VERSION_HADOLINT}/hadolint-linux-${cpuarch}" \
    && curl -sOL "https://github.com/hadolint/hadolint/releases/download/v${VERSION_HADOLINT}/hadolint-linux-${cpuarch}.sha256" \
    && sha256sum -c "hadolint-linux-${cpuarch}.sha256" \
    && mv "hadolint-linux-${cpuarch}" /usr/local/bin/hadolint \
    && chmod +x /usr/local/bin/hadolint \
    && rm -f /tmp/hadolint-*

# ------------------------------------------------------------------------------
# INSTALL TENV
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_TENV="4.10.1"
ENV URL_TENV="https://github.com/tofuutils/tenv/releases/download/v${VERSION_TENV}/tenv_v${VERSION_TENV}_${TARGETARCH}.deb"
ENV URL_TENV_PEM="https://github.com/tofuutils/tenv/releases/download/v${VERSION_TENV}/tenv_v${VERSION_TENV}_${TARGETARCH}.deb.pem"
ENV URL_TENV_SIG="https://github.com/tofuutils/tenv/releases/download/v${VERSION_TENV}/tenv_v${VERSION_TENV}_${TARGETARCH}.deb.sig"
ENV URL_TENV_CHECKSUMS="https://github.com/tofuutils/tenv/releases/download/v${VERSION_TENV}/tenv_v${VERSION_TENV}_checksums.txt"
ENV URL_TENV_CHECKSUMS_SIG="https://github.com/tofuutils/tenv/releases/download/v${VERSION_TENV}/tenv_v${VERSION_TENV}_checksums.txt.sig"
ENV URL_TENV_CHECKSUMS_PEM="https://github.com/tofuutils/tenv/releases/download/v${VERSION_TENV}/tenv_v${VERSION_TENV}_checksums.txt.pem"

#
# INSTALL
#

RUN curl -sOL "${URL_TENV_CHECKSUMS}" \
    && curl -sOL "${URL_TENV_CHECKSUMS_SIG}" \
    && curl -sOL "${URL_TENV_CHECKSUMS_PEM}" \
    && curl -sOL "${URL_TENV}" \
    && curl -sOL "${URL_TENV_PEM}" \
    && curl -sOL "${URL_TENV_SIG}" \
    && cosign verify-blob \
        --certificate-identity "https://github.com/tofuutils/tenv/.github/workflows/release.yml@refs/tags/v${VERSION_TENV}" \
        --signature "tenv_v${VERSION_TENV}_checksums.txt.sig" \
        --certificate "tenv_v${VERSION_TENV}_checksums.txt.pem" \
        --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
        "tenv_v${VERSION_TENV}_checksums.txt" \
    && cosign verify-blob \
        --certificate-identity "https://github.com/tofuutils/tenv/.github/workflows/release.yml@refs/tags/v${VERSION_TENV}" \
        --signature "tenv_v${VERSION_TENV}_${TARGETARCH}.deb.sig" \
        --certificate "tenv_v${VERSION_TENV}_${TARGETARCH}.deb.pem" \
        --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
        "tenv_v${VERSION_TENV}_${TARGETARCH}.deb" \
    && sha256sum -c "tenv_v${VERSION_TENV}_checksums.txt" --ignore-missing \
    && dpkg -i "tenv_v${VERSION_TENV}_${TARGETARCH}.deb" \
    && rm -f tenv_*

# ------------------------------------------------------------------------------
# INSTALL TERRAFORM-DOCS
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_TERRAFORM_DOCS="0.22.0"
ENV URL_TERRAFORM_DOCS="https://github.com/terraform-docs/terraform-docs/releases/download/v${VERSION_TERRAFORM_DOCS}/terraform-docs-v${VERSION_TERRAFORM_DOCS}-linux-${TARGETARCH}.tar.gz"
ENV URL_TERRAFORM_DOCS_SHA256="https://github.com/terraform-docs/terraform-docs/releases/download/v${VERSION_TERRAFORM_DOCS}/terraform-docs-v${VERSION_TERRAFORM_DOCS}.sha256sum"

#
# INSTALL
#

RUN curl -sOL "${URL_TERRAFORM_DOCS_SHA256}" \
    && curl -sOL "${URL_TERRAFORM_DOCS}" \
    && sha256sum -c "terraform-docs-v${VERSION_TERRAFORM_DOCS}.sha256sum" --ignore-missing \
    && tar -xf "terraform-docs-v${VERSION_TERRAFORM_DOCS}-linux-${TARGETARCH}.tar.gz" \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/ \
    && rm -f terraform-docs-*


# ------------------------------------------------------------------------------
# INSTALL TFLINT
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_TFLINT="0.61.0"
ENV URL_TFLINT="https://github.com/terraform-linters/tflint/releases/download/v${VERSION_TFLINT}/tflint_linux_${TARGETARCH}.zip"
ENV URL_TFLINT_CHECKSUMS="https://github.com/terraform-linters/tflint/releases/download/v${VERSION_TFLINT}/checksums.txt"

#
# INSTALL
#


RUN curl -sOL "${URL_TFLINT}" \
    && curl -sOL "${URL_TFLINT_CHECKSUMS}" \
    && sha256sum -c checksums.txt --ignore-missing \
    && unzip "./tflint_linux_${TARGETARCH}.zip" \
    && chmod +x tflint \
    && mv tflint /usr/local/bin \
    && rm -f ./tflint* checksums.txt

# ------------------------------------------------------------------------------
# CREATE DEV USER
# ------------------------------------------------------------------------------

RUN groupadd "${DEFAULT_USER_PRIMARY_GROUP}" \
    && useradd \
    -s "${DEFAULT_USER_SHELL}" \
    -g "${DEFAULT_USER_PRIMARY_GROUP}" \
    -G "${DEFAULT_USER_SECONDARY_GROUPS}" \
    -m "${DEFAULT_USER}"

# ------------------------------------------------------------------------------
# CONFIGURE SUDO
# ------------------------------------------------------------------------------

RUN echo \
    # CONTENT \
    "%${DEFAULT_USER_PRIMARY_GROUP} ALL=(ALL) NOPASSWD: ALL" \
    # END \
    >"/etc/sudoers.d/${DEFAULT_USER_PRIMARY_GROUP}"

# ------------------------------------------------------------------------------
# INSTALL TASK
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_TASK=3.50.0
ENV URL_TASK="https://github.com/go-task/task/releases/download/v${VERSION_TASK}/task_linux_${TARGETARCH}.tar.gz"
ENV URL_TASK_CHECKSUMS="https://github.com/go-task/task/releases/download/v${VERSION_TASK}/task_checksums.txt"

#
# INSTALL
#

RUN curl -sOL "${URL_TASK}" \
    && curl -sOL "${URL_TASK_CHECKSUMS}" \
    && sha256sum -c task_checksums.txt --ignore-missing \
    && tar zxf task_linux_${TARGETARCH}.tar.gz task \
    && mv task /usr/local/bin/task \
    && chmod +x /usr/local/bin/task \
    && rm -f task_*

# ------------------------------------------------------------------------------
# INSTALL GOENV
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_GOENV="3.0.1"
ENV URL_GOENV="https://github.com/go-nv/goenv/releases/download/${VERSION_GOENV}/goenv_${VERSION_GOENV}_linux_${TARGETARCH}.tar.gz"
ENV URL_GOENV_CHECKSUMS="https://github.com/go-nv/goenv/releases/download/${VERSION_GOENV}/goenv_${VERSION_GOENV}_checksums.txt"

#
# INSTALL
#

RUN curl -sOL ${URL_GOENV_CHECKSUMS} \
    && curl -sOL ${URL_GOENV} \
    && sha256sum -c "goenv_${VERSION_GOENV}_checksums.txt" --ignore-missing \
    && tar -xvf "goenv_${VERSION_GOENV}_linux_${TARGETARCH}.tar.gz" goenv \
    && chmod +x goenv \
    && mv goenv /usr/local/bin/ \
    && rm -f goenv_* \
    && echo "eval \"\$(goenv init -)\"" >> "${HOME}/.bashrc" \
    && echo "export PATH=\"\$GOPATH/bin:\$GOROOT/bin:\$PATH\"" >> "${HOME}/.bashrc"

# ##############################################################################
# SETUP: CUSTOM (AS DEV USER)
# ##############################################################################

USER "${DEFAULT_USER}"

WORKDIR "/home/${DEFAULT_USER}"

#
# ENV
#

ENV HOME="/home/${DEFAULT_USER}"
ENV LANG="${DEFAULT_LANG}"
ENV LANGUAGE="${DEFAULT_LANG}"
ENV LC_ALL="${DEFAULT_LANG}"
ENV PROMPT_COMMAND="history -a"
ENV HISTFILE="${HOME}/.history/.bash_history"
ENV GOENV_ROOT="${HOME}/.goenv"
ENV PATH="${HOME}/.local/bin:${GOENV_ROOT}/bin:${PATH}"

#
# GENERAL
#

RUN mkdir -p "${HOME}/.config" \
    && mkdir "${HOME}/.history" \
    && touch "${HOME}/.history/.bash_history" \
    && mkdir -p "${HOME}/.local/bin"

# ------------------------------------------------------------------------------
# INSTALL CLAUDE, SPEC-KIT, SBP-SKILLS AND RTK
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_CLAUDE="2.1.104"
ENV VERSION_RTK="0.38.0"

#
# INSTALL
#

RUN curl -fsSL -o /tmp/install.sh https://claude.ai/install.sh \
    && echo "b315b46925a9bfb9422f2503dd5aa649f680832f4c076b22d87c39d578c3d830  /tmp/install.sh" | sha256sum -c - \
    && chmod +x /tmp/install.sh \
    && /tmp/install.sh "${VERSION_CLAUDE}" \
    && rm -f /tmp/install.sh \
    && uv tool install specify-cli --from "git+https://github.com/github/spec-kit.git@da4f095a49b4adbb39e57966a5da6c686db0152d" # v0.7.3

RUN git clone "https://github.com/schubergphilis/agents.md.git" "${HOME}/.cache/sbp-skills/repo" \
    && cp "${HOME}/.cache/sbp-skills/repo/cli/sbp-skills" "${HOME}/.local/bin/sbp-skills" \
    && chmod +x "${HOME}/.local/bin/sbp-skills"

RUN curl -fsSL -o /tmp/install.sh https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh \
    && echo "0c46611d70d0eee64c43c6398f8b1fe057b7f0b052810bbeec09288898ba9a46  /tmp/install.sh" | sha256sum -c - \
    && chmod +x /tmp/install.sh \
    && RTK_VERSION="v${VERSION_RTK}" /tmp/install.sh \
    && rm -f /tmp/install.sh


# ------------------------------------------------------------------------------
# INSTALL NVM
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_NVM="0.40.4"
ENV URL_NVM="https://raw.githubusercontent.com/nvm-sh/nvm/v${VERSION_NVM}/install.sh"

#
# INSTALL
#

RUN curl -fsSL -o /tmp/install.sh "${URL_NVM}" \
    && echo "4b7412c49960c7d31e8df72da90c1fb5b8cccb419ac99537b737028d497aba4f  /tmp/install.sh" | sha256sum -c - \
    && chmod +x /tmp/install.sh \
    && /tmp/install.sh \
    && rm -f /tmp/install.sh

# ------------------------------------------------------------------------------
# INSTALL PYENV
# ------------------------------------------------------------------------------

#
# ENV
#

ENV URL_PYENV="https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer"
ENV VERSION_PYENV="2.6.27"
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/bin:$PATH"

#
# INSTALL
#

RUN curl -fsSL -o /tmp/pyenv-installer "${URL_PYENV}" \
    && echo "4b0adf623a6205727163eb98610b6c5e63f23b99183948b874d867cd9b30ef13  /tmp/pyenv-installer" | sha256sum -c - \
    && chmod +x /tmp/pyenv-installer \
    && PYENV_GIT_TAG="v${VERSION_PYENV}" /tmp/pyenv-installer \
    && rm -f /tmp/pyenv-installer \
    && echo "eval \"\$(pyenv init --path)\"" >> "${HOME}/.bashrc" \
    && echo "eval \"\$(pyenv virtualenv-init -)\"" >> "${HOME}/.bashrc"

# ------------------------------------------------------------------------------
# INSTALL RBENV
# ------------------------------------------------------------------------------

#
# ENV
#

ENV PATH="${HOME}/.rbenv/bin:$PATH"

#
# INSTALL
#

RUN git clone https://github.com/rbenv/rbenv.git "${HOME}/.rbenv" \
    && git clone https://github.com/rbenv/ruby-build.git "${HOME}/.rbenv/plugins/ruby-build" \
    && echo "eval \"\$(rbenv init - --no-rehash bash)\"" >> "${HOME}/.bashrc"


# ------------------------------------------------------------------------------
# INSTALL RUSTUP
# ------------------------------------------------------------------------------


RUN curl --proto '=https' --tlsv1.2 -fsSL -o /tmp/rustup-init.sh https://sh.rustup.rs \
    && echo "6c30b75a75b28a96fd913a037c8581b580080b6ee9b8169a3c0feb1af7fe8caf  /tmp/rustup-init.sh" | sha256sum -c - \
    && chmod +x /tmp/rustup-init.sh \
    && /tmp/rustup-init.sh -y --default-toolchain none \
    && rm -f /tmp/rustup-init.sh

# ------------------------------------------------------------------------------
# INSTALL TOOLS
# ------------------------------------------------------------------------------

#
# ENV
#

ENV VERSION_CHECKOV="3.2.521"
ENV VERSION_PIPENV="2026.6.1"
ENV VERSION_POETRY="2.4.0"
ENV VERSION_PRECOMMIT="4.6.0"

#
# PYTHON
#

RUN pipx install \
    "checkov==${VERSION_CHECKOV}" \
    "pre-commit==${VERSION_PRECOMMIT}" \
    "pipenv==${VERSION_PIPENV}" \
    "poetry==${VERSION_POETRY}"

# ------------------------------------------------------------------------------
# CONFIGURE DIRENV
# ------------------------------------------------------------------------------

RUN echo "eval \"\$(direnv hook bash)\"" >> "${HOME}/.bashrc"

# ------------------------------------------------------------------------------
# CONFIGURE ALIASES
# ------------------------------------------------------------------------------

RUN echo "alias ls=\"lsd\"" >> "${HOME}/.bashrc"

# ------------------------------------------------------------------------------
# CONFIGURE GOENV
# ------------------------------------------------------------------------------

RUN echo "eval \"\$(goenv init -)\"" >> "${HOME}/.bashrc"

# ##############################################################################
# RUN
# ##############################################################################

#
# Empty
#

# ------------------------------------------------------------------------------
# HEALTHCHECK
# ------------------------------------------------------------------------------

HEALTHCHECK NONE

# ------------------------------------------------------------------------------
# ENTRYPOINT
# ------------------------------------------------------------------------------

ENTRYPOINT [ ]

# ------------------------------------------------------------------------------
# COMMAND
# ------------------------------------------------------------------------------

CMD [ ]
