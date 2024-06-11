#!/bin/bash

direnv allow /workspaces/*

sudo chown root:docker /var/run/docker.sock
sudo chmod g+w /var/run/docker.sock

ls -d /workspaces/* | xargs git config --global --add safe.directory

starship preset plain-text-symbols -o ~/.config/starship.toml
starship config container.disabled true
