#!/bin/bash

set -e
set -o pipefail

if [[ -e /dev/snd ]]; then
	exec apulse firefox --no-remote
else
	exec firefox --no-remote
fi
