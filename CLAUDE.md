# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Docker container image built on Ubuntu 24.04, designed as a remote development environment for VS Code Dev Containers. It bundles multiple language version managers, infrastructure tools, and developer tooling into a single image published to ghcr.io.

## Build & test commands

This repo uses [Task](https://taskfile.dev) (`Taskfile.yml`) as the build system. Environment variables are loaded from `.env` (and optionally `.env.local`) via direnv.

```bash
task build    # Build Docker image(s) for configured platforms
task test     # Build test image and run BATS test suite
task lint     # Run hadolint against src/Dockerfile and src/Dockerfile.test
task scan     # Run checkov security scan with custom policies in policies/
task clean    # Remove built images
task release  # Multi-platform buildx push to registry (CI use)
```

To run a single test, build the test image manually and exec bats against a specific file:
```bash
docker run --rm <test-image> bats /tests/unittest.bats
```

## Architecture

### Image layers (`src/Dockerfile`)
The Dockerfile installs tooling in discrete RUN blocks grouped by concern: system packages, language version managers (nvm, pyenv, rbenv, goenv, rustup, tenv), infrastructure tools (tenv/terraform-docs/tflint, checkov, cosign), and developer tools (hadolint, task, uv, pre-commit, Claude CLI, specify, sbp-skills). Each downloaded binary is verified with SHA256. The final layers configure the `dev` user (non-root, sudo-enabled, `developers` primary group) and set up persistent bash history.

### Test image (`src/Dockerfile.test`)
Extends the main image, installs bats, copies `tests/` into the container, and sets bats as the entrypoint. Tests verify that each expected tool is on PATH and that user/group configuration is correct.

### Multi-architecture
Builds target `linux/arm64` and `linux/amd64` via Docker Buildx. Platform-specific download URLs are resolved inside the Dockerfile using `TARGETARCH`/`BUILDARCH` ARGs.

### CI/CD (`.github/workflows/pipeline.yml`)
Sequential jobs: `lint` → `scan` → `ci` (matrix per platform, runs `make test`) → `cd` (release, tag-only). Images are pushed to ghcr.io; OIDC attestations are generated on release.

## Key conventions

- **Hadolint config** (`.hadolint.yaml`): DL3008 (pin apt versions), DL3059 (consecutive RUN), and SC2155 are suppressed. `strict-labels: true` is enforced.
- **Checkov policies** live in `policies/` and are passed via `--external-checks-dir`.
- **Pre-commit hooks** include gitleaks (secret scanning) and conventional-commit message enforcement.
- **Version pinning**: all tool versions are defined as ARGs near the top of the Dockerfile and verified with checksums — update both together.
- **`dev` user filesystem**: `/home/dev/.history/` for persistent bash history; `/home/dev/.local/bin/` for user-installed binaries; Claude config mounted from host in devcontainer.
