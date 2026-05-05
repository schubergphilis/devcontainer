# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-05-05

### Added

- Installed [`rtk`](https://github.com/rtk-ai/rtk) v0.38.0 (RTK AI CLI) via installer script with SHA256 verification
- Installed [`pipenv`](https://pipenv.pypa.io) v2026.6.1 via `pipx`
- Installed [`poetry`](https://python-poetry.org) v2.4.0 via `pipx`
- Added `CLAUDE.md` with codebase guidance and conventions for Claude Code
- Added `.pre-commit-config.yaml` with gitleaks (secret scanning) and conventional-commit enforcement hooks
- Added `Taskfile.yml` as the primary build system, replacing `Makefile`

### Changed

- Replaced `Makefile` with `Taskfile.yml` for build orchestration (`task build`, `task test`, `task lint`, `task scan`, `task clean`, `task release`)
- Refactored and hardened tool installation blocks in `src/Dockerfile`: split into discrete, consistently structured `RUN` layers with SHA256 verification for all downloaded scripts
- Updated CI/CD pipeline (`.github/workflows/pipeline.yml`) with revised job structure and environment handling
- Updated `.devcontainer/devcontainer.json` and `hooks/post_attach.sh` for improved local dev setup
- Updated `.env` and `.envrc` with full project environment variable definitions
- Updated `.hadolint.yaml` configuration
- Updated `.gitignore` to cover additional local artifacts
- Updated `README.md` with full installed-software table including all tool versions

### Fixed

- Corrected `PROJECT_VERSION` value in `.env`
- Aligned BATS test suite (`tests/unittest.bats`) with refactored Dockerfile installation paths and tool names
