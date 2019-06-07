#!/bin/bash

set -e
set -o pipefail

protonmail-bridge --no-window &

thunderbird
