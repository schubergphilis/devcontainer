#!/usr/bin/env bats

#
# DOCKER
#

@test "docker client is available" {
    run which docker
    [ "$status" -eq 0 ]
}

@test "docker compose plugin is available" {
    run docker compose version
    [ "$status" -eq 0 ]
}

@test "docker buildx plugin is available" {
    run docker buildx version
    [ "$status" -eq 0 ]
}

#
# USER
#

@test "dev user is created" {
    run bash -c "grep -E '^dev:x:' /etc/passwd"
    [ "$status" -eq 0 ]
}

@test "dev is the primary group of dev user" {
    run bash -c "id dev | grep -E 'gid=[0-9]+\(dev\)'"
    [ "$status" -eq 0 ]
}

@test "sudo is a secondary group of dev user" {
    run bash -c "id dev | grep -E 'groups=.*[0-9]+\(sudo\)'"
    [ "$status" -eq 0 ]
}

@test "docker is a secondary group of dev user" {
    run bash -c "id dev | grep -E 'groups=.*[0-9]+\(docker\)'"
    [ "$status" -eq 0 ]
}

#
# SYSTEM CONFIGURATION
#

@test "sudo is configured" {
    run ls /etc/sudoers.d/dev
    [ "$status" -eq 0 ]
}

#
# PACKAGES
#

@test "checkov is installed" {
    run which checkov
    [ "$status" -eq 0 ]
}

@test "curl is installed" {
    run which curl
    [ "$status" -eq 0 ]
}

@test "delta is installed" {
    run which delta
    [ "$status" -eq 0 ]
}

@test "direnv is installed" {
    run which direnv
    [ "$status" -eq 0 ]
}

@test "git is installed" {
    run which git
    [ "$status" -eq 0 ]
}

@test "gpg is installed" {
    run which gpg
    [ "$status" -eq 0 ]
}

@test "hadolint is installed" {
    run which hadolint
    [ "$status" -eq 0 ]
}

@test "make is installed" {
    run which git
    [ "$status" -eq 0 ]
}

@test "pipx is installed" {
    run which pipx
    [ "$status" -eq 0 ]
}

@test "poetry is installed" {
    run which poetry
    [ "$status" -eq 0 ]
}

@test "pre-commit is installed" {
    run which pre-commit
    [ "$status" -eq 0 ]
}

@test "pyenv is installed" {
    run which pyenv
    [ "$status" -eq 0 ]
}

@test "starship is installed" {
    run which starship
    [ "$status" -eq 0 ]
}

@test "sudo is installed" {
    run which sudo
    [ "$status" -eq 0 ]
}

@test "tfenv is installed" {
    run which tfenv
    [ "$status" -eq 0 ]
}

@test "unzip is installed" {
    run which unzip
    [ "$status" -eq 0 ]
}

@test "zip is installed" {
    run which unzip
    [ "$status" -eq 0 ]
}
