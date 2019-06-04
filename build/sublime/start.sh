#!/bin/bash
set -e
set -o pipefail

COMMAND=/opt/sublime_text/sublime_text

exec "$COMMAND" -w
