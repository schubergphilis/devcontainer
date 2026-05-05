[![Release Status](https://github.com/schubergphilis/devcontainer/actions/workflows/pipeline.yml/badge.svg)](https://github.com/schubergphilis/devcontainer/actions/workflows/pipeline.yml)

# devcontainer

This project defines a container image to be used as a development environment
inside [Visual Studio Code](https://code.visualstudio.com/) through the
[Remote Dev Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

## Table of Contents

- [What is devcontainer?](#what-is-devcontainer)
- [How can I use it?](#how-can-i-use-it)
- [Examples](#examples)
- [Installed Software](#installed-software)
- [Contributing](#contributing)
- [License](#license)

## What is devcontainer?

Devcontainer is a standard to define remote development environments using
containers and how editors and IDE's should integrate them. The standard is
described [here](https://containers.dev/).

## How can I use it?

First off, you need to use a text editor or IDE who supports devcontainers. The
most famous one is Visual Studio Code with the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
extension installed.

Your project should also define a `.devcontainer/devcontainer.json`
configuration that is loaded by the extension and then the remote environment
is built, started and attached to.

You can see the [grawsp](https://github.com/schubergphilis/grawsp/tree/main/.devcontainer)
project as an example. You can also read more about how to setup your own
development container in Visual Studio Code [here](https://code.visualstudio.com/docs/devcontainers/containers).

## Examples

Example of using this image directly in your `.devcontainer/devcontainer.json`:

```json
{
    "image": "ghcr.io/schubergphilis/devcontainer:latest"
}
```

You can also use it as a base image in your `Dockerfile`:

```
FROM ghcr.io/schubergphilis/devcontainer:latest
```

## Installed Software

The image is built on **Ubuntu 24.04 (Noble)** and bundles the following tools. All binaries are verified with SHA256 checksums at build time.

### Language Version Managers

| Tool | Version | Description |
|------|---------|-------------|
| [nvm](https://github.com/nvm-sh/nvm) | 0.40.4 | Node.js version manager |
| [pyenv](https://github.com/pyenv/pyenv) | 2.6.27 | Python version manager |
| [rbenv](https://github.com/rbenv/rbenv) + [ruby-build](https://github.com/rbenv/ruby-build) | latest | Ruby version manager |
| [goenv](https://github.com/go-nv/goenv) | 3.0.1 | Go version manager |
| [rustup](https://rustup.rs) | latest | Rust toolchain installer (no default toolchain) |
| [tenv](https://github.com/tofuutils/tenv) | 4.10.1 | Version manager for Terraform, OpenTofu, Terragrunt, and Atmos |

### Infrastructure & IaC Tools

| Tool | Version | Description |
|------|---------|-------------|
| [tenv](https://github.com/tofuutils/tenv) | 4.10.1 | Multi-version manager for Terraform / OpenTofu ecosystems |
| [terraform-docs](https://github.com/terraform-docs/terraform-docs) | 0.22.0 | Generate documentation from Terraform modules |
| [tflint](https://github.com/terraform-linters/tflint) | 0.61.0 | Terraform linter |
| [cosign](https://github.com/sigstore/cosign) | 3.0.6 | Container image signing and verification |

### Developer Tools

| Tool | Version | Description |
|------|---------|-------------|
| [task](https://taskfile.dev) | 3.50.0 | Task runner / build tool (Taskfile) |
| [uv](https://github.com/astral-sh/uv) | 0.11.7 | Fast Python package and project manager |
| [hadolint](https://github.com/hadolint/hadolint) | 2.14.0 | Dockerfile linter |
| [checkov](https://github.com/bridgecrewio/checkov) | 3.2.521 | Infrastructure-as-code security scanner |
| [pre-commit](https://pre-commit.com) | 4.6.0 | Git pre-commit hook framework |
| [Claude CLI](https://claude.ai/code) | 2.1.104 | Anthropic's Claude Code CLI |
| [specify-cli](https://github.com/github/spec-kit) | 0.7.3 | Specification toolkit |
| [sbp-skills](https://github.com/schubergphilis/agents.md) | latest | Schuberg Philis skill extensions for Claude Code |

## Contributing

Contributions are welcome. Please open a pull request or file an issue at
[schubergphilis/devcontainer](https://github.com/schubergphilis/devcontainer/issues).

When updating tool versions in `src/Dockerfile`, always update the corresponding
`ARG`/`ENV` version variable **and** the SHA256 checksum together. See the
[Key conventions](#key-conventions) section in [CLAUDE.md](./CLAUDE.md) for
further guidance on how this project is structured.

## License

```text
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the specific language governing
permissions and limitations under the License.
```
