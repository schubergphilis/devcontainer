#!/usr/bin/env bats

# ##############################################################################
# TESTS
# ##############################################################################

# ------------------------------------------------------------------------------
# USER
# ------------------------------------------------------------------------------

@test "dev user is created" {
    run bash -c "grep -E '^dev:x:' /etc/passwd"
    [ "$status" -eq 0 ]
}

@test "developers is the primary group of dev user" {
    run bash -c "id dev | grep -E 'gid=[0-9]+\(developers\)'"
    [ "$status" -eq 0 ]
}

@test "sudo is a secondary group of dev user" {
    run bash -c "id dev | grep -E 'groups=.*[0-9]+\(sudo\)'"
    [ "$status" -eq 0 ]
}

# ------------------------------------------------------------------------------
# SYSTEM CONFIGURATION
# ------------------------------------------------------------------------------

@test "sudo is configured" {
    run ls /etc/sudoers.d/developers
    [ "$status" -eq 0 ]
}

# ------------------------------------------------------------------------------
# PACKAGES
# ------------------------------------------------------------------------------

@test "checkov is installed" {
    run which checkov
    [ "$status" -eq 0 ]
}

@test "claude is installed" {
    run which claude
    [ "$status" -eq 0 ]
}

@test "curl is installed" {
    run which curl
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

@test "goenv is installed" {
    run which goenv
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

@test "lsd is installed" {
    run which lsd
    [ "$status" -eq 0 ]
}

@test "make is installed" {
    run which git
    [ "$status" -eq 0 ]
}

@test "nvm is installed" {
    run ls ~/.nvm/nvm.sh
    [ "$status" -eq 0 ]
}

@test "pyenv is installed" {
    run which pyenv
    [ "$status" -eq 0 ]
}

@test "sbp-skills is installed" {
    run which sbp-skills
    [ "$status" -eq 0 ]
}

@test "specify is installed" {
    run which specify
    [ "$status" -eq 0 ]
}

@test "sudo is installed" {
    run which sudo
    [ "$status" -eq 0 ]
}

@test "task is installed" {
    run which task
    [ "$status" -eq 0 ]
}

@test "tenv is installed" {
    run which tenv
    [ "$status" -eq 0 ]
}

@test "terraform-docs is installed" {
    run which terraform-docs
    [ "$status" -eq 0 ]
}

@test "tflint is installed" {
    run which tflint
    [ "$status" -eq 0 ]
}

@test "unzip is installed" {
    run which unzip
    [ "$status" -eq 0 ]
}

@test "uv is installed" {
    run which uv
    [ "$status" -eq 0 ]
}

@test "wget is installed" {
    run which wget
    [ "$status" -eq 0 ]
}
