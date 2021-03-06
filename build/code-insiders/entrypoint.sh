#!/bin/bash
set -e
set -o pipefail

# Set ENV locale and stuff
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export NO_AT_BRIDGE=1
export GOHOME=$HOME/go
export GOPATH=$GOHOME/bin
export RUSTPATH=$HOME/.cargo/bin
export PATH="$RUSTPATH:$GOPATH:$PATH"

# Start and configure ssh-agent
ssh-agent -D > .ssh_agent 2>&1 &
sleep 0.1 && cat .ssh_agent | head -n 1 > .ssh_cmd
export SSH_AUTH_SOCK=$(sed 's@SSH_AUTH_SOCK=@@' .ssh_cmd | sed 's@;.*@@') && ssh-add

# Start gpg daemon
gpg-agent --homedir="$HOME/.gnupg" --daemon &

# Run Programs
sh -c "/usr/share/code-insiders/code-insiders"
